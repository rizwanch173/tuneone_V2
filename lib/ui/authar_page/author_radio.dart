import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:share/share.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tuneone/Services/remote_services.dart';
import 'package:tuneone/controllers/data_controller.dart';
import 'package:tuneone/controllers/home_controllers.dart';
import 'package:tuneone/controllers/podcast_controller.dart';
import 'package:tuneone/controllers/radio_controller.dart';
import 'package:tuneone/ui/medialist/medialist_radio.dart';
import 'package:tuneone/ui/shared/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tuneone/ui/singlechannel/single_radio_view.dart';
import 'package:tuneone/ui/styled_widgets/cached_network_image.dart';
import 'package:tuneone/ui/styled_widgets/styled_button.dart';

import '../../main.dart';

class AuthorRadio extends StatelessWidget {
  final DataController dataController = Get.find();
  final HomeController homeController = Get.find();
  final _debouncer = Debouncer(milliseconds: 500);
  @override
  Widget build(BuildContext context) {
    print(homeController.indexToPlayRadio);
    return Scaffold(
      body: Container(
        height: Get.height,
        color: ThemeProvider.themeOf(context).id == "light"
            ? Colors.white
            : Theme.of(context).primaryColor.withOpacity(0.8),
        child: Obx(() {
          return SingleChildScrollView(
            child: Container(
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
                            // Icon(
                            //   Icons.menu,
                            //   color: darkTxt,
                            //   size: 30,
                            // ),

                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: SizedBox(),
                                  ),
                                  AutoSizeText(
                                    "Radio",
                                    style: TextStyle(
                                        color: darkTxt,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: SizedBox(),
                                  )
                                ],
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
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
                SizedBox(
                  height: Get.height * 0.01,
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.20,
                      ),
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            child: StyledCachedNetworkImage2(
                              url: dataController.radioList[0].thumbnail,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      child: Container(
                        width: Get.width * 0.60,
                        child: Align(
                          alignment: Alignment.center,
                          child: MarqueeText(
                            text: TextSpan(
                              text: dataController.radioList[0].title,
                            ),
                            style: TextStyle(
                              color:
                                  ThemeProvider.themeOf(context).id == "light"
                                      ? darkBg
                                      : darkTxt,
                              fontSize: 18,
                            ),
                            speed: 18,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            border: Border.all(
                              width: 1,
                              color:
                                  ThemeProvider.themeOf(context).id == "light"
                                      ? backGroundColor
                                      : darkTxt,
                            ),
                          ),
                          child: StreamBuilder<PlaybackState>(
                            stream: audioHandler.playbackState,
                            builder: (context, snapshot) {
                              final playbackState = snapshot.data;
                              final processingState =
                                  playbackState?.processingState;
                              final playing = playbackState?.playing;
                              if (processingState ==
                                      AudioProcessingState.loading ||
                                  processingState ==
                                      AudioProcessingState.buffering) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    border: Border.all(
                                      width: 1,
                                      color:
                                          ThemeProvider.themeOf(context).id ==
                                                  "light"
                                              ? backGroundColor
                                              : darkTxt,
                                    ),
                                  ),
                                  width: 40.0,
                                  height: 40.0,
                                  child: const CupertinoActivityIndicator(),
                                );
                              } else if (playing == true) {
                                if (audioHandler.mediaItem.value!.id ==
                                    dataController
                                        .radioList[
                                            homeController.indexToPlayRadio]
                                        .stream) {
                                  print("matched");
                                  return Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        border: Border.all(
                                          width: 1,
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  "light"
                                              ? backGroundColor
                                              : darkTxt,
                                        ),
                                      ),
                                      child: Center(
                                        child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(
                                              Icons.play_arrow,
                                              size: 30,
                                            ),
                                            onPressed: () {
                                              audioHandler.pause();
                                            }),
                                      ));
                                } else {
                                  return Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        border: Border.all(
                                          width: 1,
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  "light"
                                              ? backGroundColor
                                              : darkTxt,
                                        ),
                                      ),
                                      child: Center(
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(
                                            Icons.play_arrow,
                                            size: 30,
                                          ),
                                          color: backGroundColor,
                                          onPressed: () async {
                                            // radioController.indexX =
                                            //     homeController
                                            //         .indexToPlayRadio;

                                            if (homeController
                                                        .whoAccess.value ==
                                                    "pod" ||
                                                homeController
                                                        .whoAccess.value ==
                                                    "none") {
                                              await audioHandler.updateQueue(
                                                  dataController
                                                      .mediaListRadio);
                                              await audioHandler
                                                  .skipToQueueItem(
                                                      homeController
                                                          .indexToPlayRadio);
                                              audioHandler.play();
                                              homeController.whoAccess.value =
                                                  "radio";
                                            } else {
                                              await audioHandler
                                                  .skipToQueueItem(
                                                      homeController
                                                          .indexToPlayRadio);
                                              audioHandler.play();
                                              homeController.whoAccess.value =
                                                  "radio";
                                            }
                                            dataController.addRecently(
                                                dataController.radioList[
                                                    homeController
                                                        .indexToPlayRadio],
                                                false);
                                          },
                                        ),
                                      ));
                                }
                              } else {
                                return Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    border: Border.all(
                                      color:
                                          ThemeProvider.themeOf(context).id ==
                                                  "light"
                                              ? backGroundColor
                                              : darkTxt,
                                    ),
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                        Icons.play_arrow,
                                        size: 30,
                                      ),
                                      color: backGroundColor,
                                      onPressed: () async {
                                        // radioController.indexX =
                                        //     homeController
                                        //         .indexToPlayRadio;

                                        if (homeController.whoAccess.value ==
                                                "pod" ||
                                            homeController.whoAccess.value ==
                                                "none") {
                                          await audioHandler.updateQueue(
                                              dataController.mediaListRadio);
                                          await audioHandler.skipToQueueItem(
                                              homeController.indexToPlayRadio);
                                          audioHandler.play();
                                          homeController.whoAccess.value =
                                              "radio";
                                        } else {
                                          await audioHandler.skipToQueueItem(
                                              homeController.indexToPlayRadio);
                                          audioHandler.play();
                                          homeController.whoAccess.value =
                                              "radio";
                                        }
                                        dataController.addRecently(
                                            dataController.radioList[
                                                homeController
                                                    .indexToPlayRadio],
                                            false);
                                      },
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        dataController.islogin.isFalse
                            ? Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  border: Border.all(
                                    width: 1,
                                    color: ThemeProvider.themeOf(context).id ==
                                            "light"
                                        ? Colors.grey.shade400
                                        : darkTxt,
                                  ),
                                ),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.toNamed("/authoption");
                                    },
                                    child: Icon(
                                      Icons.favorite_outline_sharp,
                                      color:
                                          (ThemeProvider.themeOf(context).id ==
                                                  "light")
                                              ? Colors.grey.shade400
                                              : darkTxt,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              )
                            : Obx(
                                () => !dataController.likeList.contains(
                                        dataController
                                            .radioList[
                                                homeController.indexToPlayRadio]
                                            .id)
                                    ? Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          border: Border.all(
                                            width: 1,
                                            color:
                                                ThemeProvider.themeOf(context)
                                                            .id ==
                                                        "light"
                                                    ? Colors.grey.shade400
                                                    : darkTxt,
                                          ),
                                        ),
                                        child: GestureDetector(
                                          onTap: () async {
                                            var response = await RemoteServices
                                                .likeDislike(
                                                    like: true,
                                                    postId: dataController
                                                        .radioList[homeController
                                                            .indexToPlayRadio]
                                                        .id);
                                          },
                                          child: Center(
                                            child: Icon(
                                              Icons.favorite_outline_sharp,
                                              color: (ThemeProvider.themeOf(
                                                              context)
                                                          .id ==
                                                      "light")
                                                  ? Colors.grey.shade400
                                                  : darkTxt,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () async {
                                          var response =
                                              await RemoteServices.likeDislike(
                                                  like: false,
                                                  postId: dataController
                                                      .radioList[homeController
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
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            border: Border.all(
                              width: 1,
                              color:
                                  ThemeProvider.themeOf(context).id == "light"
                                      ? Colors.grey.shade400
                                      : darkTxt,
                            ),
                          ),
                          child: GestureDetector(
                            child: Icon(
                              Icons.ios_share,
                              color:
                                  (ThemeProvider.themeOf(context).id == "light")
                                      ? Colors.grey.shade400
                                      : darkTxt,
                            ),
                            onTap: () async {
                              Share.share(
                                  'https://tuneoneradio.com/station/femme-au-feminin-ep-3/');
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: Get.height * 0.080,
                      decoration: BoxDecoration(
                        color: ThemeProvider.themeOf(context).id == "light"
                            ? Colors.white
                            : darkBg,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x14000000),
                            offset: Offset(0, 5),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Center(
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: StyledCachedNetworkImage2(
                                url: dataController.radioList[0].thumbnail,
                              ),
                            ),
                          ),
                          title: AutoSizeText(
                            dataController.radioList[0].author.displayName,
                            style: TextStyle(
                                color:
                                    ThemeProvider.themeOf(context).id == "light"
                                        ? darkBg
                                        : darkTxt),
                            presetFontSizes: [18, 16],
                          ),
                          subtitle: AutoSizeText(
                            "10 Follower",
                            style: TextStyle(
                              fontFamily: 'Aeonik',
                              fontSize: 13,
                              color:
                                  ThemeProvider.themeOf(context).id == "light"
                                      ? Color(0xffa4a4a4)
                                      : darkTxt,
                              fontWeight: FontWeight.w300,
                            ),
                            presetFontSizes: [12, 14],
                          ),
                          trailing: Container(
                            width: Get.width * 0.25,
                            child: StyledButton(
                              onPressed: () {},
                              title: "Follow",
                              backgroundColor: backGroundColor,
                              titleColor: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    Container(
                      height: Get.height * 0.11,
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: ThemeProvider.themeOf(context).id == "light"
                            ? Colors.white
                            : darkBg,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x14000000),
                            offset: Offset(0, 5),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Contact',
                              style: TextStyle(
                                fontFamily: 'Aeonik',
                                fontSize: 18,
                                color:
                                    ThemeProvider.themeOf(context).id == "light"
                                        ? darkBg
                                        : darkTxt,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: Get.height * 0.005,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Phone:',
                                  style: TextStyle(
                                    fontFamily: 'Aeonik',
                                    fontSize: 15,
                                    color: ThemeProvider.themeOf(context).id ==
                                            "light"
                                        ? Color(0xffa4a4a4)
                                        : darkTxt,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Spacer(),
                                Text(
                                  '+49 176 320 532 46',
                                  style: TextStyle(
                                    fontFamily: 'Aeonik',
                                    fontSize: 15,
                                    color: ThemeProvider.themeOf(context).id ==
                                            "light"
                                        ? Color(0xffa4a4a4)
                                        : darkTxt,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Get.height * 0.005,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Email:',
                                  style: TextStyle(
                                    fontFamily: 'Aeonik',
                                    fontSize: 15,
                                    color: ThemeProvider.themeOf(context).id ==
                                            "light"
                                        ? Color(0xffa4a4a4)
                                        : darkTxt,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Spacer(),
                                Text(
                                  'Paindusoir@yahoo.fr',
                                  style: TextStyle(
                                    fontFamily: 'Aeonik',
                                    fontSize: 15,
                                    color: ThemeProvider.themeOf(context).id ==
                                            "light"
                                        ? Color(0xffa4a4a4)
                                        : darkTxt,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: ThemeProvider.themeOf(context).id == "light"
                            ? Colors.white
                            : darkBg,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x14000000),
                            offset: Offset(0, 5),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.05,
                                vertical: Get.height * 0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AutoSizeText(
                                  "More from: " +
                                      dataController.radioList[0].title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Aeonik-medium",
                                    color: ThemeProvider.themeOf(context).id ==
                                            "light"
                                        ? darkBg
                                        : darkTxt,
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Get.to(() => MediaListRadioView(
                                            title: "Top Stations",
                                            fromLibrary: false,
                                          ));
                                      print("MediaListRadioView");
                                    },
                                    child: AutoSizeText(
                                      "View All",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Aeonik-medium",
                                        color:
                                            ThemeProvider.themeOf(context).id ==
                                                    "light"
                                                ? backGroundColor
                                                : darkTxt,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            height: Get.height * 0.22,
                            child: ListView.builder(
                                itemCount: dataController.radioList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      var radioIndex = dataController
                                          .radioListMasterCopy
                                          .indexWhere((w) =>
                                              w.id ==
                                              dataController
                                                  .radioList[index].id);

                                      homeController.indexToPlayRadio =
                                          radioIndex;

                                      print(radioIndex);
                                      dataController.radioList.value =
                                          dataController.radioListMasterCopy;
                                      Get.to(SingleRadioView());
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  "light"
                                              ? Color(0xffF2F2F2)
                                              : darkTxt.withOpacity(0.2),
                                        ),
                                      ),
                                      margin: EdgeInsets.only(
                                          left: index == 0
                                              ? Get.width * 0.05
                                              : Get.width * 0.03,
                                          bottom: Get.height * 0.03),
                                      child: Container(
                                        width: Get.width * 0.25,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  10.0)),
                                                  child:
                                                      StyledCachedNetworkImage(
                                                    url: dataController
                                                        .radioList[index]
                                                        .thumbnail,
                                                    height: Get.height * 0.4,
                                                  )),
                                              flex: 2,
                                            ),
                                            Expanded(
                                              child: AutoSizeText(
                                                dataController
                                                    .radioList[index].title,
                                                style: TextStyle(
                                                  color: Color(0xffA4A4A4),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                // presetFontSizes: [22, 20],
                                                textAlign: TextAlign.center,
                                              ),
                                              flex: 1,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
              ],
            )
                // : Padding(
                //     padding: EdgeInsets.only(top: Get.height * 0.45),
                //     child: Center(
                //       child: new CupertinoActivityIndicator(
                //         animating: true,
                //         radius: 30,
                //       ),
                //     ),
                //   ),
                ),
          );
        }),
      ),
    );
  }
}

class Debouncer {
  final int? milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds!), action);
  }
}
