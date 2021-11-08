import 'dart:async';
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
import 'package:tuneone/ui/shared/styles.dart';
import 'package:rxdart/rxdart.dart' as rxt;
import 'package:tuneone/ui/styled_widgets/cached_network_image.dart';

import '../../common.dart';
import '../../main.dart';

class SinglePodcastView extends StatelessWidget {
  final DataController dataController = Get.find();
  final RadioController radioController = Get.find();
  final HomeController homeController = Get.find();
  final PodcastController podcastController = Get.find();

  Stream<Duration> get _bufferedPositionStream => audioHandler.playbackState
      .map((state) => state.bufferedPosition)
      .distinct();

  Stream<Duration?> get _durationStream =>
      audioHandler.mediaItem.map((item) => item?.duration).distinct();

  Stream<PositionData> get _positionDataStream =>
      rxt.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          AudioService.position,
          _bufferedPositionStream,
          _durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

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
                child: StreamBuilder<MediaItem?>(
                    stream: audioHandler.mediaItem,
                    builder: (context, snapshot) {
                      final running = snapshot.data ?? false;
                      //  audioHandler.updateQueue(dataController.mediaListRadio);
                      // final mediaItem = snapshot.data;
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      child: Icon(
                                        LineIcons.stepBackward,
                                        color: Colors.white,
                                      ),
                                      onTap: () async {
                                        if (homeController.indexToPlayPod ==
                                            0) {
                                          homeController.indexToPlayPod =
                                              dataController
                                                      .podcastList.length -
                                                  1;
                                          await audioHandler.skipToQueueItem(
                                              homeController.indexToPlayPod);
                                        } else {
                                          homeController.indexToPlayPod -= 1;
                                          await audioHandler.skipToQueueItem(
                                              homeController.indexToPlayPod);
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
                                                    .podcastList[homeController
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
                                        if (homeController.indexToPlayPod ==
                                            dataController.podcastList.length -
                                                1) {
                                          homeController.indexToPlayPod =
                                              homeController.indexToPlayPod = 0;
                                          await audioHandler.skipToQueueItem(
                                              homeController.indexToPlayPod);
                                        } else {
                                          homeController.indexToPlayPod += 1;
                                          await audioHandler.skipToQueueItem(
                                              homeController.indexToPlayPod);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: Get.height * 0.12,
                                ),
                                Obx(
                                  () => Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: Border.all(
                                            width: 2,
                                            color:
                                                ThemeProvider.themeOf(context)
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
                                            child: StyledCachedNetworkImage2(
                                              url: dataController
                                                  .podcastList[homeController
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
                                            .podcastList[
                                                homeController.indexToPlayPod]
                                            .author
                                            .displayName,
                                        style: TextStyle(color: Colors.white),
                                        presetFontSizes: [18, 16],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: Get.height * 0.05,
                                ),
                                StreamBuilder<PositionData>(
                                  stream: _positionDataStream,
                                  builder: (context, snapshot) {
                                    final positionData = snapshot.data ??
                                        PositionData(Duration.zero,
                                            Duration.zero, Duration.zero);
                                    return SeekBar(
                                      duration: positionData.duration,
                                      position: positionData.position,
                                      onChangeEnd: (newPosition) {
                                        audioHandler.seek(newPosition);
                                      },
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: Get.height * 0.04,
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
                                        // AudioPlayer _player =
                                        // new AudioPlayer();
                                        //
                                        // if (running) {
                                        //   AudioService.seekTo(Duration());
                                        //   await _player.seek(Duration(
                                        //       seconds: _player.position
                                        //           .inMinutes +
                                        //           0));
                                        // }
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (homeController.indexToPlayPod ==
                                            0) {
                                          homeController.indexToPlayPod =
                                              dataController
                                                      .podcastList.length -
                                                  1;
                                          await audioHandler.skipToQueueItem(
                                              homeController.indexToPlayPod);
                                        } else {
                                          homeController.indexToPlayPod -= 1;
                                          await audioHandler.skipToQueueItem(
                                              homeController.indexToPlayPod);
                                        }
                                      },
                                      child: Icon(Icons.skip_previous_outlined,
                                          color: Colors.white, size: 40),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: (ThemeProvider.themeOf(context)
                                                    .id ==
                                                "light")
                                            ? Colors.grey[400]
                                            : Theme.of(context).primaryColor,
                                      ),
                                      child: StreamBuilder<PlaybackState>(
                                        stream: audioHandler.playbackState,
                                        builder: (context, snapshot) {
                                          final playbackState = snapshot.data;
                                          final processingState =
                                              playbackState?.processingState;
                                          final playing =
                                              playbackState?.playing;
                                          if (processingState ==
                                                  AudioProcessingState
                                                      .loading ||
                                              processingState ==
                                                  AudioProcessingState
                                                      .buffering) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              width: 40.0,
                                              height: 40.0,
                                              child:
                                                  const CupertinoActivityIndicator(),
                                            );
                                          } else if (playing == true) {
                                            if (audioHandler
                                                    .mediaItem.value!.id ==
                                                dataController
                                                    .podcastList[homeController
                                                        .indexToPlayPod]
                                                    .stream) {
                                              return Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                ),
                                                child: IconButton(
                                                    icon: const Icon(
                                                      Icons.pause,
                                                    ),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    onPressed: () {
                                                      audioHandler.pause();
                                                    }),
                                              );
                                            } else {
                                              return Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                ),
                                                child: IconButton(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  icon: const Icon(
                                                      Icons.play_arrow),
                                                  onPressed: () async {
                                                    podcastController.indexX =
                                                        homeController
                                                            .indexToPlayPod;

                                                    if (homeController.whoAccess
                                                                .value ==
                                                            "radio" ||
                                                        homeController.whoAccess
                                                                .value ==
                                                            "none") {
                                                      await audioHandler
                                                          .updateQueue(
                                                              dataController
                                                                  .mediaListPodcast);
                                                      await audioHandler
                                                          .skipToQueueItem(
                                                              homeController
                                                                  .indexToPlayPod);
                                                      audioHandler.play();
                                                      homeController.whoAccess
                                                          .value = "pod";
                                                    } else {
                                                      print("pod access");
                                                      if (audioHandler.mediaItem
                                                              .value!.id !=
                                                          dataController
                                                              .mediaListPodcast[
                                                                  homeController
                                                                      .indexToPlayPod]
                                                              .id) {
                                                        await audioHandler
                                                            .skipToQueueItem(
                                                                homeController
                                                                    .indexToPlayPod);
                                                      }

                                                      audioHandler.play();

                                                      homeController.whoAccess
                                                          .value = "pod";
                                                    }
                                                    dataController.addRecently(
                                                        dataController
                                                                .podcastList[
                                                            homeController
                                                                .indexToPlayPod],
                                                        true);
                                                  },
                                                ),
                                              );
                                            }
                                          } else {
                                            return Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child: IconButton(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                icon: const Icon(
                                                    Icons.play_arrow),
                                                onPressed: () async {
                                                  podcastController.indexX =
                                                      homeController
                                                          .indexToPlayPod;

                                                  if (homeController.whoAccess
                                                              .value ==
                                                          "radio" ||
                                                      homeController.whoAccess
                                                              .value ==
                                                          "none") {
                                                    await audioHandler.updateQueue(
                                                        dataController
                                                            .mediaListPodcast);
                                                    await audioHandler
                                                        .skipToQueueItem(
                                                            homeController
                                                                .indexToPlayPod);
                                                    audioHandler.play();
                                                    homeController.whoAccess
                                                        .value = "pod";
                                                  } else {
                                                    if (audioHandler.mediaItem
                                                            .value!.id !=
                                                        dataController
                                                            .mediaListPodcast[
                                                                homeController
                                                                    .indexToPlayPod]
                                                            .id) {
                                                      print(
                                                          "pod access 2 + same");
                                                      await audioHandler
                                                          .skipToQueueItem(
                                                              homeController
                                                                  .indexToPlayPod);
                                                    }

                                                    audioHandler.play();

                                                    homeController.whoAccess
                                                        .value = "pod";
                                                  }
                                                  dataController.addRecently(
                                                      dataController
                                                              .podcastList[
                                                          homeController
                                                              .indexToPlayPod],
                                                      true);
                                                },
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (homeController.indexToPlayPod ==
                                            dataController.podcastList.length -
                                                1) {
                                          homeController.indexToPlayPod =
                                              homeController.indexToPlayPod = 0;
                                          await audioHandler.skipToQueueItem(
                                              homeController.indexToPlayPod);
                                        } else {
                                          homeController.indexToPlayPod += 1;
                                          await audioHandler.skipToQueueItem(
                                              homeController.indexToPlayPod);
                                        }
                                      },
                                      child: Icon(Icons.skip_next_outlined,
                                          color: Colors.white, size: 40),
                                    ),
                                    dataController.islogin.isFalse
                                        ? GestureDetector(
                                            onTap: () {
                                              homeController.showAlertDialog(
                                                  context: context,
                                                  title: "ATTENTION!",
                                                  content:
                                                      "Please Sign In To Continue This Action",
                                                  cancelActionText: "CANCEL",
                                                  defaultActionText: "LOG IN");
                                            },
                                            child: Icon(
                                              Icons.favorite_outline_sharp,
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
                                                      var response = await RemoteServices
                                                          .likeDislike(
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
                                                      var response = await RemoteServices
                                                          .likeDislike(
                                                              like: false,
                                                              postId: dataController
                                                                  .podcastList[
                                                                      homeController
                                                                          .indexToPlayPod]
                                                                  .id);
                                                    },
                                                    child: Icon(
                                                      Icons.favorite_outlined,
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
                    }),
              ),
            ],
          );
        }),
      ),
    );
  }
}
