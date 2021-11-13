import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:line_icons/line_icons.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:share/share.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tuneone/Services/remote_services.dart';
import 'package:tuneone/controllers/data_controller.dart';
import 'package:tuneone/controllers/home_controllers.dart';
import 'package:tuneone/controllers/podcast_controller.dart';
import 'package:tuneone/controllers/radio_controller.dart';
import 'package:tuneone/ui/authar_page/author_pod.dart';
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
              SizedBox(height: podcastController.height.value),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                    onPressed: () async {
                      Get.back();
                    },
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.03),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Icon(
                        LineIcons.stepBackward,
                        color: Colors.white,
                      ),
                      onTap: () async {
                        if (homeController.indexToPlayPod.value == 0) {
                          homeController.indexToPlayPod.value =
                              dataController.podcastList.length - 1;
                          await audioHandler.skipToQueueItem(
                              homeController.indexToPlayPod.value);
                        } else {
                          homeController.indexToPlayPod -= 1;
                          await audioHandler.skipToQueueItem(
                              homeController.indexToPlayPod.value);
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
                                        homeController.indexToPlayPod.value]
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
                        if (homeController.indexToPlayPod.value ==
                            dataController.podcastList.length - 1) {
                          homeController.indexToPlayPod =
                              homeController.indexToPlayPod = RxInt(0);
                          await audioHandler.skipToQueueItem(
                              homeController.indexToPlayPod.value);
                        } else {
                          homeController.indexToPlayPod += 1;
                          await audioHandler.skipToQueueItem(
                              homeController.indexToPlayPod.value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<MediaItem?>(
                    stream: audioHandler.mediaItem,
                    builder: (context, snapshot) {
                      // final running = snapshot.data ?? false;
                      return Container(
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Get.width * 0.05),
                              child: SingleChildScrollView(
                                child: Column(children: [
                                  SizedBox(
                                    height: kToolbarHeight,
                                  ),

                                  Obx(
                                    () => Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: Get.height * 0.40,
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
                                                        .indexToPlayPod.value]
                                                    .thumbnail,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            homeController.prepareAuthorList(
                                                authorId: dataController
                                                    .podcastList[homeController
                                                        .indexToPlayPod.value]
                                                    .author
                                                    .authorId);
                                            Get.to(AuthorPodcast(
                                              currentIndex: homeController
                                                  .indexToPlayPod.value,
                                            ));
                                          },
                                          child: AutoSizeText(
                                            dataController
                                                .podcastList[homeController
                                                    .indexToPlayPod.value]
                                                .author
                                                .displayName,
                                            style:
                                                TextStyle(color: Colors.white),
                                            presetFontSizes: [18, 16],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.02,
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
                                          Icons.ios_share,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                        onTap: () async {
                                          Share.share(dataController
                                              .podcastList[homeController
                                                  .indexToPlayPod.value]
                                              .link);
                                        },
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          if (homeController
                                                  .indexToPlayPod.value ==
                                              0) {
                                            homeController.indexToPlayPod
                                                .value = dataController
                                                    .podcastList.length -
                                                1;
                                            await audioHandler.skipToQueueItem(
                                                homeController
                                                    .indexToPlayPod.value);
                                          } else {
                                            homeController.indexToPlayPod -= 1;
                                            await audioHandler.skipToQueueItem(
                                                homeController
                                                    .indexToPlayPod.value);
                                          }
                                        },
                                        child: Icon(
                                            Icons.skip_previous_outlined,
                                            color: Colors.white,
                                            size: 40),
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
                                                      .podcastList[
                                                          homeController
                                                              .indexToPlayPod
                                                              .value]
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
                                                              .indexToPlayPod
                                                              .value;

                                                      if (homeController
                                                                  .whoAccess
                                                                  .value ==
                                                              "radio" ||
                                                          homeController
                                                                  .whoAccess
                                                                  .value ==
                                                              "none") {
                                                        await audioHandler
                                                            .updateQueue(
                                                                dataController
                                                                    .mediaListPodcast);
                                                        await audioHandler
                                                            .skipToQueueItem(
                                                                homeController
                                                                    .indexToPlayPod
                                                                    .value);
                                                        audioHandler.play();
                                                        homeController.whoAccess
                                                            .value = "pod";
                                                      } else {
                                                        print("pod access");
                                                        if (audioHandler
                                                                .mediaItem
                                                                .value!
                                                                .id !=
                                                            dataController
                                                                .mediaListPodcast[
                                                                    homeController
                                                                        .indexToPlayPod
                                                                        .value]
                                                                .id) {
                                                          await audioHandler
                                                              .skipToQueueItem(
                                                                  homeController
                                                                      .indexToPlayPod
                                                                      .value);
                                                        }

                                                        audioHandler.play();

                                                        homeController.whoAccess
                                                            .value = "pod";
                                                      }
                                                      dataController.addRecently(
                                                          dataController
                                                                  .podcastList[
                                                              homeController
                                                                  .indexToPlayPod
                                                                  .value],
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
                                                            .indexToPlayPod
                                                            .value;

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
                                                                  .indexToPlayPod
                                                                  .value);
                                                      audioHandler.play();
                                                      homeController.whoAccess
                                                          .value = "pod";
                                                    } else {
                                                      if (audioHandler.mediaItem
                                                              .value!.id !=
                                                          dataController
                                                              .mediaListPodcast[
                                                                  homeController
                                                                      .indexToPlayPod
                                                                      .value]
                                                              .id) {
                                                        print(
                                                            "pod access 2 + same");
                                                        await audioHandler
                                                            .skipToQueueItem(
                                                                homeController
                                                                    .indexToPlayPod
                                                                    .value);
                                                      }

                                                      audioHandler.play();

                                                      homeController.whoAccess
                                                          .value = "pod";
                                                    }
                                                    dataController.addRecently(
                                                        dataController
                                                                .podcastList[
                                                            homeController
                                                                .indexToPlayPod
                                                                .value],
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
                                          if (homeController
                                                  .indexToPlayPod.value ==
                                              dataController
                                                      .podcastList.length -
                                                  1) {
                                            homeController.indexToPlayPod =
                                                homeController.indexToPlayPod =
                                                    RxInt(0);
                                            await audioHandler.skipToQueueItem(
                                                homeController
                                                    .indexToPlayPod.value);
                                          } else {
                                            homeController.indexToPlayPod += 1;
                                            await audioHandler.skipToQueueItem(
                                                homeController
                                                    .indexToPlayPod.value);
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
                                                    defaultActionText:
                                                        "LOG IN");
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
                                                                  .indexToPlayPod
                                                                  .value]
                                                          .id)
                                                  ? GestureDetector(
                                                      onTap: () async {
                                                        var response = await RemoteServices.likeDislike(
                                                            like: true,
                                                            postId: dataController
                                                                .podcastList[
                                                                    homeController
                                                                        .indexToPlayPod
                                                                        .value]
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
                                                                        .indexToPlayPod
                                                                        .value]
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
                                ]),
                              )));
                    }),
              ),
            ],
          );
        }),
      ),
    );
  }
}
