import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tuneone/controllers/data_controller.dart';
import 'package:tuneone/controllers/home_controllers.dart';
import 'package:tuneone/controllers/podcast_controller.dart';
import 'package:audio_service/audio_service.dart';
import 'package:tuneone/ui/shared/styles.dart';
import 'package:tuneone/ui/styled_widgets/cached_network_image.dart';
import 'package:tuneone/ui/styled_widgets/mini_player.dart';
import '../../main.dart';

class GenreMediaListPodView extends StatelessWidget {
  final DataController dataController = Get.find();
  final PodcastController podcastController = Get.find();
  final HomeController homeController = Get.find();
  final String title;
  final int genreId;

  GenreMediaListPodView({required this.title, required this.genreId});

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
                                  title,
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
                  child: Column(children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: homeController.whoAccess.value == "none"
                              ? 0
                              : Get.height * 0.080,
                        ),
                        child: ListView.builder(
                            itemCount:
                                dataController.podcastListMasterCopy.length,
                            itemBuilder: (_, index) {
                              if (dataController
                                  .podcastListMasterCopy[index].genres
                                  .contains(genreId)) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                        color:
                                            ThemeProvider.themeOf(context).id ==
                                                    "light"
                                                ? Color(0xffF2F2F2)
                                                : darkTxt.withOpacity(0.2),
                                      ),
                                    ),
                                    child: ListTile(
                                      onTap: () {},
                                      dense: true,
                                      leading: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: StyledCachedNetworkImage(
                                            url: dataController
                                                .podcastListMasterCopy[index]
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
                                            color:
                                                (ThemeProvider.themeOf(context)
                                                            .id ==
                                                        "light")
                                                    ? Colors.grey[400]
                                                    : darkTxt,
                                          ),
                                          child: StreamBuilder<PlaybackState>(
                                              stream:
                                                  audioHandler.playbackState,
                                              builder: (context, snapshot) {
                                                final playbackState =
                                                    snapshot.data;
                                                final processingState =
                                                    playbackState
                                                        ?.processingState;
                                                final playing =
                                                    playbackState?.playing;
                                                if ((processingState ==
                                                            AudioProcessingState
                                                                .loading ||
                                                        processingState ==
                                                            AudioProcessingState
                                                                .buffering) &&
                                                    index ==
                                                        podcastController
                                                            .indexX) {
                                                  return Container(
                                                    width: 40.0,
                                                    height: 40.0,
                                                    child:
                                                        const CupertinoActivityIndicator(),
                                                  );
                                                } else if (playing == true) {
                                                  if (audioHandler.mediaItem
                                                          .value!.id ==
                                                      dataController
                                                          .podcastListMasterCopy[
                                                              index]
                                                          .stream) {
                                                    print("matched");
                                                    return Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: (ThemeProvider
                                                                        .themeOf(
                                                                            context)
                                                                    .id ==
                                                                "light")
                                                            ? Colors.grey[400]
                                                            : darkTxt,
                                                      ),
                                                      child: IconButton(
                                                          icon: const Icon(
                                                              Icons.pause),
                                                          onPressed: () {
                                                            audioHandler
                                                                .pause();
                                                          }),
                                                    );
                                                  } else {
                                                    return Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: (ThemeProvider
                                                                        .themeOf(
                                                                            context)
                                                                    .id ==
                                                                "light")
                                                            ? Colors.grey[400]
                                                            : darkTxt,
                                                      ),
                                                      child: IconButton(
                                                        icon: const Icon(
                                                            Icons.play_arrow),
                                                        onPressed: () async {
                                                          podcastController
                                                              .indexX = index;

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
                                                                    index);
                                                            audioHandler.play();
                                                            homeController
                                                                .whoAccess
                                                                .value = "pod";
                                                          } else {
                                                            if (audioHandler
                                                                    .mediaItem
                                                                    .value!
                                                                    .id !=
                                                                dataController
                                                                    .mediaListPodcast[
                                                                        podcastController
                                                                            .indexX]
                                                                    .id) {
                                                              print(
                                                                  "pod access 2 + same");
                                                              await audioHandler
                                                                  .skipToQueueItem(
                                                                      index);
                                                            }
                                                            audioHandler.play();

                                                            homeController
                                                                .whoAccess
                                                                .value = "pod";
                                                          }
                                                          dataController
                                                              .addRecently(
                                                                  dataController
                                                                          .podcastListMasterCopy[
                                                                      index],
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
                                                      color: (ThemeProvider
                                                                      .themeOf(
                                                                          context)
                                                                  .id ==
                                                              "light")
                                                          ? Colors.grey[400]
                                                          : darkTxt,
                                                    ),
                                                    child: IconButton(
                                                      icon: const Icon(
                                                          Icons.play_arrow),
                                                      onPressed: () async {
                                                        podcastController
                                                            .indexX = index;

                                                        if (homeController
                                                                    .whoAccess
                                                                    .value ==
                                                                "radio" ||
                                                            homeController
                                                                    .whoAccess
                                                                    .value ==
                                                                "none") {
                                                          print("pod or none");
                                                          await audioHandler
                                                              .updateQueue(
                                                                  dataController
                                                                      .mediaListPodcast);
                                                          await audioHandler
                                                              .skipToQueueItem(
                                                                  index);
                                                          audioHandler.play();
                                                          homeController
                                                              .whoAccess
                                                              .value = "pod";
                                                        } else {
                                                          print(
                                                              "pod access 2 + same");
                                                          if (audioHandler
                                                                  .mediaItem
                                                                  .value!
                                                                  .id !=
                                                              dataController
                                                                  .mediaListPodcast[
                                                                      index]
                                                                  .id) {
                                                            print(
                                                                "pod access 2 + same");
                                                            await audioHandler
                                                                .skipToQueueItem(
                                                                    index);
                                                          }

                                                          audioHandler.play();
                                                          homeController
                                                              .whoAccess
                                                              .value = "pod";
                                                        }
                                                        dataController.addRecently(
                                                            dataController
                                                                    .podcastListMasterCopy[
                                                                index],
                                                            true);
                                                      },
                                                    ),
                                                  );
                                              })),
                                      title: AutoSizeText(
                                        dataController
                                            .podcastListMasterCopy[index].title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Aeonik-medium",
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  "light"
                                              ? darkBg
                                              : Colors.white,
                                        ),
                                      ),
                                      subtitle: AutoSizeText(
                                        dataController
                                            .podcastListMasterCopy[index]
                                            .author
                                            .displayName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w100,
                                          fontSize: 8,
                                          fontFamily: "Aeonik-medium",
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  "light"
                                              ? Color(0xffA4A4A4)
                                              : darkTxt.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return SizedBox();
                              }
                            }),
                      ),
                    )
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
