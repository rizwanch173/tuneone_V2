import 'package:audio_service/audio_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tuneone/controllers/data_controller.dart';
import 'package:tuneone/controllers/home_controllers.dart';
import 'package:tuneone/controllers/podcast_controller.dart';
import 'package:tuneone/ui/shared/styles.dart';
import 'package:tuneone/ui/styled_widgets/cached_network_image.dart';
import 'package:tuneone/ui/styled_widgets/mini_player.dart';

import '../../main.dart';

class AuthorMediaListPodView extends StatelessWidget {
  final DataController dataController = Get.find();
  final PodcastController podcastController = Get.put(PodcastController());
  final HomeController homeController = Get.find();
  final String? title;

  AuthorMediaListPodView({
    this.title,
  });

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
                            IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: AutoSizeText(
                                  title! + "  'podcast'",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
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
                  child: Column(children: [
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(
                        bottom: homeController.whoAccess.value == "none"
                            ? 0
                            : Get.height * 0.080,
                      ),
                      child: ListView.builder(
                          itemCount: dataController.currentPodCopy.length,
                          itemBuilder: (_, index) {
                            return ListTile(
                              onTap: () {},
                              dense: true,
                              leading: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: StyledCachedNetworkImage(
                                    url: dataController
                                        .currentPodCopy[index].thumbnail,
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
                                  color: (ThemeProvider.themeOf(context).id ==
                                          "light")
                                      ? Colors.grey[400]
                                      : darkTxt,
                                ),
                                child: StreamBuilder<PlaybackState>(
                                    stream: audioHandler.playbackState,
                                    builder: (context, snapshot) {
                                      final playbackState = snapshot.data;
                                      final processingState =
                                          playbackState?.processingState;
                                      final playing = playbackState?.playing;
                                      if ((processingState ==
                                                  AudioProcessingState
                                                      .loading ||
                                              processingState ==
                                                  AudioProcessingState
                                                      .buffering) &&
                                          index == podcastController.indexX) {
                                        return Container(
                                          width: 40.0,
                                          height: 40.0,
                                          child:
                                              const CupertinoActivityIndicator(),
                                        );
                                      } else if (playing == true) {
                                        if (audioHandler.mediaItem.value!.id ==
                                            dataController
                                                .currentPodCopy[index].stream) {
                                          print("matched");
                                          return Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: (ThemeProvider.themeOf(
                                                              context)
                                                          .id ==
                                                      "light")
                                                  ? Colors.grey[400]
                                                  : darkTxt,
                                            ),
                                            child: IconButton(
                                                icon: Icon(
                                                  Icons.pause,
                                                ),
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
                                              color: (ThemeProvider.themeOf(
                                                              context)
                                                          .id ==
                                                      "light")
                                                  ? Colors.grey[400]
                                                  : darkTxt,
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.play_arrow,
                                              ),
                                              onPressed: () async {
                                                podcastController.indexX =
                                                    index;
                                                var podIndex = dataController
                                                    .podcastListMasterCopy
                                                    .indexWhere((w) =>
                                                        w.id ==
                                                        dataController
                                                            .currentPodCopy[
                                                                index]
                                                            .id);
                                                if (homeController
                                                            .whoAccess.value ==
                                                        "radio" ||
                                                    homeController
                                                            .whoAccess.value ==
                                                        "none") {
                                                  await audioHandler.updateQueue(
                                                      dataController
                                                          .mediaListPodcast);
                                                  await audioHandler
                                                      .skipToQueueItem(
                                                          podIndex);
                                                  audioHandler.play();
                                                  homeController
                                                      .whoAccess.value = "pod";
                                                } else {
                                                  if (audioHandler.mediaItem
                                                          .value!.id !=
                                                      dataController
                                                          .mediaListPodcast[
                                                              podcastController
                                                                  .indexX]
                                                          .id) {
                                                    print(
                                                        "pod access 2 + same");
                                                    await audioHandler
                                                        .skipToQueueItem(
                                                            podIndex);
                                                  }
                                                  audioHandler.play();
                                                }

                                                dataController.addRecently(
                                                    dataController
                                                        .currentPodCopy[index],
                                                    true);
                                              },
                                            ),
                                          );
                                        }
                                      } else
                                        return Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                (ThemeProvider.themeOf(context)
                                                            .id ==
                                                        "light")
                                                    ? Colors.grey[400]
                                                    : darkTxt,
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.play_arrow,
                                            ),
                                            onPressed: () async {
                                              podcastController.indexX = index;
                                              var podIndex = dataController
                                                  .podcastListMasterCopy
                                                  .indexWhere((w) =>
                                                      w.id ==
                                                      dataController
                                                          .currentPodCopy[index]
                                                          .id);
                                              if (homeController
                                                          .whoAccess.value ==
                                                      "radio" ||
                                                  homeController
                                                          .whoAccess.value ==
                                                      "none") {
                                                print("pod or none");
                                                await audioHandler.updateQueue(
                                                    dataController
                                                        .mediaListPodcast);
                                                await audioHandler
                                                    .skipToQueueItem(podIndex);
                                                audioHandler.play();
                                                homeController.whoAccess.value =
                                                    "pod";
                                              } else {
                                                print("pod access 2 + same");
                                                if (audioHandler
                                                        .mediaItem.value!.id !=
                                                    dataController
                                                        .mediaListPodcast[index]
                                                        .id) {
                                                  print("pod access 2 + same");
                                                  await audioHandler
                                                      .skipToQueueItem(
                                                          podIndex);
                                                }
                                              }
                                              audioHandler.play();
                                              dataController.addRecently(
                                                  dataController
                                                      .currentPodCopy[index],
                                                  true);
                                            },
                                          ),
                                        );
                                    }),
                              ),
                              title: AutoSizeText(
                                dataController.currentPodCopy[index].title,
                                presetFontSizes: [14, 12],
                                style: TextStyle(
                                  fontWeight: FontWeight.w100,
                                  fontFamily: "Aeonik-medium",
                                  color: ThemeProvider.themeOf(context).id ==
                                          "light"
                                      ? darkBg
                                      : Colors.white,
                                ),
                              ),
                              subtitle: AutoSizeText(
                                dataController
                                    .currentPodCopy[index].author.displayName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w100,
                                  fontFamily: "Aeonik-medium",
                                  color: ThemeProvider.themeOf(context).id ==
                                          "light"
                                      ? Color(0xffA4A4A4)
                                      : darkTxt.withOpacity(0.5),
                                ),
                              ),
                            );
                          }),
                    ))
                  ]),
                ),
              ],
            ),
          ),
          homeController.whoAccess.value != "none"
              ? Positioned(
                  bottom: 0,
                  child: MiniPlayer(),
                )
              : SizedBox(),
        ],
      );
    }));
  }
}
