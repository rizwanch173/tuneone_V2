import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tuneone/pages.dart';
import 'package:tuneone/services_binder.dart';
import 'package:tuneone/ui/shared/styles.dart';
import 'package:audio_session/audio_session.dart';
import 'ui/singlechannel/single_radio_view.dart';
import 'package:rxdart/rxdart.dart' as rxt;

late AudioPlayerHandler audioHandler;

Future<void> main() async {
  audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandlerImpl(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      themes: <AppTheme>[
        AppTheme(
          id: "light",
          description: "light",
          data: ThemeData(
            // Real theme data
            primaryColor: Color(0xffFE6232),
            accentColor: Colors.red,
            fontFamily: 'Aeonik',
          ),
        ),
        AppTheme(
          id: "dark",
          description: "dark",
          data: ThemeData(
            // Real theme data
            primaryColor: darkBg,
            accentColor: Colors.red,
            fontFamily: 'Aeonik',
          ),
        )
      ],
      child: ThemeConsumer(
        child: Builder(
            builder: (themeContext) => GetMaterialApp(
                  theme: ThemeProvider.themeOf(themeContext).data,
                  smartManagement: SmartManagement.keepFactory,
                  initialBinding: ServicesBinder(),
                  getPages: pages,
                  debugShowCheckedModeBanner: false,
                  initialRoute: "/splash",
                )),
      ),
    );
  }
}

abstract class AudioPlayerHandler implements AudioHandler {
  Stream<QueueState> get queueState;
  Future<void> moveQueueItem(int currentIndex, int newIndex);
  rxt.ValueStream<double> get volume;
  Future<void> setVolume(double volume);
  rxt.ValueStream<double> get speed;
}

class AudioPlayerHandlerImpl extends BaseAudioHandler
    with SeekHandler
    implements AudioPlayerHandler {
  // ignore: close_sinks
  final rxt.BehaviorSubject<List<MediaItem>> _recentSubject =
      rxt.BehaviorSubject.seeded(<MediaItem>[]);
  final _mediaLibrary = MediaLibrary();
  final _player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);
  @override
  final rxt.BehaviorSubject<double> volume = rxt.BehaviorSubject.seeded(1.0);
  @override
  final rxt.BehaviorSubject<double> speed = rxt.BehaviorSubject.seeded(1.0);
  final _mediaItemExpando = Expando<MediaItem>();

  /// A stream of the current effective sequence from just_audio.
  Stream<List<IndexedAudioSource>> get _effectiveSequence =>
      rxt.Rx.combineLatest3<List<IndexedAudioSource>?, List<int>?, bool,
              List<IndexedAudioSource>?>(_player.sequenceStream,
          _player.shuffleIndicesStream, _player.shuffleModeEnabledStream,
          (sequence, shuffleIndices, shuffleModeEnabled) {
        if (sequence == null) return [];
        if (!shuffleModeEnabled) return sequence;
        if (shuffleIndices == null) return null;
        if (shuffleIndices.length != sequence.length) return null;
        return shuffleIndices.map((i) => sequence[i]).toList();
      }).whereType<List<IndexedAudioSource>>();

  /// Computes the effective queue index taking shuffle mode into account.
  int? getQueueIndex(
      int? currentIndex, bool shuffleModeEnabled, List<int>? shuffleIndices) {
    final effectiveIndices = _player.effectiveIndices ?? [];
    final shuffleIndicesInv = List.filled(effectiveIndices.length, 0);
    for (var i = 0; i < effectiveIndices.length; i++) {
      shuffleIndicesInv[effectiveIndices[i]] = i;
    }
    return (shuffleModeEnabled &&
            ((currentIndex ?? 0) < shuffleIndicesInv.length))
        ? shuffleIndicesInv[currentIndex ?? 0]
        : currentIndex;
  }

  /// A stream reporting the combined state of the current queue and the current
  /// media item within that queue.
  @override
  Stream<QueueState> get queueState => rxt.Rx.combineLatest3<List<MediaItem>,
          PlaybackState, List<int>, QueueState>(
      queue,
      playbackState,
      _player.shuffleIndicesStream.whereType<List<int>>(),
      (queue, playbackState, shuffleIndices) => QueueState(
            queue,
            playbackState.queueIndex,
            playbackState.shuffleMode == AudioServiceShuffleMode.all
                ? shuffleIndices
                : null,
            playbackState.repeatMode,
          )).where((state) =>
      state.shuffleIndices == null ||
      state.queue.length == state.shuffleIndices!.length);

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode mode) async {
    final enabled = mode == AudioServiceShuffleMode.all;
    if (enabled) {
      await _player.shuffle();
    }
    playbackState.add(playbackState.value.copyWith(shuffleMode: mode));
    await _player.setShuffleModeEnabled(enabled);
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    playbackState.add(playbackState.value.copyWith(repeatMode: repeatMode));
    await _player.setLoopMode(LoopMode.values[repeatMode.index]);
  }

  @override
  Future<void> setSpeed(double speed) async {
    this.speed.add(speed);
    await _player.setSpeed(speed);
  }

  @override
  Future<void> setVolume(double volume) async {
    this.volume.add(volume);
    await _player.setVolume(volume);
  }

  AudioPlayerHandlerImpl() {
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Broadcast speed changes. Debounce so that we don't flood the notification
    // with updates.
    speed.debounceTime(const Duration(milliseconds: 250)).listen((speed) {
      playbackState.add(playbackState.value.copyWith(speed: speed));
    });
    // Load and broadcast the initial queue
    await updateQueue(_mediaLibrary.items[MediaLibrary.albumsRootId]!);
    // For Android 11, record the most recent item so it can be resumed.
    mediaItem
        .whereType<MediaItem>()
        .listen((item) => _recentSubject.add([item]));
    // Broadcast media item changes.
    rxt.Rx.combineLatest4<int?, List<MediaItem>, bool, List<int>?, MediaItem?>(
        _player.currentIndexStream,
        queue,
        _player.shuffleModeEnabledStream,
        _player.shuffleIndicesStream,
        (index, queue, shuffleModeEnabled, shuffleIndices) {
      final queueIndex =
          getQueueIndex(index, shuffleModeEnabled, shuffleIndices);
      return (queueIndex != null && queueIndex < queue.length)
          ? queue[queueIndex]
          : null;
    }).whereType<MediaItem>().distinct().listen(mediaItem.add);
    // Propagate all events from the audio player to AudioService clients.
    _player.playbackEventStream.listen(_broadcastState);
    _player.shuffleModeEnabledStream
        .listen((enabled) => _broadcastState(_player.playbackEvent));
    // In this example, the service stops when reaching the end.
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        stop();
        _player.seek(Duration.zero, index: 0);
      }
    });
    // Broadcast the current queue.
    _effectiveSequence
        .map((sequence) =>
            sequence.map((source) => _mediaItemExpando[source]!).toList())
        .pipe(queue);
    // Load the playlist.
    _playlist.addAll(queue.value.map(_itemToSource).toList());
    await _player.setAudioSource(_playlist);
  }

  AudioSource _itemToSource(MediaItem mediaItem) {
    final audioSource = AudioSource.uri(Uri.parse(mediaItem.id));
    _mediaItemExpando[audioSource] = mediaItem;
    return audioSource;
  }

  List<AudioSource> _itemsToSources(List<MediaItem> mediaItems) =>
      mediaItems.map(_itemToSource).toList();

  @override
  Future<List<MediaItem>> getChildren(String parentMediaId,
      [Map<String, dynamic>? options]) async {
    switch (parentMediaId) {
      case AudioService.recentRootId:
        // When the user resumes a media session, tell the system what the most
        // recently played item was.
        return _recentSubject.value;
      default:
        // Allow client to browse the media library.
        return _mediaLibrary.items[parentMediaId]!;
    }
  }

  @override
  rxt.ValueStream<Map<String, dynamic>> subscribeToChildren(
      String parentMediaId) {
    switch (parentMediaId) {
      case AudioService.recentRootId:
        final stream = _recentSubject.map((_) => <String, dynamic>{});
        return _recentSubject.hasValue
            ? stream.shareValueSeeded(<String, dynamic>{})
            : stream.shareValue();
      default:
        return Stream.value(_mediaLibrary.items[parentMediaId])
            .map((_) => <String, dynamic>{})
            .shareValue();
    }
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    await _playlist.add(_itemToSource(mediaItem));
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    await _playlist.addAll(_itemsToSources(mediaItems));
  }

  @override
  Future<void> insertQueueItem(int index, MediaItem mediaItem) async {
    await _playlist.insert(index, _itemToSource(mediaItem));
  }

  @override
  Future<void> updateQueue(List<MediaItem> newQueue) async {
    print("called update");
    await _playlist.clear();
    await _playlist.addAll(_itemsToSources(newQueue));
    print(_playlist.length);
  }

  @override
  Future<void> updateMediaItem(MediaItem mediaItem) async {
    final index = queue.value.indexWhere((item) => item.id == mediaItem.id);
    _mediaItemExpando[_player.sequence![index]] = mediaItem;
  }

  @override
  Future<void> removeQueueItem(MediaItem mediaItem) async {
    final index = queue.value.indexOf(mediaItem);
    await _playlist.removeAt(index);
  }

  @override
  Future<void> moveQueueItem(int currentIndex, int newIndex) async {
    await _playlist.move(currentIndex, newIndex);
  }

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= _playlist.children.length) return;
    // This jumps to the beginning of the queue item at [index].
    _player.seek(Duration.zero,
        index: _player.shuffleModeEnabled
            ? _player.shuffleIndices![index]
            : index);
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() async {
    await _player.stop();
    await playbackState.firstWhere(
        (state) => state.processingState == AudioProcessingState.idle);
  }

  /// Broadcasts the current state to all clients.
  void _broadcastState(PlaybackEvent event) {
    final playing = _player.playing;
    final queueIndex = getQueueIndex(
        event.currentIndex, _player.shuffleModeEnabled, _player.shuffleIndices);
    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.skipToPrevious,
        if (playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: queueIndex,
    ));
  }
}

/// This task defines logic for playing a list of podcast episodes.
// class AudioPlayerTask extends BackgroundAudioTask {
// //var xx=  MediaItem.fromJson(raw)
//
//   AudioPlayer _player = new AudioPlayer();
//   AudioProcessingState? _skipState;
//   Seeker? _seeker;
//   late StreamSubscription<PlaybackEvent> _eventSubscription;
//
//   var mediadata = MediaLibrary();
//
//   //List<MediaItem> get queue => mediadata.items;
//   int? get index => _player.currentIndex;
//   MediaItem? get mediaItem => index == null ? null : mediadata.items[index!];
//
//   @override
//   Future<void> onStart(Map<String, dynamic>? params) async {
//     print("start audio");
//     // We configure the audio session for speech since we're playing a podcast.
//     // You can also put this in your app's initialisation if your app doesn't
//     // switch between two types of audio as this example does.
//     final session = await AudioSession.instance;
//     await session.configure(AudioSessionConfiguration.speech());
//     // Broadcast media item changes.
//     _player.currentIndexStream.listen((index) {
//       print("indexkkkk");
//       print(index);
//       if (index != null)
//         AudioServiceBackground.setMediaItem(mediadata.items[index]);
//     });
//     // Propagate all events from the audio player to AudioService clients.
//     _eventSubscription = _player.playbackEventStream.listen((event) {
//       _broadcastState();
//     });
//     // Special processing for state transitions.
//     _player.processingStateStream.listen((state) {
//       switch (state) {
//         case ProcessingState.completed:
//           // In this example, the service stops when reaching the end.
//           onStop();
//           break;
//         case ProcessingState.ready:
//           // If we just came from skipping between tracks, clear the skip
//           // state now that we're ready to play.
//           _skipState = null;
//           break;
//         default:
//           break;
//       }
//     });
//
//     // // Load and broadcast the queue
//     // AudioServiceBackground.setQueue(mediadata.items);
//     // try {
//     //   await _player.setAudioSource(ConcatenatingAudioSource(
//     //     children: mediadata.items
//     //         .map((item) => AudioSource.uri(Uri.parse(item.id)))
//     //         .toList(),
//     //   ));
//     //   // In this example, we automatically start playing on start.
//     //   onPlay();
//     // } catch (e) {
//     //   print("Error: $e");
//     //   onStop();
//     // }
//   }
//
//   @override
//   Future<void> onUpdateQueue(List<MediaItem> newqueue) async {
//     print("func called");
//     print(newqueue.length);
//     print(mediadata._items.length);
//     mediadata.setmideiitem = newqueue;
//     print(mediadata._items.length);
//     AudioServiceBackground.setQueue(mediadata._items);
//     try {
//       await _player.setAudioSource(ConcatenatingAudioSource(
//         children: mediadata.items
//             .map((item) => AudioSource.uri(Uri.parse(item.id)))
//             .toList(),
//       ));
//       // In this example, we automatically start playing on start.
//       onPlay();
//     } catch (e) {
//       print("Error: $e");
//       onStop();
//     }
//   }
//
//   @override
//   Future<void> onSkipToQueueItem(String mediaId) async {
//     print("skip");
//     // Then default implementations of onSkipToNext and onSkipToPrevious will
//     // delegate to this method.
//     final newIndex = mediadata._items.indexWhere((item) => item.id == mediaId);
//     if (newIndex == -1) return;
//     // During a skip, the player may enter the buffering state. We could just
//     // propagate that state directly to AudioService clients but AudioService
//     // has some more specific states we could use for skipping to next and
//     // previous. This variable holds the preferred state to send instead of
//     // buffering during a skip, and it is cleared as soon as the player exits
//     // buffering (see the listener in onStart).
//     _skipState = newIndex > index!
//         ? AudioProcessingState.skippingToNext
//         : AudioProcessingState.skippingToPrevious;
//     // This jumps to the beginning of the queue item at newIndex.
//     _player.seek(Duration.zero, index: newIndex);
//     // Demonstrate custom events.
//     AudioServiceBackground.sendCustomEvent('skip to $newIndex');
//   }
//
//   @override
//   Future<void> onPlay() => _player.play();
//
//   @override
//   Future<void> onPause() => _player.pause();
//
//   @override
//   Future<void> onSeekTo(Duration position) => _player.seek(position);
//
//   @override
//   Future<void> onFastForward() => _seekRelative(fastForwardInterval);
//
//   @override
//   Future<void> onRewind() => _seekRelative(-rewindInterval);
//
//   @override
//   Future<void> onSeekForward(bool begin) async => _seekContinuously(begin, 1);
//
//   @override
//   Future<void> onSeekBackward(bool begin) async => _seekContinuously(begin, -1);
//
//   @override
//   Future<void> onStop() async {
//     await _player.dispose();
//     _eventSubscription.cancel();
//     // It is important to wait for this state to be broadcast before we shut
//     // down the task. If we don't, the background task will be destroyed before
//     // the message gets sent to the UI.
//     await _broadcastState();
//     // Shut down this task
//     await super.onStop();
//   }
//
//   /// Jumps away from the current position by [offset].
//   Future<void> _seekRelative(Duration offset) async {
//     var newPosition = _player.position + offset;
//     // Make sure we don't jump out of bounds.
//     if (newPosition < Duration.zero) newPosition = Duration.zero;
//     if (newPosition > mediaItem!.duration!) newPosition = mediaItem!.duration!;
//     // Perform the jump via a seek.
//     await _player.seek(newPosition);
//   }
//
//   /// Begins or stops a continuous seek in [direction]. After it begins it will
//   /// continue seeking forward or backward by 10 seconds within the audio, at
//   /// intervals of 1 second in app time.
//   void _seekContinuously(bool begin, int direction) {
//     _seeker?.stop();
//     if (begin) {
//       _seeker = Seeker(_player, Duration(seconds: 10 * direction),
//           Duration(seconds: 1), mediaItem!)
//         ..start();
//     }
//   }
//
//   /// Broadcasts the current state to all clients.
//   Future<void> _broadcastState() async {
//     await AudioServiceBackground.setState(
//       controls: [
//         MediaControl.skipToPrevious,
//         if (_player.playing) MediaControl.pause else MediaControl.play,
//         MediaControl.stop,
//         MediaControl.skipToNext,
//       ],
//       systemActions: [
//         MediaAction.seekTo,
//         MediaAction.seekForward,
//         MediaAction.seekBackward,
//       ],
//       androidCompactActions: [0, 1, 3],
//       processingState: _getProcessingState(),
//       playing: _player.playing,
//       position: _player.position,
//       bufferedPosition: _player.bufferedPosition,
//       speed: _player.speed,
//     );
//   }
//
//   /// Maps just_audio's processing state into into audio_service's playing
//   /// state. If we are in the middle of a skip, we use [_skipState] instead.
//   AudioProcessingState _getProcessingState() {
//     if (_skipState != null) return _skipState!;
//     switch (_player.processingState) {
//       case ProcessingState.idle:
//         return AudioProcessingState.stopped;
//       case ProcessingState.loading:
//         return AudioProcessingState.connecting;
//       case ProcessingState.buffering:
//         return AudioProcessingState.buffering;
//       case ProcessingState.ready:
//         return AudioProcessingState.ready;
//       case ProcessingState.completed:
//         return AudioProcessingState.completed;
//       default:
//         throw Exception("Invalid state: ${_player.processingState}");
//     }
//   }
// }

class Seeker {
  final AudioPlayer player;
  final Duration positionInterval;
  final Duration stepInterval;
  final MediaItem mediaItem;
  bool _running = false;

  Seeker(
    this.player,
    this.positionInterval,
    this.stepInterval,
    this.mediaItem,
  );

  start() async {
    _running = true;
    while (_running) {
      Duration newPosition = player.position + positionInterval;
      if (newPosition < Duration.zero) newPosition = Duration.zero;
      if (newPosition > mediaItem.duration!) newPosition = mediaItem.duration!;
      player.seek(newPosition);
      await Future.delayed(stepInterval);
    }
  }

  stop() {
    _running = false;
  }
}

// Provides access to a library of media items. In your app, this could come
/// from a database or web service.
class MediaLibrary {
  static const albumsRootId = 'albums';
  static const albumsRootId2 = 'albums2';

  final items = <String, List<MediaItem>>{
    AudioService.browsableRootId: const [
      MediaItem(
        id: albumsRootId,
        title: "Albums",
        playable: false,
      ),
      MediaItem(
        id: albumsRootId2,
        title: "albums2",
        playable: false,
      ),
    ],
    albumsRootId: [
      MediaItem(
        id: "https://radio.tuneonehosting.com/radio/8010/radio.mp3?azuracast",
        album: "Aigle+ Radio",
        title: "Aigle+ Radio",
        artist: "Aigle+ Radio",
        //  duration: Duration(milliseconds: 2856950),
        artUri: Uri.parse(
            "https://tuneoneradio.com/wp-content/uploads/2021/04/FullColor_1280x1024_72dpi.png"),
      ),
    ],
    // albumsRootId2: [
    //   MediaItem(
    //     id: "https://radio.tuneonehosting.com/radio/8010/radio.mp3?azuracast",
    //     album: "ri Fridayfgfdshgh",
    //     title: "From Cat Rheology To Operatic Incompetencefdhfhd",
    //     artist: "Science Friday and WNYC Studiosdsggdfs",
    //     duration: Duration(milliseconds: 2856950),
    //     artUri: Uri.parse(
    //         "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
    //   ),
    // ],
  };
}

class QueueState {
  static final QueueState empty =
      QueueState([], 0, [], AudioServiceRepeatMode.none);

  final List<MediaItem> queue;
  final int? queueIndex;
  final List<int>? shuffleIndices;
  final AudioServiceRepeatMode repeatMode;

  QueueState(this.queue, this.queueIndex, this.shuffleIndices, this.repeatMode);

  bool get hasPrevious =>
      repeatMode != AudioServiceRepeatMode.none || (queueIndex ?? 0) > 0;
  bool get hasNext =>
      repeatMode != AudioServiceRepeatMode.none ||
      (queueIndex ?? 0) + 1 < queue.length;

  List<int> get indices =>
      shuffleIndices ?? List.generate(queue.length, (i) => i);
}
