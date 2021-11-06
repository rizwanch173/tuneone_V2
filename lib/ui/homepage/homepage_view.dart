import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'package:adobe_xd/pinned.dart';

class HomePageView extends StatelessWidget {
  final DataController dataController = Get.find();
  final HomeController homeController = Get.find();

  final _debouncer = Debouncer(milliseconds: 500);
  @override
  Widget build(BuildContext context) {
    homeController.updateView();
    return SingleChildScrollView(
        child: GetX<HomeController>(
      builder: (val) => Container(
        color: ThemeProvider.themeOf(context).id == "light"
            ? Colors.white
            : Theme.of(context).primaryColor.withOpacity(0.8),
        child: dataController.isPayed.isFalse
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: ThemeProvider.themeOf(context).id == "light"
                          ? DecorationImage(
                              image: AssetImage("assets/homeAppbarBGLight.png"),
                              fit: BoxFit.cover)
                          : DecorationImage(
                              image: AssetImage("assets/homeAppbarBgDark.png"),
                              fit: BoxFit.cover),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                      child: Column(
                        children: [
                          SizedBox(
                            height: Get.height * 0.07,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      homeController
                                          .greetingMessage()
                                          .toString(),
                                      presetFontSizes: [22, 24],
                                      style: TextStyle(
                                        color: darkTxt,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    AutoSizeText(
                                      dataController.islogin.isTrue
                                          ? "Dear, " +
                                              dataController
                                                  .userList.user.displayName
                                                  .split("@")[0]
                                          : "Dear,",
                                      presetFontSizes: [18, 20],
                                      style: TextStyle(
                                          color: darkTxt,
                                          fontWeight: FontWeight.w800),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextField(
                            onChanged: (val) {
                              _debouncer.run(() {
                                dataController.radioList.value = dataController
                                    .radioListMasterCopy
                                    .where((u) => (u.title
                                        .toLowerCase()
                                        .contains(val.toLowerCase())))
                                    .toList();
                                dataController.podcastList.value =
                                    dataController.podcastListMasterCopy
                                        .where((u) => (u.title
                                            .toLowerCase()
                                            .contains(val.toLowerCase())))
                                        .toList();
                              });
                            },
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          ThemeProvider.themeOf(context).id ==
                                                  "light"
                                              ? Color(0xffF78995)
                                              : darkTxt.withOpacity(0.5))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          ThemeProvider.themeOf(context).id ==
                                                  "light"
                                              ? Color(0xffF78995)
                                              : darkTxt.withOpacity(0.5))),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 8),
                              hintText: "Search",
                              hintStyle: TextStyle(
                                color:
                                    ThemeProvider.themeOf(context).id != "light"
                                        ? darkTxt
                                        : Color(0xffFFBEC5),
                              ),
                              filled: true,
                              fillColor: Theme.of(context).primaryColor,
                              suffixIcon: Container(
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    "assets/feather-search.svg",
                                    color: ThemeProvider.themeOf(context).id ==
                                            "light"
                                        ? Color(0xfffe6232)
                                        : darkBg,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.03,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  Container(
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
                                "Top Stations",
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
                                            dataController.radioList[index].id);

                                    homeController.indexToPlayRadio =
                                        radioIndex;

                                    print(radioIndex);
                                    dataController.radioList.value =
                                        dataController.radioListMasterCopy;
                                    Get.to(SingleRadioView());
                                  },
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
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10.0),
                                                    topRight:
                                                        Radius.circular(10.0)),
                                                child: StyledCachedNetworkImage(
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
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  Container(
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
                                "Top Podcasts",
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
                                    Get.to(() => MediaListView(
                                          title: "Top Podcasts",
                                          fromLibrary: false,
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
                        Container(
                          height: Get.height * 0.22,
                          child: ListView.builder(
                              itemCount: dataController.podcastList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    var podIndex = dataController
                                        .podcastListMasterCopy
                                        .indexWhere((w) =>
                                            w.id ==
                                            dataController
                                                .podcastList[index].id);
                                    homeController.indexToPlayPod = podIndex;

                                    dataController.podcastList.value =
                                        dataController.podcastListMasterCopy;

                                    Get.to(SinglePodcastView());
                                  },
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
                                    margin: EdgeInsets.only(
                                        left: index == 0
                                            ? Get.width * 0.05
                                            : Get.width * 0.03,
                                        bottom: Get.height * 0.03),
                                    width: Get.width * 0.25,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10)),
                                              child: StyledCachedNetworkImage(
                                                url: dataController
                                                    .podcastList[index]
                                                    .thumbnail,
                                                height: Get.height * 0.4,
                                              )),
                                          flex: 2,
                                        ),
                                        Expanded(
                                          child: AutoSizeText(
                                            dataController
                                                .podcastList[index].title,
                                            style: TextStyle(
                                              color: Color(0xffA4A4A4),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                          ),
                                          flex: 1,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  Container(
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
                                "Recently Played",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Aeonik-medium",
                                  color: ThemeProvider.themeOf(context).id ==
                                          "light"
                                      ? darkBg
                                      : darkTxt,
                                ),
                              ),
                              // GestureDetector(
                              //     onTap: () {
                              //       Get.to(() => MediaListView(
                              //             title: "Recently Played",
                              //             fromLibrary: false,
                              //           ));
                              //     },
                              //     child: AutoSizeText(
                              //       "View All",
                              //       presetFontSizes: [20, 18],
                              //       style: TextStyle(
                              //         color:
                              //             ThemeProvider.themeOf(context).id == "light"
                              //                 ? backGroundColor
                              //                 : darkTxt,
                              //       ),
                              //     )),
                            ],
                          ),
                        ),
                        Container(
                          height: Get.height * 0.22,
                          child: ListView.builder(
                              // reverse: true,
                              itemCount: dataController.recentlyList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    print(dataController
                                        .recentlyList[index].duration);
                                    if (dataController
                                            .recentlyList[index].duration ==
                                        0) {
                                      var radioIndex = dataController
                                          .radioListMasterCopy
                                          .indexWhere((w) =>
                                              w.id ==
                                              dataController
                                                  .recentlyList[index].id);

                                      homeController.indexToPlayRadio =
                                          radioIndex;
                                      Get.to(SingleRadioView());
                                      print(radioIndex);
                                    } else {
                                      var podIndex = dataController
                                          .podcastListMasterCopy
                                          .indexWhere((w) =>
                                              w.id ==
                                              dataController
                                                  .recentlyList[index].id);
                                      homeController.indexToPlayPod = podIndex;
                                      print(podIndex);
                                      Get.to(SinglePodcastView());
                                    }
                                  },
                                  child: Container(
                                    width: Get.width * 0.25,
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
                                    margin: EdgeInsets.only(
                                        left: index == 0
                                            ? Get.width * 0.05
                                            : Get.width * 0.03,
                                        bottom: Get.height * 0.03),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10)),
                                              child: StyledCachedNetworkImage(
                                                url: dataController
                                                    .recentlyList[index]
                                                    .thumbnail,
                                                height: Get.height * 0.4,
                                              )),
                                          flex: 2,
                                        ),
                                        Expanded(
                                          child: AutoSizeText(
                                            dataController
                                                .recentlyList[index].title,
                                            style: TextStyle(
                                              color: Color(0xffA4A4A4),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                          ),
                                          flex: 1,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: kBottomNavigationBarHeight / 2,
                  )
                ],
              ),
      ),
    ));
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
