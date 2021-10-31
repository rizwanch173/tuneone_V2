import 'dart:async';
import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:line_icons/line_icons.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tuneone/Services/remote_services.dart';
import 'package:tuneone/controllers/data_controller.dart';
import 'package:tuneone/controllers/home_controllers.dart';
import 'package:tuneone/controllers/podcast_controller.dart';
import 'package:tuneone/controllers/radio_controller.dart';
import 'package:tuneone/ui/library/library_view.dart';
import 'package:tuneone/ui/shared/styles.dart';
import 'package:rxdart/rxdart.dart' as Rxt;
import 'package:audio_session/audio_session.dart';
import 'package:tuneone/ui/styled_widgets/cached_network_image.dart';

// NOTE: Your entrypoint MUST be a top-level function.
void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class SinglePodcastView extends StatelessWidget {
  final DataController dataController = Get.find();
  final RadioController radioController = Get.find();
  final HomeController homeController = Get.find();
  final PodcastController podcastController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        decoration: BoxDecoration(
          image: ThemeProvider.themeOf(context).id == "light"
              ? DecorationImage(
                  image: AssetImage("assets/lightBg.png"), fit: BoxFit.cover)
              : DecorationImage(
                  image: AssetImage("assets/darkBg.png"), fit: BoxFit.cover),
        ),
        child: Obx(() {
          return Column(
            children: [
              Container(
                height: 0,
                width: 0,
                child: Text(
                  radioController.platformVersion.value,
                ),
              ),
              Expanded(
                child: StreamBuilder<bool>(
                    stream: AudioService.runningStream,
                    builder: (context, snapshot) {
                      final running = snapshot.data ?? false;
                      return StreamBuilder<QueueState>(
                          stream: _queueStateStream,
                          builder: (context, snapshot) {
                            final queueState = snapshot.data;
                            final queue = queueState?.queue ?? [];
                            final mediaItem = queueState?.mediaItem;
                            return Container(
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Get.width * 0.05),
                                    child: Column(children: [
                                      SizedBox(
                                        height: kToolbarHeight,
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: IconButton(
                                          icon: Icon(Icons.arrow_back_ios),
                                          color: Colors.white,
                                          onPressed: () {
                                            Get.back();
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: Get.height * 0.02,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            child: Icon(
                                              LineIcons.stepBackward,
                                              color: Colors.white,
                                            ),
                                            onTap: () async {
                                              if (running) {
                                                if (homeController
                                                        .indexToPlayPod ==
                                                    0) {
                                                  homeController
                                                          .indexToPlayPod =
                                                      dataController.podcastList
                                                              .length -
                                                          1;
                                                  await AudioService
                                                      .skipToQueueItem(
                                                          dataController
                                                              .mediaListPodcast[
                                                                  homeController
                                                                      .indexToPlayPod]
                                                              .id);
                                                } else {
                                                  homeController
                                                      .indexToPlayPod -= 1;
                                                  await AudioService
                                                      .skipToQueueItem(
                                                          dataController
                                                              .mediaListPodcast[
                                                                  homeController
                                                                      .indexToPlayPod]
                                                              .id);
                                                }
                                              } else {
                                                if (homeController
                                                        .indexToPlayPod ==
                                                    0) {
                                                  homeController
                                                          .indexToPlayPod =
                                                      dataController.podcastList
                                                              .length -
                                                          1;
                                                } else {
                                                  homeController
                                                      .indexToPlayPod -= 1;
                                                }
                                              }
                                            },
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Obx(
                                            () => Align(
                                              child: Container(
                                                width: Get.width * 0.60,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: MarqueeText(
                                                    text: TextSpan(
                                                      text: dataController
                                                          .podcastList[
                                                              homeController
                                                                  .indexToPlayPod]
                                                          .title,
                                                    ),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                    speed: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          GestureDetector(
                                              child: Icon(
                                                LineIcons.stepForward,
                                                color: Colors.white,
                                              ),
                                              onTap: () async {
                                                if (running) {
                                                  if (homeController
                                                          .indexToPlayPod ==
                                                      dataController.podcastList
                                                              .length -
                                                          1) {
                                                    homeController
                                                            .indexToPlayPod =
                                                        homeController
                                                            .indexToPlayPod = 0;
                                                    await AudioService.skipToQueueItem(
                                                        dataController
                                                            .mediaListPodcast[
                                                                homeController
                                                                    .indexToPlayPod]
                                                            .id);
                                                  } else {
                                                    homeController
                                                        .indexToPlayPod += 1;
                                                    await AudioService.skipToQueueItem(
                                                        dataController
                                                            .mediaListPodcast[
                                                                homeController
                                                                    .indexToPlayPod]
                                                            .id);
                                                  }
                                                } else {
                                                  if (homeController
                                                          .indexToPlayPod ==
                                                      dataController.podcastList
                                                              .length -
                                                          1) {
                                                    homeController
                                                            .indexToPlayPod =
                                                        homeController
                                                            .indexToPlayPod = 0;
                                                  } else {
                                                    homeController
                                                        .indexToPlayPod += 1;
                                                  }
                                                }
                                              }),
                                        ],
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Obx(
                                          () => Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  border: Border.all(
                                                    width: 2,
                                                    color:
                                                        ThemeProvider.themeOf(
                                                                        context)
                                                                    .id ==
                                                                "light"
                                                            ? backGroundColor
                                                            : darkTxt,
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: AspectRatio(
                                                    aspectRatio: 1 / 1,
                                                    child:
                                                        StyledCachedNetworkImage2(
                                                      url: dataController
                                                          .podcastList[
                                                              homeController
                                                                  .indexToPlayPod]
                                                          .thumbnail,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              AutoSizeText(
                                                dataController
                                                    .podcastList[homeController
                                                        .indexToPlayPod]
                                                    .author
                                                    .displayName,
                                                style: TextStyle(
                                                    color: Colors.white),
                                                presetFontSizes: [18, 16],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: StreamBuilder<MediaState>(
                                          stream: _mediaStateStream,
                                          builder: (context, snapshot) {
                                            final mediaState = snapshot.data;
                                            return running
                                                ? SeekBar(
                                                    duration: mediaState
                                                            ?.mediaItem
                                                            ?.duration ??
                                                        Duration.zero,
                                                    position:
                                                        mediaState?.position ??
                                                            Duration.zero,
                                                    onChangeEnd: (newPosition) {
                                                      AudioService.seekTo(
                                                          newPosition);
                                                    },
                                                  )
                                                : SeekBar2(
                                                    duration: mediaState
                                                            ?.mediaItem
                                                            ?.duration ??
                                                        Duration.zero,
                                                    position:
                                                        mediaState?.position ??
                                                            Duration.zero,
                                                    onChangeEnd: (newPosition) {
                                                      AudioService.seekTo(
                                                          newPosition);
                                                    },
                                                  );
                                          },
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          GestureDetector(
                                            child: Icon(
                                              Icons.replay,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                            onTap: () async {
                                              AudioPlayer _player =
                                                  new AudioPlayer();

                                              if (running) {
                                                AudioService.seekTo(Duration());
                                                await _player.seek(Duration(
                                                    seconds: _player.position
                                                            .inMinutes +
                                                        0));
                                              }
                                            },
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              if (running) {
                                                if (homeController
                                                        .indexToPlayPod ==
                                                    0) {
                                                  homeController
                                                          .indexToPlayPod =
                                                      dataController.podcastList
                                                              .length -
                                                          1;
                                                  await AudioService
                                                      .skipToQueueItem(
                                                          dataController
                                                              .mediaListPodcast[
                                                                  homeController
                                                                      .indexToPlayPod]
                                                              .id);
                                                } else {
                                                  homeController
                                                      .indexToPlayPod -= 1;
                                                  await AudioService
                                                      .skipToQueueItem(
                                                          dataController
                                                              .mediaListPodcast[
                                                                  homeController
                                                                      .indexToPlayPod]
                                                              .id);
                                                }
                                              } else {
                                                if (homeController
                                                        .indexToPlayPod ==
                                                    0) {
                                                  homeController
                                                          .indexToPlayPod =
                                                      dataController.podcastList
                                                              .length -
                                                          1;
                                                } else {
                                                  homeController
                                                      .indexToPlayPod -= 1;
                                                }
                                              }
                                            },
                                            child: Icon(
                                                Icons.skip_previous_outlined,
                                                color: Colors.white,
                                                size: 40),
                                          ),
                                          Container(
                                              height: 50,
                                              width: 50,
                                              // padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child: StreamBuilder<bool>(
                                                  stream: AudioService
                                                      .playbackStateStream
                                                      .map((state) =>
                                                          state.playing)
                                                      .distinct(),
                                                  builder: (context, snapshot) {
                                                    final playing =
                                                        snapshot.data ?? false;

                                                    return IconButton(
                                                        onPressed: () async {
                                                          dataController.addRecently(
                                                              dataController
                                                                      .podcastListMasterCopy[
                                                                  homeController
                                                                      .indexToPlayPod],
                                                              true);
                                                          podcastController
                                                                  .indexX =
                                                              homeController
                                                                  .indexToPlayPod;
                                                          if (homeController
                                                                      .whoAccess
                                                                      .value ==
                                                                  "radio" &&
                                                              running) {
                                                            await AudioService
                                                                .updateQueue(
                                                                    dataController
                                                                        .mediaListPodcast);
                                                            await AudioService.skipToQueueItem(
                                                                dataController
                                                                    .mediaListPodcast[
                                                                        homeController
                                                                            .indexToPlayPod]
                                                                    .id);
                                                            await AudioService
                                                                .play();
                                                            homeController
                                                                .whoAccess
                                                                .value = "pod";
                                                          } else {
                                                            print(
                                                                "else of radio");
                                                            if (playing) {
                                                              podcastController
                                                                  .indexX = -2;
                                                              if (AudioService
                                                                      .currentMediaItem!
                                                                      .id ==
                                                                  dataController
                                                                      .mediaListPodcast[
                                                                          homeController
                                                                              .indexToPlayPod]
                                                                      .id) {
                                                                AudioService
                                                                    .pause();
                                                              } else {
                                                                print(
                                                                    "after pause and play");
                                                                if (AudioService
                                                                        .currentMediaItem!
                                                                        .id !=
                                                                    dataController
                                                                        .mediaListPodcast[
                                                                            homeController.indexToPlayPod]
                                                                        .id) {
                                                                  await AudioService.skipToQueueItem(
                                                                      dataController
                                                                          .mediaListPodcast[
                                                                              homeController.indexToPlayPod]
                                                                          .id);
                                                                }

                                                                AudioService
                                                                    .play();
                                                              }
                                                            } else {
                                                              print(
                                                                  "not running");
                                                              print(dataController
                                                                  .mediaListPodcast
                                                                  .length);
                                                              if (!running) {
                                                                AudioService
                                                                    .start(
                                                                  backgroundTaskEntrypoint:
                                                                      _audioPlayerTaskEntrypoint,

                                                                  androidNotificationChannelName:
                                                                      'Audio Service Demo',
                                                                  // Enable this if you want the Android service to exit the foreground state on pause.
                                                                  //androidStopForegroundOnPause: true,
                                                                  androidNotificationColor:
                                                                      0xFF2196f3,
                                                                  androidNotificationIcon:
                                                                      'mipmap/ic_launcher',
                                                                  androidEnableQueue:
                                                                      true,
                                                                ).then(
                                                                    (value) async {
                                                                  await AudioService
                                                                      .updateQueue(
                                                                          dataController
                                                                              .mediaListPodcast);
                                                                  AudioService.skipToQueueItem(
                                                                      dataController
                                                                          .mediaListPodcast[
                                                                              homeController.indexToPlayPod]
                                                                          .id);
                                                                  print(
                                                                      "start call");
                                                                  homeController
                                                                      .whoAccess
                                                                      .value = "pod";
                                                                  //  AudioService.pause();
                                                                });
                                                              } else {
                                                                print(
                                                                    "after pause and play 2");
                                                                if (AudioService
                                                                        .currentMediaItem!
                                                                        .id !=
                                                                    dataController
                                                                        .mediaListPodcast[
                                                                            homeController.indexToPlayPod]
                                                                        .id) {
                                                                  await AudioService.skipToQueueItem(
                                                                      dataController
                                                                          .mediaListPodcast[
                                                                              homeController.indexToPlayPod]
                                                                          .id);
                                                                }

                                                                AudioService
                                                                    .play();
                                                              }
                                                            }
                                                          }
                                                        },
                                                        icon: (podcastController
                                                                        .indexX ==
                                                                    homeController
                                                                        .indexToPlayPod &&
                                                                !playing)
                                                            ? CupertinoActivityIndicator()
                                                            : playing
                                                                ? AudioService
                                                                            .currentMediaItem!
                                                                            .id !=
                                                                        dataController
                                                                            .mediaListPodcast[homeController.indexToPlayPod]
                                                                            .id
                                                                    ? Icon(
                                                                        Icons
                                                                            .play_arrow,
                                                                        size:
                                                                            30,
                                                                        color: Theme.of(context)
                                                                            .primaryColor,
                                                                      )
                                                                    : Icon(
                                                                        Icons
                                                                            .pause,
                                                                        size:
                                                                            30,
                                                                        color: Theme.of(context)
                                                                            .primaryColor,
                                                                      )
                                                                : Icon(
                                                                    Icons
                                                                        .play_arrow,
                                                                    size: 30,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                  ));
                                                  })),
                                          GestureDetector(
                                            onTap: () async {
                                              if (running) {
                                                if (homeController
                                                        .indexToPlayPod ==
                                                    dataController.podcastList
                                                            .length -
                                                        1) {
                                                  homeController
                                                          .indexToPlayPod =
                                                      homeController
                                                          .indexToPlayPod = 0;
                                                  await AudioService
                                                      .skipToQueueItem(
                                                          dataController
                                                              .mediaListPodcast[
                                                                  homeController
                                                                      .indexToPlayPod]
                                                              .id);
                                                } else {
                                                  homeController
                                                      .indexToPlayPod += 1;
                                                  await AudioService
                                                      .skipToQueueItem(
                                                          dataController
                                                              .mediaListPodcast[
                                                                  homeController
                                                                      .indexToPlayPod]
                                                              .id);
                                                }
                                              } else {
                                                if (homeController
                                                        .indexToPlayPod ==
                                                    dataController.podcastList
                                                            .length -
                                                        1) {
                                                  homeController
                                                          .indexToPlayPod =
                                                      homeController
                                                          .indexToPlayPod = 0;
                                                } else {
                                                  homeController
                                                      .indexToPlayPod += 1;
                                                }
                                              }
                                            },
                                            child: Icon(
                                                Icons.skip_next_outlined,
                                                color: Colors.white,
                                                size: 40),
                                          ),
                                          dataController.islogin.isFalse
                                              ? GestureDetector(
                                                  onTap: () {
                                                    Get.toNamed("/authoption");
                                                  },
                                                  child: Icon(
                                                    Icons
                                                        .favorite_outline_sharp,
                                                    color: Colors.white,
                                                    size: 40,
                                                  ),
                                                )
                                              : Obx(
                                                  () => !dataController.likeList
                                                          .contains(dataController
                                                              .podcastList[
                                                                  homeController
                                                                      .indexToPlayPod]
                                                              .id)
                                                      ? GestureDetector(
                                                          onTap: () async {
                                                            var response = await RemoteServices.likeDislike(
                                                                like: true,
                                                                postId: dataController
                                                                    .podcastList[
                                                                        homeController
                                                                            .indexToPlayPod]
                                                                    .id);
                                                          },
                                                          child: Icon(
                                                            Icons
                                                                .favorite_outline_sharp,
                                                            color: Colors.white,
                                                            size: 40,
                                                          ),
                                                        )
                                                      : GestureDetector(
                                                          onTap: () async {
                                                            var response = await RemoteServices.likeDislike(
                                                                like: false,
                                                                postId: dataController
                                                                    .podcastList[
                                                                        homeController
                                                                            .indexToPlayPod]
                                                                    .id);
                                                          },
                                                          child: Icon(
                                                            Icons
                                                                .favorite_outlined,
                                                            color: Colors.white,
                                                            size: 40,
                                                          ),
                                                        ),
                                                ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: kBottomNavigationBarHeight,
                                      )
                                    ])));
                          });
                    }),
              ),
            ],
          );
        }),
      ),
    );
  }

  IconButton playButton() => IconButton(
        icon: Icon(Icons.play_arrow),
        iconSize: 30.0,
        color: darkTxt,
        onPressed: AudioService.play,
      );

  IconButton pauseButton() => IconButton(
        icon: Icon(Icons.pause),
        iconSize: 30.0,
        color: darkTxt,
        onPressed: AudioService.pause,
      );

  /// A stream reporting the combined state of the current media item and its
  /// current position.
  Stream<MediaState> get _mediaStateStream =>
      Rxt.Rx.combineLatest2<MediaItem?, Duration, MediaState>(
          AudioService.currentMediaItemStream,
          AudioService.positionStream,
          (mediaItem, position) => MediaState(mediaItem, position));

  /// A stream reporting the combined state of the current queue and the current
  /// media item within that queue.
  Stream<QueueState> get _queueStateStream =>
      Rxt.Rx.combineLatest2<List<MediaItem>?, MediaItem?, QueueState>(
          AudioService.queueStream,
          AudioService.currentMediaItemStream,
          (queue, mediaItem) => QueueState(queue, mediaItem));
}

/// This task defines logic for playing a list of podcast episodes.
class AudioPlayerTask extends BackgroundAudioTask {
//var xx=  MediaItem.fromJson(raw)

  AudioPlayer _player = new AudioPlayer();
  AudioProcessingState? _skipState;
  Seeker? _seeker;
  late StreamSubscription<PlaybackEvent> _eventSubscription;

  var mediadata = MediaLibrary();

  //List<MediaItem> get queue => mediadata.items;
  int? get index => _player.currentIndex;
  MediaItem? get mediaItem => index == null ? null : mediadata.items[index!];

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    print("start audio");
    // We configure the audio session for speech since we're playing a podcast.
    // You can also put this in your app's initialisation if your app doesn't
    // switch between two types of audio as this example does.
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Broadcast media item changes.
    _player.currentIndexStream.listen((index) {
      print("indexkkkk");
      print(index);
      if (index != null)
        AudioServiceBackground.setMediaItem(mediadata.items[index]);
    });
    // Propagate all events from the audio player to AudioService clients.
    _eventSubscription = _player.playbackEventStream.listen((event) {
      _broadcastState();
    });
    // Special processing for state transitions.
    _player.processingStateStream.listen((state) {
      switch (state) {
        case ProcessingState.completed:
          // In this example, the service stops when reaching the end.
          onStop();
          break;
        case ProcessingState.ready:
          // If we just came from skipping between tracks, clear the skip
          // state now that we're ready to play.
          _skipState = null;
          break;
        default:
          break;
      }
    });

    // // Load and broadcast the queue
    // AudioServiceBackground.setQueue(mediadata.items);
    // try {
    //   await _player.setAudioSource(ConcatenatingAudioSource(
    //     children: mediadata.items
    //         .map((item) => AudioSource.uri(Uri.parse(item.id)))
    //         .toList(),
    //   ));
    //   // In this example, we automatically start playing on start.
    //   onPlay();
    // } catch (e) {
    //   print("Error: $e");
    //   onStop();
    // }
  }

  @override
  Future<void> onUpdateQueue(List<MediaItem> newqueue) async {
    print("func called");
    print(newqueue.length);
    print(mediadata._items.length);
    mediadata.setmideiitem = newqueue;
    print(mediadata._items.length);
    AudioServiceBackground.setQueue(mediadata._items);
    try {
      await _player.setAudioSource(ConcatenatingAudioSource(
        children: mediadata.items
            .map((item) => AudioSource.uri(Uri.parse(item.id)))
            .toList(),
      ));
      // In this example, we automatically start playing on start.
      onPlay();
    } catch (e) {
      print("Error: $e");
      onStop();
    }
  }

  @override
  Future<void> onSkipToQueueItem(String mediaId) async {
    print("skip");
    // Then default implementations of onSkipToNext and onSkipToPrevious will
    // delegate to this method.
    final newIndex = mediadata._items.indexWhere((item) => item.id == mediaId);
    if (newIndex == -1) return;
    // During a skip, the player may enter the buffering state. We could just
    // propagate that state directly to AudioService clients but AudioService
    // has some more specific states we could use for skipping to next and
    // previous. This variable holds the preferred state to send instead of
    // buffering during a skip, and it is cleared as soon as the player exits
    // buffering (see the listener in onStart).
    // _skipState = newIndex > index!
    //     ? AudioProcessingState.skippingToNext
    //     : AudioProcessingState.skippingToPrevious;
    // This jumps to the beginning of the queue item at newIndex.
    _player.seek(Duration.zero, index: newIndex);
    // Demonstrate custom events.
    AudioServiceBackground.sendCustomEvent('skip to $newIndex');
  }

  @override
  Future<void> onPlay() => _player.play();

  @override
  Future<void> onPause() => _player.pause();

  @override
  Future<void> onSeekTo(Duration position) => _player.seek(position);

  @override
  Future<void> onFastForward() => _seekRelative(fastForwardInterval);

  @override
  Future<void> onRewind() => _seekRelative(-rewindInterval);

  @override
  Future<void> onSeekForward(bool begin) async => _seekContinuously(begin, 1);

  @override
  Future<void> onSeekBackward(bool begin) async => _seekContinuously(begin, -1);

  @override
  Future<void> onStop() async {
    await _player.dispose();
    _eventSubscription.cancel();
    // It is important to wait for this state to be broadcast before we shut
    // down the task. If we don't, the background task will be destroyed before
    // the message gets sent to the UI.
    await _broadcastState();
    // Shut down this task
    await super.onStop();
  }

  /// Jumps away from the current position by [offset].
  Future<void> _seekRelative(Duration offset) async {
    var newPosition = _player.position + offset;
    // Make sure we don't jump out of bounds.
    if (newPosition < Duration.zero) newPosition = Duration.zero;
    if (newPosition > mediaItem!.duration!) newPosition = mediaItem!.duration!;
    // Perform the jump via a seek.
    await _player.seek(newPosition);
  }

  /// Begins or stops a continuous seek in [direction]. After it begins it will
  /// continue seeking forward or backward by 10 seconds within the audio, at
  /// intervals of 1 second in app time.
  void _seekContinuously(bool begin, int direction) {
    _seeker?.stop();
    if (begin) {
      _seeker = Seeker(_player, Duration(seconds: 10 * direction),
          Duration(seconds: 1), mediaItem!)
        ..start();
    }
  }

  /// Broadcasts the current state to all clients.
  Future<void> _broadcastState() async {
    await AudioServiceBackground.setState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: [
        // MediaAction.seekTo,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      ],
      androidCompactActions: [0, 1, 3],
      processingState: _getProcessingState(),
      playing: _player.playing,
      position: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
    );
  }

  /// Maps just_audio's processing state into into audio_service's playing
  /// state. If we are in the middle of a skip, we use [_skipState] instead.
  AudioProcessingState _getProcessingState() {
    if (_skipState != null) return _skipState!;
    switch (_player.processingState) {
      case ProcessingState.idle:
        // return AudioProcessingState.stopped;
      case ProcessingState.loading:
        // return AudioProcessingState.connecting;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
      default:
        throw Exception("Invalid state: ${_player.processingState}");
    }
  }
}

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

class MediaLibrary {
  //Default constructor

  var _items = <MediaItem>[
    // MediaItem(
    //   // This can be any unique id, but we use the audio URL for convenience.
    //   id: dataController.podcastList[0].stream,
    //   album: dataController.podcastList[0].author.displayName,
    //   title: dataController.podcastList[0].title,
    //   artist: dataController.podcastList[0].author.displayName,
    //   // duration: Duration(milliseconds: 5739820),
    //   artUri: Uri.parse(
    //     dataController.podcastList[0].thumbnail,
    //   ),
    // ),
    MediaItem(
      id: "https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3",
      album: "Science Friday",
      title: "From Cat Rheology To Operatic Incompetence",
      artist: "Science Friday and WNYC Studios",
      // duration: Duration(milliseconds: 2856950),
      artUri: Uri.parse(
          "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
    ),
    // MediaItem(
    //   id: "https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3",
    //   album: "Science Friday",
    //   title: "From Cat Rheology To Operatic Incompetence",
    //   artist: "Science Friday and WNYC Studios",
    //   // duration: Duration(milliseconds: 2856950),
    //   artUri: Uri.parse(
    //       "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
    // ),
  ];
  set setmideiitem(newque) {
    _items = newque;
  }

  List<MediaItem> get items => _items;
}

class QueueState {
  final List<MediaItem>? queue;
  final MediaItem? mediaItem;

  QueueState(this.queue, this.mediaItem);
}

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  SeekBar({
    required this.duration,
    required this.position,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragValue;
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    final DataController dataController = Get.find();
    final value = min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
        widget.duration.inMilliseconds.toDouble());
    if (_dragValue != null && !_dragging) {
      _dragValue = null;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: Get.width * 0.060),
              child: AutoSizeText(
                RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                        .firstMatch("$_remaining")
                        ?.group(1) ??
                    '$_remaining',
                style: TextStyle(color: Colors.white),
                presetFontSizes: [13, 13],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: Get.width * 0.060),
              child: AutoSizeText(
                RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                        .firstMatch("${widget.duration}")
                        ?.group(1) ??
                    '${widget.duration}',
                style: TextStyle(color: Colors.white),
                presetFontSizes: [13, 13],
              ),
            ),
          ],
        ),
        Slider(
          min: 0.0,
          max: widget.duration.inMilliseconds.toDouble(),
          value: value,
          activeColor: darkTxt,
          inactiveColor: Color(0xffD57D61),
          onChanged: (value) {
            if (!_dragging) {
              _dragging = true;
            }
            setState(() {
              _dragValue = value;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(Duration(milliseconds: value.round()));
            }
          },
          onChangeEnd: (value) {
            if (widget.onChangeEnd != null) {
              widget.onChangeEnd!(Duration(milliseconds: value.round()));
            }
            _dragging = false;
          },
        ),

        // Positioned(
        //   left: Get.height * 0.026,
        //   bottom: Get.height * 0.037,
        //   child: AutoSizeText(
        //     RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
        //             .firstMatch("$_remaining")
        //             ?.group(1) ??
        //         '$_remaining',
        //     style: TextStyle(color: Colors.white),
        //     presetFontSizes: [13, 13],
        //   ),
        // ),
        // Positioned(
        //   right: Get.height * 0.026,
        //   bottom: Get.height * 0.037,
        //   child: AutoSizeText(
        //     RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
        //             .firstMatch("${widget.duration}")
        //             ?.group(1) ??
        //         '${widget.duration}',
        //     style: TextStyle(color: Colors.white),
        //     presetFontSizes: [13, 13],
        //   ),
        // ),
      ],
    );
    // : Column(
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Padding(
    //             padding: EdgeInsets.only(left: Get.width * 0.060),
    //             child: AutoSizeText(
    //               RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
    //                       .firstMatch(
    //                           "${dataController.podcastList[homeController.indexToPlayPod].duration}")
    //                       ?.group(1) ??
    //                   '$_remaining',
    //               style: TextStyle(color: Colors.white),
    //               presetFontSizes: [13, 13],
    //             ),
    //           ),
    //           Padding(
    //             padding: EdgeInsets.only(right: Get.width * 0.060),
    //             child: AutoSizeText(
    //               RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
    //                       .firstMatch(
    //                           "${dataController.podcastList[homeController.indexToPlayPod].duration}")
    //                       ?.group(1) ??
    //                   '$_remaining',
    //               style: TextStyle(color: Colors.white),
    //               presetFontSizes: [13, 13],
    //             ),
    //           ),
    //         ],
    //       ),
    //       Slider(
    //         min: 0.0,
    //         max: widget.duration.inMilliseconds.toDouble(),
    //         value: 0,
    //         activeColor: darkTxt,
    //         inactiveColor: Color(0xffD57D61),
    //         onChanged: (value) {
    //           if (!_dragging) {
    //             _dragging = true;
    //           }
    //           setState(() {
    //             _dragValue = value;
    //           });
    //           if (widget.onChanged != null) {
    //             widget.onChanged!(Duration(milliseconds: value.round()));
    //           }
    //         },
    //         onChangeEnd: (value) {
    //           if (widget.onChangeEnd != null) {
    //             widget.onChangeEnd!(Duration(milliseconds: value.round()));
    //           }
    //           _dragging = false;
    //         },
    //       ),
    //     ],
    //   );
  }

  Duration get _remaining => widget.duration - widget.position;
}

class SeekBar2 extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  SeekBar2({
    required this.duration,
    required this.position,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState2 createState() => _SeekBarState2();
}

class _SeekBarState2 extends State<SeekBar2> {
  double? _dragValue;
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    final DataController dataController = Get.find();
    final value = min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
        widget.duration.inMilliseconds.toDouble());
    if (_dragValue != null && !_dragging) {
      _dragValue = null;
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: Get.width * 0.050),
              child: AutoSizeText(
                RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                        .firstMatch(
                            "${dataController.podcastList[homeController.indexToPlayPod].duration}")
                        ?.group(1) ??
                    '$_remaining',
                style: TextStyle(color: Colors.white),
                presetFontSizes: [13, 13],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: Get.width * 0.060),
              child: AutoSizeText(
                RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                        .firstMatch(
                            "${dataController.podcastList[homeController.indexToPlayPod].duration}")
                        ?.group(1) ??
                    '$_remaining',
                style: TextStyle(color: Colors.white),
                presetFontSizes: [13, 13],
              ),
            ),
          ],
        ),
        Slider(
          min: 0.0,
          max: widget.duration.inMilliseconds.toDouble(),
          value: 0,
          activeColor: darkTxt,
          inactiveColor: Color(0xffD57D61),
          onChanged: (value) {
            if (!_dragging) {
              _dragging = true;
            }
            setState(() {
              _dragValue = value;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(Duration(milliseconds: value.round()));
            }
          },
          onChangeEnd: (value) {
            if (widget.onChangeEnd != null) {
              widget.onChangeEnd!(Duration(milliseconds: value.round()));
            }
            _dragging = false;
          },
        ),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}
