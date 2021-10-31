import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tuneone/Services/remote_services.dart';
import 'package:tuneone/controllers/data_controller.dart';
import 'package:tuneone/controllers/home_controllers.dart';
import 'package:tuneone/controllers/podcast_controller.dart';
import 'package:tuneone/models/podcast_model.dart';
import 'package:tuneone/ui/medialist/medialist_viewmodel.dart';
import 'package:audio_service/audio_service.dart';

import 'package:tuneone/ui/shared/styles.dart';
import 'package:tuneone/ui/styled_widgets/cached_network_image.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as Rxt;
import 'package:audio_session/audio_session.dart';
import 'package:tuneone/ui/styled_widgets/mini_player.dart';

// NOTE: Your entrypoint MUST be a top-level function.
void _audioPlayerTaskEntrypoint() async {
  print("test");
  AudioServiceBackground.run(() => AudioPlayerTask());
}

List<MediaItem> dataitems = [];

class MediaListView extends StatelessWidget {
  final DataController dataController = Get.find();
  final PodcastController podcastController = Get.put(PodcastController());
  final HomeController homeController = Get.find();
  final String? title;
  final bool fromLibrary;
  MediaListView({this.title, required this.fromLibrary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetX<PodcastController>(builder: (pod) {
      return Stack(
        children: [
          Container(
            color: (ThemeProvider.themeOf(context).id == "light")
                ? Colors.white
                : Theme.of(context).primaryColor.withOpacity(0.8),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: ThemeProvider.themeOf(context).id == "light"
                        ? DecorationImage(
                            image: AssetImage("assets/appbarBgLight.png"),
                            fit: BoxFit.cover)
                        : DecorationImage(
                            image: AssetImage("assets/appbarBgdark.png"),
                            fit: BoxFit.cover),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                    child: Column(
                      children: [
                        SizedBox(
                          height: Get.height * 0.07,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: AutoSizeText(
                                  pod.appBar.value,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Get.height * 0.03,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<bool>(
                      stream: AudioService.runningStream,
                      builder: (context, snapshot) {
                        if (false) {
                          // Don't show anything until we've ascertained whether or not the
                          // service is running, since we want to show a different UI in
                          // each case.
                          print("object");
                          dataitems = dataController.mediaListPodcast;
                          print(dataitems.length);
                          // MediaLibrary(dataController.medoaList);

                          // AudioService.start(
                          //   backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
                          //
                          //   androidNotificationChannelName: 'Audio Service Demo',
                          //   // Enable this if you want the Android service to exit the foreground state on pause.
                          //   //androidStopForegroundOnPause: true,
                          //   androidNotificationColor: 0xFF2196f3,
                          //   androidNotificationIcon: 'mipmap/ic_launcher',
                          //   androidEnableQueue: true,
                          // ).then((value) {
                          //   AudioService.updateQueue(dataController.medoaList);
                          //   // AudioService.pause();
                          // });

                          return SizedBox();
                        }
                        final running = snapshot.data ?? false;
                        return StreamBuilder<QueueState>(
                            stream: _queueStateStream,
                            builder: (context, snapshot) {
                              final queueState = snapshot.data;
                              final queue = queueState?.queue ?? [];
                              final mediaItem = queueState?.mediaItem;

                              return Column(children: [
                                Expanded(
                                    child: dataController.islogin.isTrue
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                              bottom: running
                                                  ? Get.height * 0.080
                                                  : 1,
                                            ),
                                            child: ListView.builder(
                                                itemCount: dataController
                                                    .podcastListMasterCopy
                                                    .length,
                                                itemBuilder: (_, index) {
                                                  if (dataController.userList
                                                          .userMeta.likes
                                                          .contains(dataController
                                                              .podcastListMasterCopy[
                                                                  index]
                                                              .id) ||
                                                      !fromLibrary) {
                                                    return Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 3),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          border: Border.all(
                                                            color: ThemeProvider.themeOf(
                                                                            context)
                                                                        .id ==
                                                                    "light"
                                                                ? Color(
                                                                    0xffF2F2F2)
                                                                : darkTxt
                                                                    .withOpacity(
                                                                        0.2),
                                                          ),
                                                        ),
                                                        child: ListTile(
                                                          onTap: () {},
                                                          dense: true,
                                                          leading: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                              child:
                                                                  StyledCachedNetworkImage(
                                                                url: dataController
                                                                    .podcastList[
                                                                        index]
                                                                    .thumbnail,
                                                                height:
                                                                    Get.height *
                                                                        0.10,
                                                                width:
                                                                    Get.width *
                                                                        0.12,
                                                              ),
                                                            ),
                                                          ),
                                                          trailing: Container(
                                                              height: 40,
                                                              width: 40,
                                                              // padding: EdgeInsets.all(5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: (ThemeProvider.themeOf(context)
                                                                            .id ==
                                                                        "light")
                                                                    ? Colors.grey[
                                                                        400]
                                                                    : Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                              ),
                                                              child: StreamBuilder<
                                                                      bool>(
                                                                  stream: AudioService
                                                                      .playbackStateStream
                                                                      .map((state) =>
                                                                          state
                                                                              .playing)
                                                                      .distinct(),
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    final playing =
                                                                        snapshot.data ??
                                                                            false;

                                                                    return IconButton(
                                                                        onPressed:
                                                                            () async {
                                                                          dataController.addRecently(
                                                                              dataController.podcastListMasterCopy[index],
                                                                              true);
                                                                          pod.indexX =
                                                                              index;
                                                                          // if (running) {
                                                                          //   AudioService.start(
                                                                          //     backgroundTaskEntrypoint:
                                                                          //         _audioPlayerTaskEntrypoint,
                                                                          //
                                                                          //     androidNotificationChannelName:
                                                                          //         'Audio Service Demo',
                                                                          //     // Enable this if you want the Android service to exit the foreground state on pause.
                                                                          //     //androidStopForegroundOnPause: true,
                                                                          //     androidNotificationColor:
                                                                          //         0xFF2196f3,
                                                                          //     androidNotificationIcon:
                                                                          //         'mipmap/ic_launcher',
                                                                          //     androidEnableQueue:
                                                                          //         true,
                                                                          //   ).then((value) {
                                                                          //     AudioService
                                                                          //         .updateQueue(
                                                                          //             dataController
                                                                          //                 .medoaList);
                                                                          //     // AudioService.pause();
                                                                          //   });
                                                                          // }

                                                                          if (homeController.whoAccess.value ==
                                                                              "radio") {
                                                                            print("radio playing");
                                                                            await AudioService.updateQueue(dataController.mediaListPodcast);
                                                                            await AudioService.skipToQueueItem(dataController.mediaListPodcast[index].id);
                                                                            AudioService.play();
                                                                            homeController.whoAccess.value =
                                                                                "pod";
                                                                          } else {
                                                                            if (playing) {
                                                                              pod.indexX = -1;
                                                                              if (AudioService.currentMediaItem!.id == dataController.mediaListPodcast[index].id) {
                                                                                AudioService.pause();
                                                                              } else {
                                                                                if (AudioService.currentMediaItem!.id != dataController.mediaListPodcast[index].id) {
                                                                                  await AudioService.skipToQueueItem(dataController.mediaListPodcast[index].id);
                                                                                }
                                                                                AudioService.play();
                                                                              }
                                                                            } else {
                                                                              print("not active");
                                                                              if (!running) {
                                                                                AudioService.start(
                                                                                  backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,

                                                                                  androidNotificationChannelName: 'Audio Service Demo',
                                                                                  // Enable this if you want the Android service to exit the foreground state on pause.
                                                                                  //androidStopForegroundOnPause: true,
                                                                                  androidNotificationColor: 0xFF2196f3,
                                                                                  androidNotificationIcon: 'mipmap/ic_launcher',
                                                                                  androidEnableQueue: true,
                                                                                ).then((value) async {
                                                                                  await AudioService.updateQueue(dataController.mediaListPodcast);
                                                                                  AudioService.skipToQueueItem(dataController.mediaListPodcast[index].id);
                                                                                  print("start call");
                                                                                  homeController.whoAccess.value = "pod";
                                                                                  //  AudioService.pause();
                                                                                });
                                                                              } else {
                                                                                if (AudioService.currentMediaItem!.id != dataController.mediaListPodcast[index].id) await AudioService.skipToQueueItem(dataController.mediaListPodcast[index].id);
                                                                                AudioService.play();
                                                                              }
                                                                            }
                                                                          }
                                                                        },
                                                                        icon: (pod.indexX == index &&
                                                                                !playing)
                                                                            ? CupertinoActivityIndicator()
                                                                            : playing
                                                                                ? AudioService.currentMediaItem!.id != dataController.mediaListPodcast[index].id
                                                                                    ? Icon(
                                                                                        Icons.play_arrow,
                                                                                        color: Colors.white,
                                                                                      )
                                                                                    : Icon(
                                                                                        Icons.pause,
                                                                                        color: Colors.white,
                                                                                      )
                                                                                : Icon(
                                                                                    Icons.play_arrow,
                                                                                    color: Colors.white,
                                                                                  ));
                                                                  })),
                                                          title: AutoSizeText(
                                                            dataController
                                                                .podcastList[
                                                                    index]
                                                                .title,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  "Aeonik-medium",
                                                              color: ThemeProvider.themeOf(
                                                                              context)
                                                                          .id ==
                                                                      "light"
                                                                  ? Colors.white
                                                                  : darkTxt,
                                                            ),
                                                          ),
                                                          subtitle:
                                                              AutoSizeText(
                                                            dataController
                                                                .podcastList[
                                                                    index]
                                                                .author
                                                                .displayName,
                                                            style: TextStyle(
                                                              fontSize: 5,
                                                              color: ThemeProvider.themeOf(
                                                                              context)
                                                                          .id ==
                                                                      "light"
                                                                  ? Color(
                                                                      0xffA4A4A4)
                                                                  : darkTxt
                                                                      .withOpacity(
                                                                          0.5),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return SizedBox();
                                                  }
                                                }),
                                          )
                                        : ListView.builder(
                                            itemCount: dataController
                                                .podcastListMasterCopy.length,
                                            itemBuilder: (_, index) {
                                              return ListTile(
                                                onTap: () {},
                                                dense: true,
                                                leading: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child:
                                                        StyledCachedNetworkImage(
                                                      url: dataController
                                                          .podcastList[index]
                                                          .thumbnail,
                                                      height: Get.height * 0.10,
                                                      width: Get.width * 0.12,
                                                    ),
                                                  ),
                                                ),
                                                trailing: Container(
                                                    height: 40,
                                                    width: 40,
                                                    // padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: (ThemeProvider
                                                                      .themeOf(
                                                                          context)
                                                                  .id ==
                                                              "light")
                                                          ? Colors.grey[400]
                                                          : Theme.of(context)
                                                              .primaryColor,
                                                    ),
                                                    child: StreamBuilder<bool>(
                                                        stream: AudioService
                                                            .playbackStateStream
                                                            .map((state) =>
                                                                state.playing)
                                                            .distinct(),
                                                        builder: (context,
                                                            snapshot) {
                                                          final playing =
                                                              snapshot.data ??
                                                                  false;

                                                          return IconButton(
                                                              onPressed:
                                                                  () async {
                                                                pod.indexX =
                                                                    index;
                                                                // if (running) {
                                                                //   AudioService.start(
                                                                //     backgroundTaskEntrypoint:
                                                                //         _audioPlayerTaskEntrypoint,
                                                                //
                                                                //     androidNotificationChannelName:
                                                                //         'Audio Service Demo',
                                                                //     // Enable this if you want the Android service to exit the foreground state on pause.
                                                                //     //androidStopForegroundOnPause: true,
                                                                //     androidNotificationColor:
                                                                //         0xFF2196f3,
                                                                //     androidNotificationIcon:
                                                                //         'mipmap/ic_launcher',
                                                                //     androidEnableQueue:
                                                                //         true,
                                                                //   ).then((value) {
                                                                //     AudioService
                                                                //         .updateQueue(
                                                                //             dataController
                                                                //                 .medoaList);
                                                                //     // AudioService.pause();
                                                                //   });
                                                                // }

                                                                if (homeController
                                                                        .whoAccess
                                                                        .value ==
                                                                    "radio") {
                                                                  print(
                                                                      "radio playing");
                                                                  await AudioService
                                                                      .updateQueue(
                                                                          dataController
                                                                              .mediaListPodcast);
                                                                  await AudioService.skipToQueueItem(
                                                                      dataController
                                                                          .mediaListPodcast[
                                                                              index]
                                                                          .id);
                                                                  AudioService
                                                                      .play();
                                                                  homeController
                                                                      .whoAccess
                                                                      .value = "pod";
                                                                } else {
                                                                  if (playing) {
                                                                    pod.indexX =
                                                                        -1;
                                                                    if (AudioService
                                                                            .currentMediaItem!
                                                                            .id ==
                                                                        dataController
                                                                            .mediaListPodcast[index]
                                                                            .id) {
                                                                      AudioService
                                                                          .pause();
                                                                    } else {
                                                                      await AudioService.skipToQueueItem(dataController
                                                                          .mediaListPodcast[
                                                                              index]
                                                                          .id);
                                                                      AudioService
                                                                          .play();
                                                                    }
                                                                  } else {
                                                                    print(
                                                                        "not active");
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
                                                                        await AudioService.updateQueue(
                                                                            dataController.mediaListPodcast);
                                                                        AudioService.skipToQueueItem(dataController
                                                                            .mediaListPodcast[index]
                                                                            .id);
                                                                        print(
                                                                            "start call");
                                                                        homeController
                                                                            .whoAccess
                                                                            .value = "pod";
                                                                        //  AudioService.pause();
                                                                      });
                                                                    } else {
                                                                      await AudioService.skipToQueueItem(dataController
                                                                          .mediaListPodcast[
                                                                              index]
                                                                          .id);
                                                                      AudioService
                                                                          .play();
                                                                    }
                                                                  }
                                                                }
                                                              },
                                                              icon: (pod.indexX ==
                                                                          index &&
                                                                      !playing)
                                                                  ? CupertinoActivityIndicator()
                                                                  : playing
                                                                      ? AudioService.currentMediaItem!.id !=
                                                                              dataController.mediaListPodcast[index].id
                                                                          ? Icon(
                                                                              Icons.play_arrow,
                                                                              color: Colors.white,
                                                                            )
                                                                          : Icon(
                                                                              Icons.pause,
                                                                              color: Colors.white,
                                                                            )
                                                                      : Icon(
                                                                          Icons
                                                                              .play_arrow,
                                                                          color:
                                                                              Colors.white,
                                                                        ));
                                                        })),
                                                title: AutoSizeText(
                                                  dataController
                                                      .podcastList[index].title,
                                                  presetFontSizes: [14, 12],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w100,
                                                    fontFamily: "Aeonik-medium",
                                                    color:
                                                        ThemeProvider.themeOf(
                                                                        context)
                                                                    .id ==
                                                                "light"
                                                            ? darkBg
                                                            : Colors.white,
                                                  ),
                                                ),
                                                subtitle: AutoSizeText(
                                                  dataController
                                                      .podcastList[index]
                                                      .author
                                                      .displayName,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w100,
                                                    fontFamily: "Aeonik-medium",
                                                    color:
                                                        ThemeProvider.themeOf(
                                                                        context)
                                                                    .id ==
                                                                "light"
                                                            ? Color(0xffA4A4A4)
                                                            : darkTxt
                                                                .withOpacity(
                                                                    0.5),
                                                  ),
                                                ),
                                              );
                                            }))
                              ]);
                            });
                      }),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: MiniPlayer(),
          ),
        ],
      );
    }));
  }

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

/// Provides access to a library of media items. In your app, this could come
/// from a database or web service.
///
// List<MediaItem> get items => _items;

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

class QueueState {
  final List<MediaItem>? queue;
  final MediaItem? mediaItem;

  QueueState(this.queue, this.mediaItem);
}
