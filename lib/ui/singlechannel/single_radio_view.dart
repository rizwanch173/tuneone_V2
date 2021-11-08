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
import 'package:tuneone/ui/authar_page/author_radio.dart';
import 'package:tuneone/ui/shared/styles.dart';
import 'package:tuneone/ui/styled_widgets/cached_network_image.dart';
import 'package:rxdart/rxdart.dart' as rxt;
import '../../common.dart';
import '../../main.dart';
import 'package:share/share.dart';

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
    // homeController.prepareAuthorList(
    //     authorId: dataController
    //         .radioList[homeController.indexToPlayRadio].author.authorId);
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
              SizedBox(height: Get.height * 0.06),
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: Icon(
                        LineIcons.stepBackward,
                        color: Colors.white,
                      ),
                      onTap: () async {
                        if (homeController.indexToPlayRadio.value == 0) {
                          homeController.indexToPlayRadio.value =
                              dataController.radioList.length - 1;
                          await audioHandler.skipToQueueItem(
                              homeController.indexToPlayRadio.value);
                        } else {
                          homeController.indexToPlayRadio -= 1;
                          await audioHandler.skipToQueueItem(
                              homeController.indexToPlayRadio.value);
                        }
                      },
                    ),
                    Align(
                      child: Container(
                        width: Get.width * 0.60,
                        child: Align(
                          alignment: Alignment.center,
                          child: MarqueeText(
                            text: TextSpan(
                              text: dataController
                                  .radioList[
                                      homeController.indexToPlayRadio.value]
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
                    GestureDetector(
                      child: Icon(
                        LineIcons.stepForward,
                        color: Colors.white,
                      ),
                      onTap: () async {
                        if (homeController.indexToPlayRadio.value ==
                            dataController.radioList.length - 1) {
                          homeController.indexToPlayRadio =
                              homeController.indexToPlayRadio = RxInt(0);
                          await audioHandler.skipToQueueItem(
                              homeController.indexToPlayRadio.value);
                        } else {
                          homeController.indexToPlayRadio += 1;
                          await audioHandler.skipToQueueItem(
                              homeController.indexToPlayRadio.value);
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
                                  SizedBox(height: Get.height * 0.05),
                                  Obx(
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
                                                        .indexToPlayRadio.value]
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
                                        SizedBox(height: Get.height * 0.03),
                                        TextButton(
                                          onPressed: () {
                                            homeController.prepareAuthorList(
                                                authorId: dataController
                                                    .radioList[homeController
                                                        .indexToPlayRadio.value]
                                                    .author
                                                    .authorId);
                                            Get.to(AuthorRadio(
                                              currentIndex: homeController
                                                  .indexToPlayRadio.value,
                                            ));
                                          },
                                          child: AutoSizeText(
                                            dataController
                                                .radioList[homeController
                                                    .indexToPlayRadio.value]
                                                .author
                                                .displayName,
                                            style:
                                                TextStyle(color: Colors.white),
                                            presetFontSizes: [20, 22],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: Get.height * 0.10),
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
                                              .radioList[homeController
                                                  .indexToPlayRadio.value]
                                              .link);
                                        },
                                      ),
                                      StreamBuilder<Object>(
                                          stream: audioHandler.queueState,
                                          builder: (context, snapshot) {
                                            // var queueState = snapshot.data ??
                                            //     QueueState.empty;
                                            return GestureDetector(
                                              onTap: () async {
                                                if (homeController
                                                        .indexToPlayRadio
                                                        .value ==
                                                    0) {
                                                  homeController
                                                      .indexToPlayRadio
                                                      .value = dataController
                                                          .radioList.length -
                                                      1;
                                                  await audioHandler
                                                      .skipToQueueItem(
                                                          homeController
                                                              .indexToPlayRadio
                                                              .value);
                                                } else {
                                                  homeController
                                                      .indexToPlayRadio -= 1;
                                                  await audioHandler
                                                      .skipToQueueItem(
                                                          homeController
                                                              .indexToPlayRadio
                                                              .value);
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
                                                          .indexToPlayRadio
                                                          .value]
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
                                                      icon: const Icon(
                                                          Icons.pause),
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
                                                              .indexToPlayRadio
                                                              .value;

                                                      if (homeController
                                                                  .whoAccess
                                                                  .value ==
                                                              "pod" ||
                                                          homeController
                                                                  .whoAccess
                                                                  .value ==
                                                              "none") {
                                                        await audioHandler
                                                            .updateQueue(
                                                                dataController
                                                                    .mediaListRadio);
                                                        await audioHandler
                                                            .skipToQueueItem(
                                                                homeController
                                                                    .indexToPlayRadio
                                                                    .value);
                                                        audioHandler.play();
                                                        homeController.whoAccess
                                                            .value = "radio";
                                                      } else {
                                                        await audioHandler
                                                            .skipToQueueItem(
                                                                homeController
                                                                    .indexToPlayRadio
                                                                    .value);
                                                        audioHandler.play();
                                                        homeController.whoAccess
                                                            .value = "radio";
                                                      }
                                                      dataController.addRecently(
                                                          dataController
                                                                  .radioList[
                                                              homeController
                                                                  .indexToPlayRadio
                                                                  .value],
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
                                                            .indexToPlayRadio
                                                            .value;

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
                                                                  .indexToPlayRadio
                                                                  .value);
                                                      audioHandler.play();
                                                      homeController.whoAccess
                                                          .value = "radio";
                                                    } else {
                                                      await audioHandler
                                                          .skipToQueueItem(
                                                              homeController
                                                                  .indexToPlayRadio
                                                                  .value);
                                                      audioHandler.play();
                                                      homeController.whoAccess
                                                          .value = "radio";
                                                    }
                                                    dataController.addRecently(
                                                        dataController
                                                                .radioList[
                                                            homeController
                                                                .indexToPlayRadio
                                                                .value],
                                                        false);
                                                  },
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            print(homeController
                                                .indexToPlayRadio);
                                            if (homeController
                                                    .indexToPlayRadio.value ==
                                                dataController
                                                        .radioList.length -
                                                    1) {
                                              homeController.indexToPlayRadio =
                                                  homeController
                                                          .indexToPlayRadio =
                                                      RxInt(0);
                                              await audioHandler
                                                  .skipToQueueItem(
                                                      homeController
                                                          .indexToPlayRadio
                                                          .value);
                                            } else {
                                              homeController.indexToPlayRadio +=
                                                  1;
                                              print(homeController
                                                  .indexToPlayRadio);
                                              await audioHandler
                                                  .skipToQueueItem(
                                                      homeController
                                                          .indexToPlayRadio
                                                          .value);
                                            }
                                          },
                                          icon: Icon(Icons.skip_next_outlined,
                                              color: Colors.white, size: 40)),
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
                                                size: 30,
                                              ),
                                            )
                                          : Obx(
                                              () => !dataController.likeList
                                                      .contains(dataController
                                                          .radioList[homeController
                                                              .indexToPlayRadio
                                                              .value]
                                                          .id)
                                                  ? GestureDetector(
                                                      onTap: () async {
                                                        await RemoteServices.likeDislike(
                                                            like: true,
                                                            postId: dataController
                                                                .radioList[
                                                                    homeController
                                                                        .indexToPlayRadio
                                                                        .value]
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
                                                        await RemoteServices.likeDislike(
                                                            like: false,
                                                            postId: dataController
                                                                .radioList[
                                                                    homeController
                                                                        .indexToPlayRadio
                                                                        .value]
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
