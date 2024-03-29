import 'dart:io';
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
import 'package:tuneone/ui/authar_page/author_radio_details.dart';
import 'package:tuneone/ui/medialist/medialist_radio.dart';
import 'package:tuneone/ui/shared/styles.dart';
import 'package:tuneone/ui/singlechannel/single_podcast_view.dart';
import 'package:tuneone/ui/singlechannel/single_radio_view.dart';
import 'package:tuneone/ui/styled_widgets/cached_network_image.dart';
import 'package:tuneone/ui/styled_widgets/mini_player.dart';
import 'package:tuneone/ui/styled_widgets/styled_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';

class AuthorRadio extends StatelessWidget {
  final DataController dataController = Get.find();
  final HomeController homeController = Get.find();
  final int currentIndex;

  AuthorRadio({Key? key, required this.currentIndex}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(homeController.indexToPlayRadio);
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.width * 0.04),
                        child: Column(
                          children: [
                            SizedBox(
                              height: Get.height * 0.06,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Center(
                                  child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                        Icons.arrow_back_ios_rounded,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        Get.back();
                                      }),
                                ),
                                AutoSizeText(
                                  "Radio",
                                  style: TextStyle(
                                      color: darkTxt,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800),
                                ),
                                SizedBox(
                                  width: Get.height * 0.05,
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
                            height: Get.height * 0.25,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: AspectRatio(
                                aspectRatio: 1 / 1,
                                child: StyledCachedNetworkImage2(
                                  url: dataController
                                      .radioList[currentIndex].thumbnail,
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                width: 0.5,
                                color:
                                    ThemeProvider.themeOf(context).id == "light"
                                        ? backGroundColor
                                        : darkTxt,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              dataController.radioList[currentIndex].copyright,
                              style: TextStyle(
                                fontFamily: 'Aeonik',
                                fontSize: 15,
                                color:
                                    ThemeProvider.themeOf(context).id == "light"
                                        ? Color(0xffa4a4a4)
                                        : darkTxt,
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.left,
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
                                  text: dataController
                                      .radioList[currentIndex].title,
                                ),
                                style: TextStyle(
                                  color: ThemeProvider.themeOf(context).id ==
                                          "light"
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
                                  color: ThemeProvider.themeOf(context).id ==
                                          "light"
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
                                      width: 40.0,
                                      height: 40.0,
                                      child: const CupertinoActivityIndicator(),
                                    );
                                  } else if (playing == true) {
                                    if (audioHandler.mediaItem.value!.id ==
                                        dataController
                                            .radioList[currentIndex].stream) {
                                      print("matched");
                                      return Container(
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
                                                      ? backGroundColor
                                                      : darkTxt,
                                            ),
                                          ),
                                          child: Center(
                                            child: IconButton(
                                                padding: EdgeInsets.zero,
                                                icon: Icon(Icons.pause,
                                                    size: 30,
                                                    color:
                                                        ThemeProvider.themeOf(
                                                                        context)
                                                                    .id ==
                                                                "light"
                                                            ? backGroundColor
                                                            : darkTxt),
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
                                              color:
                                                  ThemeProvider.themeOf(context)
                                                              .id ==
                                                          "light"
                                                      ? backGroundColor
                                                      : darkTxt,
                                            ),
                                          ),
                                          child: Center(
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              icon: Icon(
                                                Icons.play_arrow,
                                                size: 30,
                                              ),
                                              color:
                                                  ThemeProvider.themeOf(context)
                                                              .id ==
                                                          "light"
                                                      ? backGroundColor
                                                      : darkTxt,
                                              onPressed: () async {
                                                if (homeController
                                                            .whoAccess.value ==
                                                        "pod" ||
                                                    homeController
                                                            .whoAccess.value ==
                                                        "none") {
                                                  await audioHandler
                                                      .updateQueue(
                                                          dataController
                                                              .mediaListRadio);
                                                  await audioHandler
                                                      .skipToQueueItem(
                                                          currentIndex);
                                                  audioHandler.play();
                                                  homeController.whoAccess
                                                      .value = "radio";
                                                } else {
                                                  await audioHandler
                                                      .skipToQueueItem(
                                                          currentIndex);
                                                  audioHandler.play();
                                                  homeController.whoAccess
                                                      .value = "radio";
                                                }
                                                dataController.addRecently(
                                                    dataController.radioList[
                                                        currentIndex],
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
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        border: Border.all(
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
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  "light"
                                              ? backGroundColor
                                              : darkTxt,
                                          onPressed: () async {
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
                                                      currentIndex);
                                              audioHandler.play();
                                              homeController.whoAccess.value =
                                                  "radio";
                                            } else {
                                              await audioHandler
                                                  .skipToQueueItem(
                                                      currentIndex);
                                              audioHandler.play();
                                              homeController.whoAccess.value =
                                                  "radio";
                                            }
                                            dataController.addRecently(
                                                dataController
                                                    .radioList[currentIndex],
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
                                        color:
                                            ThemeProvider.themeOf(context).id ==
                                                    "light"
                                                ? Colors.grey.shade400
                                                : darkTxt,
                                      ),
                                    ),
                                    child: Center(
                                      child: GestureDetector(
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
                                          color: (ThemeProvider.themeOf(context)
                                                      .id ==
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
                                                .radioList[currentIndex].id)
                                        ? Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              border: Border.all(
                                                width: 1,
                                                color: ThemeProvider.themeOf(
                                                                context)
                                                            .id ==
                                                        "light"
                                                    ? Colors.grey.shade400
                                                    : darkTxt,
                                              ),
                                            ),
                                            child: GestureDetector(
                                              onTap: () async {
                                                await RemoteServices
                                                    .likeDislike(
                                                        like: true,
                                                        postId: dataController
                                                            .radioList[
                                                                currentIndex]
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
                                        : Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              border: Border.all(
                                                width: 1,
                                                color: ThemeProvider.themeOf(
                                                                context)
                                                            .id ==
                                                        "light"
                                                    ? Colors.grey.shade400
                                                    : darkTxt,
                                              ),
                                            ),
                                            child: GestureDetector(
                                              onTap: () async {
                                                await RemoteServices
                                                    .likeDislike(
                                                        like: false,
                                                        postId: dataController
                                                            .radioList[
                                                                currentIndex]
                                                            .id);
                                              },
                                              child: Icon(
                                                Icons.favorite_outlined,
                                                color: ThemeProvider.themeOf(
                                                                context)
                                                            .id ==
                                                        "light"
                                                    ? Colors.grey.shade400
                                                    : darkTxt,
                                                size: 30,
                                              ),
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
                                  color: ThemeProvider.themeOf(context).id ==
                                          "light"
                                      ? Colors.grey.shade400
                                      : darkTxt,
                                ),
                              ),
                              child: GestureDetector(
                                child: Icon(
                                  Icons.ios_share,
                                  color: (ThemeProvider.themeOf(context).id ==
                                          "light")
                                      ? Colors.grey.shade400
                                      : darkTxt,
                                ),
                                onTap: () async {
                                  Share.share(
                                      ' ${dataController.radioList[currentIndex].link}');
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: Get.height * 0.100,
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
                              onTap: () {
                                Get.to(AuthorRadioDetails(
                                  currentIndex: currentIndex,
                                ));
                              },
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: AspectRatio(
                                  aspectRatio: 1 / 1,
                                  child: StyledCachedNetworkImage2(
                                    url: dataController.radioList[currentIndex]
                                        .author.avtarUrl,
                                  ),
                                ),
                              ),
                              title: AutoSizeText(
                                dataController
                                    .radioList[currentIndex].author.displayName,
                                style: TextStyle(
                                    color: ThemeProvider.themeOf(context).id ==
                                            "light"
                                        ? darkBg
                                        : darkTxt),
                                presetFontSizes: [18, 16],
                              ),
                              subtitle: AutoSizeText(
                                dataController.radioList[currentIndex].author
                                        .follow.length
                                        .toString() +
                                    " Followers",
                                style: TextStyle(
                                  fontFamily: 'Aeonik',
                                  fontSize: 13,
                                  color: ThemeProvider.themeOf(context).id ==
                                          "light"
                                      ? Color(0xffa4a4a4)
                                      : darkTxt,
                                  fontWeight: FontWeight.w300,
                                ),
                                presetFontSizes: [12, 14],
                              ),
                              trailing: dataController.islogin.isFalse
                                  ? Container(
                                      width: Get.width * 0.25,
                                      child: StyledButton(
                                        onPressed: () {
                                          homeController.showAlertDialog(
                                              context: context,
                                              title: "ATTENTION!",
                                              content:
                                                  "Please Sign In To Continue This Action",
                                              cancelActionText: "CANCEL",
                                              defaultActionText: "LOG IN");
                                        },
                                        title: "Follow",
                                        backgroundColor: backGroundColor,
                                        titleColor: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        fontSize: 16,
                                      ),
                                    )
                                  : Obx(
                                      () => dataController.followList.contains(
                                              int.parse(dataController
                                                  .radioList[currentIndex]
                                                  .author
                                                  .authorId))
                                          ? Container(
                                              width: Get.width * 0.25,
                                              child: StyledButton(
                                                onPressed: () {
                                                  dataController.followList
                                                      .remove(int.parse(
                                                          dataController
                                                              .radioList[
                                                                  currentIndex]
                                                              .author
                                                              .authorId));

                                                  RemoteServices
                                                      .followOrUnfollow(
                                                    follow: false,
                                                    channelId: int.parse(
                                                        dataController
                                                            .radioList[
                                                                currentIndex]
                                                            .author
                                                            .authorId),
                                                  );
                                                },
                                                title: "Following",
                                                backgroundColor:
                                                    backGroundColor,
                                                titleColor: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                fontSize: 16,
                                              ),
                                            )
                                          : Container(
                                              width: Get.width * 0.25,
                                              child: StyledButton(
                                                onPressed: () {
                                                  dataController.followList.add(
                                                      int.parse(dataController
                                                          .radioList[
                                                              currentIndex]
                                                          .author
                                                          .authorId));

                                                  RemoteServices
                                                      .followOrUnfollow(
                                                    follow: true,
                                                    channelId: int.parse(
                                                        dataController
                                                            .radioList[
                                                                currentIndex]
                                                            .author
                                                            .authorId),
                                                  );
                                                },
                                                title: "Follow",
                                                backgroundColor:
                                                    backGroundColor,
                                                titleColor: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                fontSize: 16,
                                              ),
                                            ),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.01,
                        ),
                        Container(
                          height: Get.height * 0.24,
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
                                    color: ThemeProvider.themeOf(context).id ==
                                            "light"
                                        ? darkBg
                                        : darkTxt,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  height: Get.height * 0.008,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Phone:',
                                      style: TextStyle(
                                        fontFamily: 'Aeonik',
                                        fontSize: 15,
                                        color:
                                            ThemeProvider.themeOf(context).id ==
                                                    "light"
                                                ? Color(0xffa4a4a4)
                                                : darkTxt,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Spacer(),
                                    Row(
                                      children: [
                                        Text(
                                          dataController.radioList[currentIndex]
                                              .author.whatsapp,
                                          style: TextStyle(
                                            fontFamily: 'Aeonik',
                                            fontSize: 15,
                                            color:
                                                ThemeProvider.themeOf(context)
                                                            .id ==
                                                        "light"
                                                    ? Color(0xffa4a4a4)
                                                    : darkTxt,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        dataController.radioList[currentIndex]
                                                    .author.whatsapp !=
                                                "---"
                                            ? Row(
                                                children: [
                                                  SizedBox(
                                                    width: Get.height * 0.02,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      String uri = Uri.encodeFull(
                                                          'sms:${dataController.radioList[currentIndex].author.whatsapp}');
                                                      await launch(uri);
                                                    },
                                                    child: Icon(
                                                      Icons.sms_outlined,
                                                      size: 28,
                                                      color:
                                                          ThemeProvider.themeOf(
                                                                          context)
                                                                      .id ==
                                                                  "light"
                                                              ? Colors.grey
                                                              : darkTxt,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: Get.height * 0.02,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      String uri = Uri.encodeFull(
                                                          'tel:${dataController.radioList[currentIndex].author.whatsapp}');
                                                      await launch(uri);
                                                    },
                                                    child: Icon(
                                                      Icons
                                                          .phone_enabled_outlined,
                                                      size: 28,
                                                      color:
                                                          ThemeProvider.themeOf(
                                                                          context)
                                                                      .id ==
                                                                  "light"
                                                              ? Colors.grey
                                                              : darkTxt,
                                                    ),
                                                  )
                                                ],
                                              )
                                            : SizedBox(),
                                      ],
                                      // crossAxisAlignment:
                                      //     CrossAxisAlignment.start,
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.start,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: Get.height * 0.012,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Email:',
                                      style: TextStyle(
                                        fontFamily: 'Aeonik',
                                        fontSize: 15,
                                        color:
                                            ThemeProvider.themeOf(context).id ==
                                                    "light"
                                                ? Color(0xffa4a4a4)
                                                : darkTxt,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Spacer(),
                                    Row(
                                      children: [
                                        Text(
                                          dataController.radioList[currentIndex]
                                              .author.email,
                                          style: TextStyle(
                                            fontFamily: 'Aeonik',
                                            fontSize: 15,
                                            color:
                                                ThemeProvider.themeOf(context)
                                                            .id ==
                                                        "light"
                                                    ? Color(0xffa4a4a4)
                                                    : darkTxt,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        SizedBox(
                                          width: Get.height * 0.02,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            String uri = Uri.encodeFull(
                                                'mailto:${dataController.radioList[currentIndex].author.email}?subject=About${dataController.radioList[currentIndex].author.displayName}&body=');
                                            await launch(uri);
                                          },
                                          child: Icon(
                                            Icons.email_outlined,
                                            size: 28,
                                            color:
                                                ThemeProvider.themeOf(context)
                                                            .id ==
                                                        "light"
                                                    ? Colors.grey
                                                    : darkTxt,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: Get.height * 0.018,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Social:',
                                      style: TextStyle(
                                        fontFamily: 'Aeonik',
                                        fontSize: 15,
                                        color:
                                            ThemeProvider.themeOf(context).id ==
                                                    "light"
                                                ? Color(0xffa4a4a4)
                                                : darkTxt,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: SvgPicture.asset(
                                              "assets/Icon awesome-facebook.svg",
                                              color:
                                                  ThemeProvider.themeOf(context)
                                                              .id ==
                                                          "light"
                                                      ? Colors.grey
                                                      : darkTxt,
                                            ),
                                            onPressed: () async {
                                              await canLaunch(
                                                dataController
                                                    .radioList[currentIndex]
                                                    .author
                                                    .facebook[0],
                                              )
                                                  ? await launch(dataController
                                                      .radioList[currentIndex]
                                                      .author
                                                      .facebook[0])
                                                  : throw 'Could not launch ${dataController.radioList[currentIndex].author.facebook[0]}';
                                            },
                                          ),
                                          height: 30,
                                          width: 30,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          child: IconButton(
                                              padding: EdgeInsets.zero,
                                              icon: SvgPicture.asset(
                                                "assets/Icon awesome-instagram.svg",
                                                color: ThemeProvider.themeOf(
                                                                context)
                                                            .id ==
                                                        "light"
                                                    ? Colors.grey
                                                    : darkTxt,
                                              ),
                                              onPressed: () async {
                                                await canLaunch(
                                                  dataController
                                                      .radioList[currentIndex]
                                                      .author
                                                      .instagram,
                                                )
                                                    ? await launch(
                                                        dataController
                                                            .radioList[
                                                                currentIndex]
                                                            .author
                                                            .instagram,
                                                        universalLinksOnly:
                                                            true,
                                                      )
                                                    : throw 'Could not launch ${dataController.radioList[currentIndex].author.instagram}';
                                              }),
                                          height: 30,
                                          width: 30,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          child: IconButton(
                                              padding: EdgeInsets.zero,
                                              icon: SvgPicture.asset(
                                                "assets/Icon ionic-logo-whatsapp.svg",
                                                color: ThemeProvider.themeOf(
                                                                context)
                                                            .id ==
                                                        "light"
                                                    ? Colors.grey
                                                    : darkTxt,
                                              ),
                                              onPressed: () async {
                                                if (Platform.isIOS) {
                                                  launchWhatsApp(
                                                      phone: dataController
                                                          .radioList[
                                                              currentIndex]
                                                          .author
                                                          .whatsapp
                                                          .replaceAll(" ", ""),
                                                      message: "Hi");
                                                } else {
                                                  await launch(
                                                    "whatsapp://send?phone=${dataController.radioList[currentIndex].author.whatsapp}&text=${Uri.encodeFull("Hi  " + "${dataController.radioList[currentIndex].author.displayName}")}",
                                                    universalLinksOnly: true,
                                                  );
                                                }
                                              }),
                                          height: 30,
                                          width: 30,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.01,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: homeController.whoAccess.value != "none"
                                  ? Get.height * 0.05
                                  : 0),
                          child: Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                              color:
                                  ThemeProvider.themeOf(context).id == "light"
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AutoSizeText(
                                        "More from: " +
                                            dataController
                                                .radioList[currentIndex]
                                                .author
                                                .displayName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Aeonik-medium",
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
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
                                                  ThemeProvider.themeOf(context)
                                                              .id ==
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
                                      itemCount:
                                          dataController.morefromList.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (dataController
                                                    .morefromList[index]
                                                    .duration ==
                                                0) {
                                              var radioIndex = dataController
                                                  .radioListMasterCopy
                                                  .indexWhere((w) =>
                                                      w.id ==
                                                      dataController
                                                          .morefromList[index]
                                                          .id);

                                              homeController.indexToPlayRadio
                                                  .value = radioIndex;
                                              dataController.radioList.value =
                                                  dataController
                                                      .radioListMasterCopy;
                                              Get.to(SingleRadioView());
                                              print("radioIndex");
                                              print(radioIndex);
                                            } else {
                                              var podIndex = dataController
                                                  .podcastListMasterCopy
                                                  .indexWhere((w) =>
                                                      w.id ==
                                                      dataController
                                                          .morefromList[index]
                                                          .id);
                                              homeController.indexToPlayPod
                                                  .value = podIndex;
                                              print("podIndex");
                                              print(podIndex);
                                              dataController.podcastList.value =
                                                  dataController
                                                      .podcastListMasterCopy;
                                              Get.to(SinglePodcastView());
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              border: Border.all(
                                                color: ThemeProvider.themeOf(
                                                                context)
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
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10.0),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10.0)),
                                                        child:
                                                            StyledCachedNetworkImage(
                                                          url: dataController
                                                              .morefromList[
                                                                  index]
                                                              .thumbnail,
                                                          height:
                                                              Get.height * 0.4,
                                                        )),
                                                    flex: 2,
                                                  ),
                                                  Expanded(
                                                    child: AutoSizeText(
                                                      dataController
                                                          .morefromList[index]
                                                          .title,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xffA4A4A4),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      // presetFontSizes: [22, 20],
                                                      textAlign:
                                                          TextAlign.center,
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
          homeController.whoAccess.value != "none"
              ? Positioned(
                  bottom: 0,
                  child: MiniPlayer(),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  void launchWhatsApp({
    required String phone,
    required String message,
  }) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }
}
