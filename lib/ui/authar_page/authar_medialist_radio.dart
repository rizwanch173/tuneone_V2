import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tuneone/controllers/data_controller.dart';
import 'package:tuneone/controllers/home_controllers.dart';
import 'package:tuneone/controllers/radio_controller.dart';
import 'package:audio_service/audio_service.dart';
import 'package:tuneone/ui/shared/styles.dart';
import 'package:tuneone/ui/styled_widgets/cached_network_image.dart';
import 'package:tuneone/ui/styled_widgets/mini_player.dart';
import '../../main.dart';

class AuthorMediaListRadioView extends StatelessWidget {
  final DataController dataController = Get.find();
  final RadioController radioController = Get.find();
  final HomeController homeController = Get.find();
  final String? title;

  AuthorMediaListRadioView({
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetX<RadioController>(builder: (radio) {
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
                                  title! + "  'Radio'",
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
                            itemCount: dataController.currentRadioCopy.length,
                            itemBuilder: (_, index) {
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
                                        borderRadius: BorderRadius.circular(4),
                                        child: StyledCachedNetworkImage(
                                          url: dataController
                                              .currentRadioCopy[index]
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
                                          color: (ThemeProvider.themeOf(context)
                                                      .id ==
                                                  "light")
                                              ? Colors.grey[400]
                                              : darkTxt,
                                        ),
                                        child: StreamBuilder<PlaybackState>(
                                            stream: audioHandler.playbackState,
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
                                                      radioController.indexX) {
                                                return Container(
                                                  width: 40.0,
                                                  height: 40.0,
                                                  child:
                                                      const CupertinoActivityIndicator(),
                                                );
                                              } else if (playing == true) {
                                                if (audioHandler
                                                        .mediaItem.value!.id ==
                                                    dataController
                                                        .currentRadioCopy[index]
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
                                                          audioHandler.pause();
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
                                                        var radioIndex = dataController
                                                            .radioListMasterCopy
                                                            .indexWhere((w) =>
                                                                w.id ==
                                                                dataController
                                                                    .currentRadioCopy[
                                                                        index]
                                                                    .id);
                                                        print(radioIndex);

                                                        radioController.indexX =
                                                            index;

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
                                                                  radioIndex);
                                                          audioHandler.play();
                                                          homeController
                                                              .whoAccess
                                                              .value = "radio";
                                                        } else {
                                                          await audioHandler
                                                              .skipToQueueItem(
                                                                  radioIndex);
                                                          audioHandler.play();
                                                          homeController
                                                              .whoAccess
                                                              .value = "radio";
                                                        }
                                                        dataController.addRecently(
                                                            dataController
                                                                    .currentRadioCopy[
                                                                index],
                                                            false);
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
                                                        (ThemeProvider.themeOf(
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
                                                      radioController.indexX =
                                                          index;
                                                      var radioIndex = dataController
                                                          .radioListMasterCopy
                                                          .indexWhere((w) =>
                                                              w.id ==
                                                              dataController
                                                                  .currentRadioCopy[
                                                                      index]
                                                                  .id);
                                                      if (homeController
                                                                  .whoAccess
                                                                  .value ==
                                                              "pod" ||
                                                          homeController
                                                                  .whoAccess
                                                                  .value ==
                                                              "none") {
                                                        print("pod or none");
                                                        await audioHandler
                                                            .updateQueue(
                                                                dataController
                                                                    .mediaListRadio);
                                                        await audioHandler
                                                            .skipToQueueItem(
                                                                radioIndex);
                                                        audioHandler.play();
                                                        homeController.whoAccess
                                                            .value = "radio";
                                                      } else {
                                                        await audioHandler
                                                            .updateQueue(
                                                                dataController
                                                                    .mediaListRadio);
                                                        await audioHandler
                                                            .skipToQueueItem(
                                                                radioIndex);
                                                        audioHandler.play();
                                                        homeController.whoAccess
                                                            .value = "radio";
                                                      }
                                                      dataController.addRecently(
                                                          dataController
                                                                  .currentRadioCopy[
                                                              index],
                                                          false);
                                                    },
                                                  ),
                                                );
                                            })),
                                    title: AutoSizeText(
                                      dataController
                                          .currentRadioCopy[index].title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Aeonik-medium",
                                        color:
                                            ThemeProvider.themeOf(context).id ==
                                                    "light"
                                                ? darkBg
                                                : Colors.white,
                                      ),
                                    ),
                                    subtitle: AutoSizeText(
                                      dataController.currentRadioCopy[index]
                                          .author.displayName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w100,
                                        fontSize: 8,
                                        fontFamily: "Aeonik-medium",
                                        color:
                                            ThemeProvider.themeOf(context).id ==
                                                    "light"
                                                ? Color(0xffA4A4A4)
                                                : darkTxt.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ),
                              );
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
