import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tuneone/controllers/data_controller.dart';
import 'package:tuneone/controllers/home_controllers.dart';
import 'package:tuneone/ui/medialist/medialist_radio.dart';
import 'package:tuneone/ui/medialist/medialist_view.dart';
import 'package:tuneone/ui/shared/styles.dart';
import 'package:tuneone/ui/singlechannel/single_podcast_view.dart';
import 'package:tuneone/ui/singlechannel/single_radio_view.dart';
import 'package:tuneone/ui/styled_widgets/cached_network_image.dart';
import 'package:tuneone/ui/styled_widgets/styled_button.dart';

class LibraryView extends StatelessWidget {
  final DataController dataController = Get.find();
  final HomeController homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    // dataController.radioListMasterCopy.forEach((element) {
    //   if (dataController.userList.userMeta.followings.contains(element.id)) {
    //     print("yes");
    //   }
    // });
    // print(dataController.userList.userMeta.likes.length);

    return Obx(
      () => Container(
        color: ThemeProvider.themeOf(context).id == "light"
            ? Colors.white
            : Theme.of(context).primaryColor.withOpacity(0.8),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(bottom: Get.height * 0.02),
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
                      Align(
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          "Library",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.03,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
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
                            "Favorite Radio",
                            style: TextStyle(
                              color:
                                  ThemeProvider.themeOf(context).id == "light"
                                      ? darkBg
                                      : darkTxt,
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                if (dataController.islogin.isTrue)
                                  Get.to(() => MediaListRadioView(
                                        title: "Favorite Stations",
                                        fromLibrary: true,
                                      ));
                              },
                              child: AutoSizeText(
                                "View All",
                                style: TextStyle(
                                  color: ThemeProvider.themeOf(context).id ==
                                          "light"
                                      ? backGroundColor
                                      : darkTxt,
                                ),
                              )),
                        ],
                      ),
                    ),
                    dataController.islogin.isFalse
                        ? Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              AutoSizeText(
                                "Please login to proceed",
                                presetFontSizes: [14, 16],
                                style: TextStyle(
                                  color: ThemeProvider.themeOf(context).id ==
                                          "light"
                                      ? darkBg
                                      : darkTxt,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Get.width * 00.3,
                                  vertical: Get.width * 0.04,
                                ),
                                child: StyledButton(
                                  onPressed: () {
                                    Get.toNamed("/authoption");
                                  },
                                  title: "Login",
                                  backgroundColor:
                                      ThemeProvider.themeOf(context).id ==
                                              "light"
                                          ? backGroundColor
                                          : Colors.black26,
                                  titleColor: darkTxt,
                                  borderRadius: BorderRadius.circular(5),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )
                        : Obx(
                            () => Container(
                              height: Get.height * 0.22,
                              child: ListView.builder(
                                  itemCount:
                                      dataController.radioListMasterCopy.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, indexR) {
                                    if (dataController.likeList.contains(
                                        dataController
                                            .radioListMasterCopy[indexR].id)) {
                                      return GestureDetector(
                                        onTap: () {
                                          homeController
                                              .indexToPlayRadio.value = indexR;
                                          Get.to(SingleRadioView());
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            border: Border.all(
                                              color:
                                                  ThemeProvider.themeOf(context)
                                                              .id ==
                                                          "light"
                                                      ? Color(0xffF2F2F2)
                                                      : darkTxt
                                                          .withOpacity(0.2),
                                            ),
                                          ),
                                          margin: EdgeInsets.only(
                                              left: indexR == 0
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
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(
                                                                      10)),
                                                      child:
                                                          StyledCachedNetworkImage(
                                                        url: dataController
                                                            .radioListMasterCopy[
                                                                indexR]
                                                            .thumbnail,
                                                        height:
                                                            Get.height * 0.4,
                                                      )),
                                                  flex: 2,
                                                ),
                                                Expanded(
                                                  child: AutoSizeText(
                                                    dataController
                                                        .radioListMasterCopy[
                                                            indexR]
                                                        .title,
                                                    style: TextStyle(
                                                      color: Color(0xffA4A4A4),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  flex: 1,
                                                )
                                              ],
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
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: Get.height * 0.025),
                child: Container(
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
                              "Favorite Podcasts",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: "Aeonik-medium",
                                color:
                                    ThemeProvider.themeOf(context).id == "light"
                                        ? darkBg
                                        : darkTxt,
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  if (dataController.islogin.isTrue)
                                    Get.to(() => MediaListView(
                                          title: "Top Podcasts",
                                          fromLibrary: true,
                                        ));
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
                                              : darkTxt),
                                )),
                          ],
                        ),
                      ),
                      dataController.islogin.isFalse
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                AutoSizeText(
                                  "Please login to proceed",
                                  presetFontSizes: [14, 16],
                                  style: TextStyle(
                                    color: ThemeProvider.themeOf(context).id ==
                                            "light"
                                        ? darkBg
                                        : darkTxt,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Get.width * 00.3,
                                    vertical: Get.width * 0.04,
                                  ),
                                  child: StyledButton(
                                    onPressed: () {
                                      Get.toNamed("/authoption");
                                    },
                                    title: "Login",
                                    backgroundColor:
                                        ThemeProvider.themeOf(context).id ==
                                                "light"
                                            ? backGroundColor
                                            : Colors.black26,
                                    titleColor: darkTxt,
                                    borderRadius: BorderRadius.circular(5),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              height: Get.height * 0.22,
                              child: ListView.builder(
                                  itemCount: dataController
                                      .podcastListMasterCopy.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    if (dataController.userList.userMeta.likes
                                        .contains(dataController
                                            .podcastListMasterCopy[index].id)) {
                                      return GestureDetector(
                                        onTap: () {
                                          homeController.indexToPlayPod.value =
                                              index;
                                          Get.to(SinglePodcastView());
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            border: Border.all(
                                              color:
                                                  ThemeProvider.themeOf(context)
                                                              .id ==
                                                          "light"
                                                      ? Color(0xffF2F2F2)
                                                      : darkTxt
                                                          .withOpacity(0.2),
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
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(
                                                                      10)),
                                                      child:
                                                          StyledCachedNetworkImage(
                                                        url: dataController
                                                            .podcastListMasterCopy[
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
                                                        .podcastListMasterCopy[
                                                            index]
                                                        .title,
                                                    style: TextStyle(
                                                      color: Color(0xffA4A4A4),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  flex: 1,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return (SizedBox());
                                    }
                                  }),
                            )
                    ],
                  ),
                ),
              ),
            ),
            // SliverToBoxAdapter(
            //     child: Padding(
            //   padding: EdgeInsets.symmetric(
            //       horizontal: Get.width * 0.05, vertical: Get.height * 0.02),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       AutoSizeText(
            //         "Download Podcasts",
            //         presetFontSizes: [20, 18],
            //       ),
            //     ],
            //   ),
            // )),
            // SliverList(
            //     delegate: SliverChildBuilderDelegate((context, index) {
            //   return ListTile(
            //     leading: Padding(
            //       padding: const EdgeInsets.all(2.0),
            //       child: ClipRRect(
            //           borderRadius: BorderRadius.circular(5),
            //           child: Image.asset(
            //             "assets/image_$index.png",
            //             fit: BoxFit.cover,
            //           )),
            //     ),
            //     title: AutoSizeText("American Fiesco"),
            //     subtitle: AutoSizeText('Entertainment . 39 Episode'),
            //   );
            // }, childCount: 5))
          ],
        ),
      ),
    );
  }
}
