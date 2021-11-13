import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:share/share.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tuneone/Services/remote_services.dart';
import 'package:tuneone/controllers/data_controller.dart';
import 'package:tuneone/controllers/home_controllers.dart';
import 'package:tuneone/ui/medialist/medialist_radio.dart';
import 'package:tuneone/ui/shared/styles.dart';
import 'package:tuneone/ui/singlechannel/single_podcast_view.dart';
import 'package:tuneone/ui/singlechannel/single_radio_view.dart';
import 'package:tuneone/ui/styled_widgets/cached_network_image.dart';
import 'package:tuneone/ui/styled_widgets/mini_player.dart';
import 'package:tuneone/ui/styled_widgets/styled_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';

class AuthorRadioDetails extends StatelessWidget {
  final DataController dataController = Get.find();
  final HomeController homeController = Get.find();
  final int currentIndex;

  AuthorRadioDetails({Key? key, required this.currentIndex}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    homeController.selectedIndex.value = 0;
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
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      dataController.radioList[currentIndex]
                                          .author.displayName,
                                      style: TextStyle(
                                          color: darkTxt,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                        Icons.home,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        Get.offAndToNamed("/tabs");
                                      }),
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
                                  url: dataController
                                      .radioList[currentIndex].author.avtarUrl,
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
                          height: 15,
                        ),
                        Align(
                          child: Container(
                            width: Get.width * 0.60,
                            child: Align(
                              alignment: Alignment.center,
                              child: MarqueeText(
                                text: TextSpan(
                                  text: dataController.radioList[currentIndex]
                                      .author.displayName,
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
                          height: 5,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            dataController
                                .radioList[currentIndex].author.description,
                            style: TextStyle(
                              fontFamily: 'Aeonik',
                              fontSize: 13,
                              color:
                                  ThemeProvider.themeOf(context).id == "light"
                                      ? Color(0xffa4a4a4)
                                      : darkTxt,
                              fontWeight: FontWeight.w300,
                            ),
                            maxLines: 5,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.025,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Container(
                            //   height: 40,
                            //   width: 40,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(50.0),
                            //     border: Border.all(
                            //       width: 1,
                            //       color: ThemeProvider.themeOf(context).id ==
                            //               "light"
                            //           ? backGroundColor
                            //           : darkTxt,
                            //     ),
                            //   ),
                            //   child: StreamBuilder<PlaybackState>(
                            //     stream: audioHandler.playbackState,
                            //     builder: (context, snapshot) {
                            //       final playbackState = snapshot.data;
                            //       final processingState =
                            //           playbackState?.processingState;
                            //       final playing = playbackState?.playing;
                            //       if (processingState ==
                            //               AudioProcessingState.loading ||
                            //           processingState ==
                            //               AudioProcessingState.buffering) {
                            //         return Container(
                            //           decoration: BoxDecoration(
                            //             borderRadius:
                            //                 BorderRadius.circular(50.0),
                            //             border: Border.all(
                            //               width: 1,
                            //               color: ThemeProvider.themeOf(context)
                            //                           .id ==
                            //                       "light"
                            //                   ? backGroundColor
                            //                   : darkTxt,
                            //             ),
                            //           ),
                            //           width: 40.0,
                            //           height: 40.0,
                            //           child: const CupertinoActivityIndicator(),
                            //         );
                            //       } else if (playing == true) {
                            //         if (audioHandler.mediaItem.value!.id ==
                            //             dataController
                            //                 .radioList[currentIndex].stream) {
                            //           print("matched");
                            //           return Container(
                            //               height: 40,
                            //               width: 40,
                            //               decoration: BoxDecoration(
                            //                 borderRadius:
                            //                     BorderRadius.circular(50.0),
                            //                 border: Border.all(
                            //                   width: 1,
                            //                   color:
                            //                       ThemeProvider.themeOf(context)
                            //                                   .id ==
                            //                               "light"
                            //                           ? backGroundColor
                            //                           : darkTxt,
                            //                 ),
                            //               ),
                            //               child: Center(
                            //                 child: IconButton(
                            //                     padding: EdgeInsets.zero,
                            //                     icon: Icon(Icons.pause,
                            //                         size: 30,
                            //                         color:
                            //                             ThemeProvider.themeOf(
                            //                                             context)
                            //                                         .id ==
                            //                                     "light"
                            //                                 ? backGroundColor
                            //                                 : darkTxt),
                            //                     onPressed: () {
                            //                       audioHandler.pause();
                            //                     }),
                            //               ));
                            //         } else {
                            //           return Container(
                            //               height: 40,
                            //               width: 40,
                            //               decoration: BoxDecoration(
                            //                 borderRadius:
                            //                     BorderRadius.circular(50.0),
                            //                 border: Border.all(
                            //                   width: 1,
                            //                   color:
                            //                       ThemeProvider.themeOf(context)
                            //                                   .id ==
                            //                               "light"
                            //                           ? backGroundColor
                            //                           : darkTxt,
                            //                 ),
                            //               ),
                            //               child: Center(
                            //                 child: IconButton(
                            //                   padding: EdgeInsets.zero,
                            //                   icon: Icon(
                            //                     Icons.play_arrow,
                            //                     size: 30,
                            //                   ),
                            //                   color:
                            //                       ThemeProvider.themeOf(context)
                            //                                   .id ==
                            //                               "light"
                            //                           ? backGroundColor
                            //                           : darkTxt,
                            //                   onPressed: () async {
                            //                     if (homeController
                            //                                 .whoAccess.value ==
                            //                             "pod" ||
                            //                         homeController
                            //                                 .whoAccess.value ==
                            //                             "none") {
                            //                       await audioHandler
                            //                           .updateQueue(
                            //                               dataController
                            //                                   .mediaListRadio);
                            //                       await audioHandler
                            //                           .skipToQueueItem(
                            //                               currentIndex);
                            //                       audioHandler.play();
                            //                       homeController.whoAccess
                            //                           .value = "radio";
                            //                     } else {
                            //                       await audioHandler
                            //                           .skipToQueueItem(
                            //                               currentIndex);
                            //                       audioHandler.play();
                            //                       homeController.whoAccess
                            //                           .value = "radio";
                            //                     }
                            //                     dataController.addRecently(
                            //                         dataController.radioList[
                            //                             currentIndex],
                            //                         false);
                            //                   },
                            //                 ),
                            //               ));
                            //         }
                            //       } else {
                            //         return Container(
                            //           height: 40,
                            //           width: 40,
                            //           decoration: BoxDecoration(
                            //             borderRadius:
                            //                 BorderRadius.circular(50.0),
                            //             border: Border.all(
                            //               color: ThemeProvider.themeOf(context)
                            //                           .id ==
                            //                       "light"
                            //                   ? backGroundColor
                            //                   : darkTxt,
                            //             ),
                            //           ),
                            //           child: Center(
                            //             child: IconButton(
                            //               padding: EdgeInsets.zero,
                            //               icon: const Icon(
                            //                 Icons.play_arrow,
                            //                 size: 30,
                            //               ),
                            //               color: ThemeProvider.themeOf(context)
                            //                           .id ==
                            //                       "light"
                            //                   ? backGroundColor
                            //                   : darkTxt,
                            //               onPressed: () async {
                            //                 if (homeController
                            //                             .whoAccess.value ==
                            //                         "pod" ||
                            //                     homeController
                            //                             .whoAccess.value ==
                            //                         "none") {
                            //                   await audioHandler.updateQueue(
                            //                       dataController
                            //                           .mediaListRadio);
                            //                   await audioHandler
                            //                       .skipToQueueItem(
                            //                           currentIndex);
                            //                   audioHandler.play();
                            //                   homeController.whoAccess.value =
                            //                       "radio";
                            //                 } else {
                            //                   await audioHandler
                            //                       .skipToQueueItem(
                            //                           currentIndex);
                            //                   audioHandler.play();
                            //                   homeController.whoAccess.value =
                            //                       "radio";
                            //                 }
                            //                 dataController.addRecently(
                            //                     dataController
                            //                         .radioList[currentIndex],
                            //                     false);
                            //               },
                            //             ),
                            //           ),
                            //         );
                            //       }
                            //     },
                            //   ),
                            // ),
                            // Container(
                            //   height: 40,
                            //   width: 40,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(50.0),
                            //     border: Border.all(
                            //       width: 1,
                            //       color: ThemeProvider.themeOf(context).id ==
                            //               "light"
                            //           ? Colors.grey.shade400
                            //           : darkTxt,
                            //     ),
                            //   ),
                            //   child: Center(
                            //     child: Text(
                            //       homeController.k_m_b_generator(int.parse(
                            //           dataController.radioList[currentIndex]
                            //               .author.totalPlayed)),
                            //       style: TextStyle(
                            //         fontFamily: 'Aeonik',
                            //         fontSize: 12,
                            //         color: ThemeProvider.themeOf(context).id ==
                            //                 "light"
                            //             ? Color(0xffa4a4a4)
                            //             : darkTxt,
                            //         fontWeight: FontWeight.bold,
                            //       ),
                            //       textAlign: TextAlign.left,
                            //     ),
                            //   ),
                            // ),

                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              height: 40,
                              child: dataController.islogin.isFalse
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
                                        borderRadius: BorderRadius.circular(50),
                                        fontSize: 14,
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
                                                    BorderRadius.circular(25),
                                                fontSize: 14,
                                              ),
                                            )
                                          : Container(
                                              width: Get.width * 0.20,
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
                                                    BorderRadius.circular(25),
                                                fontSize: 14,
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
                                      ' ${dataController.radioList[currentIndex].author.link}');
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        Row(
                          children: [
                            Text(
                              'Total played:  ',
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
                            Text(
                              homeController.k_m_b_generator(int.parse(
                                  dataController.radioList[currentIndex].author
                                      .totalPlayed)),
                              style: TextStyle(
                                fontFamily: 'Aeonik',
                                fontSize: 15,
                                color:
                                    ThemeProvider.themeOf(context).id == "light"
                                        ? Color(0xffa4a4a4)
                                        : darkTxt,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        SizedBox(
                          height: Get.height * 0.02,
                        ),

                        // Container(
                        //   width: Get.width,
                        //   decoration: BoxDecoration(
                        //     color: ThemeProvider.themeOf(context).id == "light"
                        //         ? Colors.white
                        //         : darkBg,
                        //     borderRadius: BorderRadius.circular(10.0),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: const Color(0x14000000),
                        //         offset: Offset(0, 5),
                        //         blurRadius: 20,
                        //       ),
                        //     ],
                        //   ),
                        //   child: Column(
                        //     children: [
                        //       Padding(
                        //         padding: EdgeInsets.symmetric(
                        //             horizontal: Get.width * 0.05,
                        //             vertical: Get.height * 0.02),
                        //         child: Row(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             AutoSizeText(
                        //               "More from: " +
                        //                   dataController.radioList[currentIndex]
                        //                       .author.displayName,
                        //               style: TextStyle(
                        //                 fontWeight: FontWeight.w600,
                        //                 fontFamily: "Aeonik-medium",
                        //                 color:
                        //                     ThemeProvider.themeOf(context).id ==
                        //                             "light"
                        //                         ? darkBg
                        //                         : darkTxt,
                        //               ),
                        //             ),
                        //             GestureDetector(
                        //                 onTap: () {
                        //                   Get.to(() => MediaListRadioView(
                        //                         title: "Top Stations",
                        //                         fromLibrary: false,
                        //                       ));
                        //                   print("MediaListRadioView");
                        //                 },
                        //                 child: AutoSizeText(
                        //                   "View All",
                        //                   style: TextStyle(
                        //                     fontWeight: FontWeight.w600,
                        //                     fontFamily: "Aeonik-medium",
                        //                     color:
                        //                         ThemeProvider.themeOf(context)
                        //                                     .id ==
                        //                                 "light"
                        //                             ? backGroundColor
                        //                             : darkTxt,
                        //                   ),
                        //                 )),
                        //           ],
                        //         ),
                        //       ),
                        //       Container(
                        //         height: Get.height * 0.22,
                        //         child: ListView.builder(
                        //             itemCount:
                        //                 dataController.morefromList.length,
                        //             scrollDirection: Axis.horizontal,
                        //             itemBuilder: (context, index) {
                        //               return GestureDetector(
                        //                 onTap: () {
                        //                   if (dataController.morefromList[index]
                        //                           .duration ==
                        //                       0) {
                        //                     var radioIndex = dataController
                        //                         .radioListMasterCopy
                        //                         .indexWhere((w) =>
                        //                             w.id ==
                        //                             dataController
                        //                                 .morefromList[index]
                        //                                 .id);
                        //
                        //                     homeController.indexToPlayRadio
                        //                         .value = radioIndex;
                        //                     dataController.radioList.value =
                        //                         dataController
                        //                             .radioListMasterCopy;
                        //                     Get.to(SingleRadioView());
                        //                     print("radioIndex");
                        //                     print(radioIndex);
                        //                   } else {
                        //                     var podIndex = dataController
                        //                         .podcastListMasterCopy
                        //                         .indexWhere((w) =>
                        //                             w.id ==
                        //                             dataController
                        //                                 .morefromList[index]
                        //                                 .id);
                        //                     homeController.indexToPlayPod
                        //                         .value = podIndex;
                        //                     print("podIndex");
                        //                     print(podIndex);
                        //                     dataController.podcastList.value =
                        //                         dataController
                        //                             .podcastListMasterCopy;
                        //                     Get.to(SinglePodcastView());
                        //                   }
                        //                 },
                        //                 child: Container(
                        //                   decoration: BoxDecoration(
                        //                     borderRadius:
                        //                         BorderRadius.circular(10.0),
                        //                     border: Border.all(
                        //                       color:
                        //                           ThemeProvider.themeOf(context)
                        //                                       .id ==
                        //                                   "light"
                        //                               ? Color(0xffF2F2F2)
                        //                               : darkTxt
                        //                                   .withOpacity(0.2),
                        //                     ),
                        //                   ),
                        //                   margin: EdgeInsets.only(
                        //                       left: index == 0
                        //                           ? Get.width * 0.05
                        //                           : Get.width * 0.03,
                        //                       bottom: Get.height * 0.03),
                        //                   child: Container(
                        //                     width: Get.width * 0.25,
                        //                     child: Column(
                        //                       crossAxisAlignment:
                        //                           CrossAxisAlignment.stretch,
                        //                       children: [
                        //                         Expanded(
                        //                           child: ClipRRect(
                        //                               borderRadius:
                        //                                   BorderRadius.only(
                        //                                       topLeft: Radius
                        //                                           .circular(
                        //                                               10.0),
                        //                                       topRight: Radius
                        //                                           .circular(
                        //                                               10.0)),
                        //                               child:
                        //                                   StyledCachedNetworkImage(
                        //                                 url: dataController
                        //                                     .morefromList[index]
                        //                                     .thumbnail,
                        //                                 height:
                        //                                     Get.height * 0.4,
                        //                               )),
                        //                           flex: 2,
                        //                         ),
                        //                         Expanded(
                        //                           child: AutoSizeText(
                        //                             dataController
                        //                                 .morefromList[index]
                        //                                 .title,
                        //                             style: TextStyle(
                        //                               color: Color(0xffA4A4A4),
                        //                               fontWeight:
                        //                                   FontWeight.w500,
                        //                             ),
                        //                             overflow:
                        //                                 TextOverflow.ellipsis,
                        //                             maxLines: 2,
                        //                             // presetFontSizes: [22, 20],
                        //                             textAlign: TextAlign.center,
                        //                           ),
                        //                           flex: 1,
                        //                         )
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 ),
                        //               );
                        //             }),
                        //       )
                        //     ],
                        //   ),
                        // )
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
                                padding: EdgeInsets.only(
                                    left: Get.width * 0.03, top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GroupButton(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      selectedColor: backGroundColor,
                                      selectedTextStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      unselectedTextStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            ThemeProvider.themeOf(context).id ==
                                                    "light"
                                                ? Colors.black
                                                : Colors.white,
                                      ),
                                      unselectedColor:
                                          ThemeProvider.themeOf(context).id ==
                                                  "light"
                                              ? Colors.white
                                              : Colors.black,
                                      isRadio: true,
                                      spacing: 10,
                                      onSelected: (index, isSelected) {
                                        if (index == 0) {
                                          homeController.selectedIndex.value =
                                              0;
                                        } else {
                                          homeController.selectedIndex.value =
                                              1;
                                        }
                                      },
                                      selectedButton: 0,
                                      buttons: [
                                        "Radio",
                                        "Podcast",
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: Get.height * 0.01,
                              ),
                              homeController.selectedIndex.value == 0
                                  ? Container(
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: dataController
                                            .currentRadioCopy.length,
                                        itemBuilder: (_, index) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 3),
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
                                                      : darkTxt
                                                          .withOpacity(0.2),
                                                ),
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  var radioIndex = dataController
                                                      .radioListMasterCopy
                                                      .indexWhere((w) =>
                                                          w.id ==
                                                          dataController
                                                              .currentRadioCopy[
                                                                  index]
                                                              .id);

                                                  homeController
                                                      .indexToPlayRadio
                                                      .value = radioIndex;
                                                  Get.to(SingleRadioView());
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                              height:
                                                                  Get.height *
                                                                      0.08,
                                                              width: Get.width *
                                                                  0.16,
                                                              child:
                                                                  StyledCachedNetworkImage2(
                                                                url: dataController
                                                                    .currentRadioCopy[
                                                                        index]
                                                                    .thumbnail,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 8,
                                                            left: 5,
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                width:
                                                                    Get.width *
                                                                        0.70,
                                                                child: Text(
                                                                  dataController
                                                                      .currentRadioCopy[
                                                                          index]
                                                                      .title,
                                                                  maxLines: 4,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Aeonik',
                                                                    fontSize:
                                                                        15,
                                                                    color: ThemeProvider.themeOf(context).id ==
                                                                            "light"
                                                                        ? Color(
                                                                            0xffa4a4a4)
                                                                        : darkTxt,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                dataController
                                                                    .currentRadioCopy[
                                                                        index]
                                                                    .slug,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Aeonik',
                                                                  fontSize: 13,
                                                                  color: const Color(
                                                                      0xffa4a4a4),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        shrinkWrap: true,
                                      ),
                                      height: 300,
                                      padding: EdgeInsets.only(
                                          bottom: Get.height * 0.04),
                                    )
                                  : Container(
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: dataController
                                            .currentPodCopy.length,
                                        itemBuilder: (_, index) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 3),
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
                                                      : darkTxt
                                                          .withOpacity(0.2),
                                                ),
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  var podIndex = dataController
                                                      .podcastListMasterCopy
                                                      .indexWhere((w) =>
                                                          w.id ==
                                                          dataController
                                                              .currentPodCopy[
                                                                  index]
                                                              .id);
                                                  homeController.indexToPlayPod
                                                      .value = podIndex;
                                                  print(podIndex);
                                                  Get.to(SinglePodcastView());
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                              height:
                                                                  Get.height *
                                                                      0.08,
                                                              width: Get.width *
                                                                  0.16,
                                                              child:
                                                                  StyledCachedNetworkImage2(
                                                                url: dataController
                                                                    .currentPodCopy[
                                                                        index]
                                                                    .thumbnail,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 8,
                                                                  left: 5),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                width:
                                                                    Get.width *
                                                                        0.70,
                                                                child: Text(
                                                                  dataController
                                                                      .currentPodCopy[
                                                                          index]
                                                                      .title,
                                                                  maxLines: 4,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  softWrap:
                                                                      false,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Aeonik',
                                                                    fontSize:
                                                                        12,
                                                                    color: ThemeProvider.themeOf(context).id ==
                                                                            "light"
                                                                        ? Color(
                                                                            0xffa4a4a4)
                                                                        : darkTxt,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height:
                                                                    Get.height *
                                                                        0.01,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    dataController
                                                                        .currentPodCopy[
                                                                            index]
                                                                        .slug,
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Aeonik',
                                                                      fontSize:
                                                                          13,
                                                                      color: const Color(
                                                                          0xffa4a4a4),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                        Get.width *
                                                                            0.06,
                                                                  ),
                                                                  Container(
                                                                    height: 10,
                                                                    width: 10,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius: BorderRadius.all(Radius.elliptical(
                                                                          9999.0,
                                                                          9999.0)),
                                                                      color: const Color(
                                                                          0xffa4a4a4),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                        Get.width *
                                                                            0.02,
                                                                  ),
                                                                  Text(
                                                                    (dataController.currentPodCopy.length -
                                                                                index)
                                                                            .toString() +
                                                                        "  Episode",
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Aeonik',
                                                                      fontSize:
                                                                          13,
                                                                      color: const Color(
                                                                          0xffa4a4a4),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        shrinkWrap: true,
                                      ),
                                      height: 300,
                                      padding: EdgeInsets.only(
                                          bottom: Get.height * 0.04),
                                    )
                            ],
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
}
