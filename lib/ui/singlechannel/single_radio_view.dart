import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tuneone/Services/remote_services.dart';
import 'package:tuneone/controllers/data_controller.dart';
import 'package:tuneone/controllers/home_controllers.dart';
import 'package:tuneone/controllers/radio_controller.dart';

import 'package:tuneone/ui/shared/styles.dart';
import 'package:tuneone/ui/styled_widgets/cached_network_image.dart';

import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxt;
import '../../common.dart';
import '../../main.dart';

class SingleRadioView extends StatelessWidget {
  final DataController dataController = Get.find();
  final RadioController radioController = Get.find();
  final HomeController homeController = Get.find();

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
                                    onPressed: () async {
                                      // if (ThemeProvider.themeOf(context)
                                      //         .id ==
                                      //     "light")
                                      //   ThemeProvider.controllerOf(context)
                                      //       .setTheme("dark");
                                      // else
                                      //   ThemeProvider.controllerOf(context)
                                      //       .setTheme("light");

                                      // final player = AudioPlayer();
                                      // var dur = await player.setUrl(
                                      //     "https://tunonestorage.nyc3.digitaloceanspaces.com/wp-content/uploads/2021/09/24202445/PAROLE-AUX-PREDICATEUR-PAST-GERMAIN.mp3");
                                      // print(dur);

                                      Get.back();
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: Get.height * 0.02,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      child: Icon(
                                        LineIcons.stepBackward,
                                        color: Colors.white,
                                      ),
                                      onTap: () async {
                                        if (homeController.indexToPlayRadio ==
                                            0) {
                                          homeController.indexToPlayRadio =
                                              dataController.radioList.length -
                                                  1;
                                          await audioHandler.skipToQueueItem(
                                              homeController.indexToPlayRadio);
                                        } else {
                                          homeController.indexToPlayRadio -= 1;
                                          await audioHandler.skipToQueueItem(
                                              homeController.indexToPlayRadio);
                                        }
                                      },
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
                                                    .radioList[homeController
                                                        .indexToPlayRadio]
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
                                    GestureDetector(
                                      child: Icon(
                                        LineIcons.stepForward,
                                        color: Colors.white,
                                      ),
                                      onTap: () async {
                                        if (homeController.indexToPlayRadio ==
                                            dataController.radioList.length -
                                                1) {
                                          homeController.indexToPlayRadio =
                                              homeController.indexToPlayRadio =
                                                  0;
                                          await audioHandler.skipToQueueItem(
                                              homeController.indexToPlayRadio);
                                        } else {
                                          homeController.indexToPlayRadio += 1;
                                          await audioHandler.skipToQueueItem(
                                              homeController.indexToPlayRadio);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Obx(
                                    () => Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: AspectRatio(
                                              aspectRatio: 1 / 1,
                                              child: StyledCachedNetworkImage2(
                                                url: dataController
                                                    .radioList[homeController
                                                        .indexToPlayRadio]
                                                    .thumbnail,
                                              ),
                                            ),
                                          ),
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
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        AutoSizeText(
                                          dataController
                                              .radioList[homeController
                                                  .indexToPlayRadio]
                                              .author
                                              .displayName,
                                          style: TextStyle(color: Colors.white),
                                          presetFontSizes: [18, 16],
                                        )
                                      ],
                                    ),
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
                                        AudioPlayer _player = new AudioPlayer();

                                        // if (running) {
                                        //   AudioService.seekTo(Duration());
                                        //   await _player.seek(Duration(
                                        //       seconds: _player.position
                                        //               .inMinutes +
                                        //           0));
                                        // }
                                      },
                                    ),
                                    StreamBuilder<Object>(
                                        stream: audioHandler.queueState,
                                        builder: (context, snapshot) {
                                          var queueState =
                                              snapshot.data ?? QueueState.empty;
                                          return GestureDetector(
                                            onTap: () async {
                                              if (homeController
                                                      .indexToPlayRadio ==
                                                  0) {
                                                homeController
                                                        .indexToPlayRadio =
                                                    dataController
                                                            .radioList.length -
                                                        1;
                                                await audioHandler
                                                    .skipToQueueItem(
                                                        homeController
                                                            .indexToPlayRadio);
                                              } else {
                                                homeController
                                                    .indexToPlayRadio -= 1;
                                                await audioHandler
                                                    .skipToQueueItem(
                                                        homeController
                                                            .indexToPlayRadio);
                                              }
                                            },
                                            child: Icon(
                                                Icons.skip_previous_outlined,
                                                color: Colors.white,
                                                size: 40),
                                          );
                                        }),
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
                                                    .radioList[homeController
                                                        .indexToPlayRadio]
                                                    .stream) {
                                              print("matched");
                                              return Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                ),
                                                child: IconButton(
                                                    icon:
                                                        const Icon(Icons.pause),
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
                                                  icon: const Icon(
                                                      Icons.play_arrow),
                                                  onPressed: () async {
                                                    radioController.indexX =
                                                        homeController
                                                            .indexToPlayRadio;

                                                    if (homeController.whoAccess
                                                                .value ==
                                                            "pod" ||
                                                        homeController.whoAccess
                                                                .value ==
                                                            "none") {
                                                      await audioHandler
                                                          .updateQueue(
                                                              dataController
                                                                  .mediaListRadio);
                                                      await audioHandler
                                                          .skipToQueueItem(
                                                              homeController
                                                                  .indexToPlayRadio);
                                                      audioHandler.play();
                                                      homeController.whoAccess
                                                          .value = "radio";
                                                    } else {
                                                      await audioHandler
                                                          .skipToQueueItem(
                                                              homeController
                                                                  .indexToPlayRadio);
                                                      audioHandler.play();
                                                      homeController.whoAccess
                                                          .value = "radio";
                                                    }
                                                    dataController.addRecently(
                                                        dataController
                                                                .radioList[
                                                            homeController
                                                                .indexToPlayRadio],
                                                        false);
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
                                                icon: const Icon(
                                                    Icons.play_arrow),
                                                onPressed: () async {
                                                  radioController.indexX =
                                                      homeController
                                                          .indexToPlayRadio;

                                                  if (homeController.whoAccess
                                                              .value ==
                                                          "pod" ||
                                                      homeController.whoAccess
                                                              .value ==
                                                          "none") {
                                                    await audioHandler
                                                        .updateQueue(
                                                            dataController
                                                                .mediaListRadio);
                                                    await audioHandler
                                                        .skipToQueueItem(
                                                            homeController
                                                                .indexToPlayRadio);
                                                    audioHandler.play();
                                                    homeController.whoAccess
                                                        .value = "radio";
                                                  } else {
                                                    await audioHandler
                                                        .skipToQueueItem(
                                                            homeController
                                                                .indexToPlayRadio);
                                                    audioHandler.play();
                                                    homeController.whoAccess
                                                        .value = "radio";
                                                  }
                                                  dataController.addRecently(
                                                      dataController.radioList[
                                                          homeController
                                                              .indexToPlayRadio],
                                                      false);
                                                },
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (homeController.indexToPlayRadio ==
                                            dataController.radioList.length -
                                                1) {
                                          homeController.indexToPlayRadio =
                                              homeController.indexToPlayRadio =
                                                  0;
                                          await audioHandler.skipToQueueItem(
                                              homeController.indexToPlayRadio);
                                        } else {
                                          homeController.indexToPlayRadio += 1;
                                          await audioHandler.skipToQueueItem(
                                              homeController.indexToPlayRadio);
                                        }
                                      },
                                      child: Icon(Icons.skip_next_outlined,
                                          color: Colors.white, size: 40),
                                    ),
                                    dataController.islogin.isFalse
                                        ? GestureDetector(
                                            onTap: () {
                                              Get.toNamed("/authoption");
                                            },
                                            child: Icon(
                                              Icons.favorite_outline_sharp,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          )
                                        : Obx(
                                            () => !dataController.likeList
                                                    .contains(dataController
                                                        .radioList[homeController
                                                            .indexToPlayRadio]
                                                        .id)
                                                ? GestureDetector(
                                                    onTap: () async {
                                                      var response = await RemoteServices
                                                          .likeDislike(
                                                              like: true,
                                                              postId: dataController
                                                                  .radioList[
                                                                      homeController
                                                                          .indexToPlayRadio]
                                                                  .id);
                                                    },
                                                    child: Icon(
                                                      Icons
                                                          .favorite_outline_sharp,
                                                      color: Colors.white,
                                                      size: 30,
                                                    ),
                                                  )
                                                : GestureDetector(
                                                    onTap: () async {
                                                      var response = await RemoteServices
                                                          .likeDislike(
                                                              like: false,
                                                              postId: dataController
                                                                  .radioList[
                                                                      homeController
                                                                          .indexToPlayRadio]
                                                                  .id);
                                                    },
                                                    child: Icon(
                                                      Icons.favorite_outlined,
                                                      color: Colors.white,
                                                      size: 30,
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
