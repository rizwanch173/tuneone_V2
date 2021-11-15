import 'dart:io';
import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      backgroundColor:
          ThemeProvider.themeOf(context).id == "light" ? darkTxt : darkBg,
      body: Obx(
        () => CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: Get.height * 0.50,
              // automaticallyImplyLeading: false,
              leading: GestureDetector(
                child: Padding(
                  padding: EdgeInsets.only(left: Get.height * 0.02),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                onTap: () {
                  Get.back();
                },
              ),
              actions: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: Get.height * 0.03),
                      child: Container(
                        height: Get.height * 0.04,
                        width: Get.height * 0.04,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          border: Border.all(
                            width: 1,
                            color: darkTxt,
                          ),
                        ),
                        child: GestureDetector(
                          child: Icon(
                            Icons.ios_share,
                            color: darkTxt,
                          ),
                          onTap: () async {
                            Share.share(
                                ' ${dataController.radioList[currentIndex].author.link}');
                          },
                        ),
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
              ],
              floating: false,
              pinned: true,
              backgroundColor: ThemeProvider.themeOf(context).id == "light"
                  ? backGroundColor
                  : darkBg,
              collapsedHeight: 56.0,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Container(
                  decoration: BoxDecoration(
                    image: ThemeProvider.themeOf(context).id == "light"
                        ? DecorationImage(
                            image: AssetImage("assets/details_light.png"),
                            fit: BoxFit.cover)
                        : DecorationImage(
                            image: AssetImage("assets/details_dark.png"),
                            fit: BoxFit.cover),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: Get.height * 0.11,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.20,
                        ),
                        child: Container(
                          height: Get.height * 0.2,
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
                              width: 2,
                              color:
                                  ThemeProvider.themeOf(context).id == "light"
                                      ? Color(0xffFF6879)
                                      : darkTxt,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          dataController
                              .radioList[currentIndex].author.displayName,
                          style: TextStyle(
                              color: darkTxt,
                              fontSize: 18,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          dataController
                              .radioList[currentIndex].author.description,
                          style: TextStyle(
                            fontFamily: 'Aeonik',
                            fontSize: 13,
                            color: darkTxt,
                            fontWeight: FontWeight.w300,
                          ),
                          maxLines: 5,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.025,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                                      backgroundColor: Colors.white,
                                      titleColor: darkBg,
                                      borderRadius: BorderRadius.circular(25),
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

                                                RemoteServices.followOrUnfollow(
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
                                              backgroundColor: backGroundColor,
                                              titleColor: darkBg,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              fontSize: 14,
                                            ),
                                          )
                                        : Container(
                                            width: Get.width * 0.20,
                                            child: StyledButton(
                                              onPressed: () {
                                                dataController.followList.add(
                                                    int.parse(dataController
                                                        .radioList[currentIndex]
                                                        .author
                                                        .authorId));

                                                RemoteServices.followOrUnfollow(
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
                                              backgroundColor: backGroundColor,
                                              titleColor: darkBg,
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              fontSize: 14,
                                            ),
                                          ),
                                  ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      Row(
                        children: [
                          Text(
                            'Total played:  ',
                            style: TextStyle(
                              fontFamily: 'Aeonik',
                              fontSize: 15,
                              color: darkTxt,
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
                              color: darkTxt,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(homeController),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 5,
              ),
            ),
            homeController.selectedIndex.value == 0
                ? new SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, index) => GestureDetector(
                              onTap: () {
                                var radioIndex = dataController
                                    .radioListMasterCopy
                                    .indexWhere((w) =>
                                        w.id ==
                                        dataController
                                            .currentRadioCopy[index].id);

                                homeController.indexToPlayRadio.value =
                                    radioIndex;
                                Get.to(SingleRadioView());
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color:
                                          ThemeProvider.themeOf(context).id ==
                                                  "light"
                                              ? Colors.black26.withOpacity(0.1)
                                              : darkTxt.withOpacity(0.5),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                height: Get.height * 0.08,
                                                width: Get.width * 0.16,
                                                child:
                                                    StyledCachedNetworkImage2(
                                                  url: dataController
                                                      .currentRadioCopy[index]
                                                      .thumbnail,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8,
                                              left: 5,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: Get.width * 0.70,
                                                  child: Text(
                                                    dataController
                                                        .currentRadioCopy[index]
                                                        .title,
                                                    maxLines: 4,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'Aeonik',
                                                      fontSize: 15,
                                                      color: ThemeProvider
                                                                      .themeOf(
                                                                          context)
                                                                  .id ==
                                                              "light"
                                                          ? Color(0xffa4a4a4)
                                                          : darkTxt,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  dataController
                                                      .currentRadioCopy[index]
                                                      .slug,
                                                  style: TextStyle(
                                                    fontFamily: 'Aeonik',
                                                    fontSize: 13,
                                                    color:
                                                        const Color(0xffa4a4a4),
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                  textAlign: TextAlign.left,
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
                            ),
                        childCount: dataController.currentRadioCopy.length),
                  )
                : new SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, index) => GestureDetector(
                              onTap: () {
                                var podIndex = dataController
                                    .podcastListMasterCopy
                                    .indexWhere((w) =>
                                        w.id ==
                                        dataController
                                            .currentPodCopy[index].id);
                                homeController.indexToPlayPod.value = podIndex;
                                print(podIndex);
                                Get.to(SinglePodcastView());
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color:
                                          ThemeProvider.themeOf(context).id ==
                                                  "light"
                                              ? Colors.black26.withOpacity(0.1)
                                              : darkTxt.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                height: Get.height * 0.08,
                                                width: Get.width * 0.16,
                                                child:
                                                    StyledCachedNetworkImage2(
                                                  url: dataController
                                                      .currentPodCopy[index]
                                                      .thumbnail,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8, left: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: Get.width * 0.70,
                                                  child: Text(
                                                    dataController
                                                        .currentPodCopy[index]
                                                        .title,
                                                    maxLines: 4,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: false,
                                                    style: TextStyle(
                                                      fontFamily: 'Aeonik',
                                                      fontSize: 12,
                                                      color: ThemeProvider
                                                                      .themeOf(
                                                                          context)
                                                                  .id ==
                                                              "light"
                                                          ? Color(0xffa4a4a4)
                                                          : darkTxt,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Get.height * 0.01,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      dataController
                                                          .currentPodCopy[index]
                                                          .slug,
                                                      style: TextStyle(
                                                        fontFamily: 'Aeonik',
                                                        fontSize: 13,
                                                        color: const Color(
                                                            0xffa4a4a4),
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    SizedBox(
                                                      width: Get.width * 0.06,
                                                    ),
                                                    Container(
                                                      height: 10,
                                                      width: 10,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius
                                                                    .elliptical(
                                                                        9999.0,
                                                                        9999.0)),
                                                        color: const Color(
                                                            0xffa4a4a4),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: Get.width * 0.02,
                                                    ),
                                                    Text(
                                                      (dataController.currentPodCopy
                                                                      .length -
                                                                  index)
                                                              .toString() +
                                                          "  Episode",
                                                      style: TextStyle(
                                                        fontFamily: 'Aeonik',
                                                        fontSize: 13,
                                                        color: const Color(
                                                            0xffa4a4a4),
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                      textAlign: TextAlign.left,
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
                            ),
                        childCount: dataController.currentPodCopy.length),
                  ),
            SliverToBoxAdapter(
              child: homeController.whoAccess.value != "none"
                  ? MiniPlayer()
                  : SizedBox(
                      height: 5,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this.homeController);

  double scrollAnimationValue(double shrinkOffset) {
    double maxScrollAllowed = maxExtent - minExtent;
    return ((maxScrollAllowed - shrinkOffset) / maxScrollAllowed)
        .clamp(0, 1)
        .toDouble();
  }

  final homeController;
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double visibleMainHeight = max(maxExtent - shrinkOffset, minExtent);
    final double animationVal = scrollAnimationValue(shrinkOffset);
    return Container(
      height: visibleMainHeight,
      width: MediaQuery.of(context).size.width,
      child: Container(
        color: ThemeProvider.themeOf(context).id != "light" ? darkBg : darkTxt,
        child: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GroupButton(
                buttonHeight: Get.height * 0.040,
                buttonWidth: Get.height * 0.080,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                selectedColor: backGroundColor,
                selectedTextStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                unselectedTextStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: ThemeProvider.themeOf(context).id == "light"
                      ? Colors.black
                      : Colors.white,
                ),
                elevation: 5.0,
                unselectedColor: ThemeProvider.themeOf(context).id == "light"
                    ? Colors.white
                    : Colors.black,
                isRadio: true,
                spacing: 10,
                onSelected: (index, isSelected) {
                  if (index == 0) {
                    homeController.selectedIndex.value = 0;
                  } else {
                    homeController.selectedIndex.value = 1;
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
      ),
    );
  }

  @override
  double get maxExtent => 70.0;

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
