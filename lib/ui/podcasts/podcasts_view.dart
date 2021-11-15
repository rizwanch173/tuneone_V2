import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tuneone/controllers/data_controller.dart';
import 'package:tuneone/controllers/home_controllers.dart';
import 'package:tuneone/ui/medialist/genre_medialist_pod.dart';
import 'package:tuneone/ui/medialist/medialist_view.dart';
import 'package:tuneone/ui/shared/styles.dart';
import 'package:tuneone/ui/singlechannel/single_podcast_view.dart';
import 'package:tuneone/ui/styled_widgets/cached_network_image.dart';
import 'package:tuneone/ui/styled_widgets/masking.dart';

class PodCastsView extends StatelessWidget {
  final DataController dataController = Get.find();
  final HomeController homeController = Get.find();
  final _debouncer = Debouncer(milliseconds: 500);
  static var selectedPod = true.obs;
  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentScope = FocusScope.of(context);

    homeController.updateView();
    return Container(
      height: Get.height,
      color: ThemeProvider.themeOf(context).id == "light"
          ? Colors.white
          : Theme.of(context).primaryColor.withOpacity(0.8),
      child: Obx(
        () => SingleChildScrollView(
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
                            Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: selectedPod.isFalse
                                    ? Container(
                                        width: 30,
                                        height: 20,
                                        child: IconButton(
                                          icon: Icon(Icons.arrow_back_ios),
                                          color: Colors.white,
                                          onPressed: () async {
                                            selectedPod.value =
                                                !selectedPod.value;
                                            dataController.genrelistPod.value =
                                                dataController
                                                    .genrelistpodMaster;
                                            dataController.podcastList.value =
                                                dataController
                                                    .podcastListMasterCopy;
                                          },
                                        ),
                                      )
                                    : SizedBox(
                                        width: 30,
                                        height: 20,
                                      ),
                              ),
                            ),
                            selectedPod.isTrue
                                ? AutoSizeText(
                                    homeController.podAppbar.value,
                                    style: TextStyle(
                                        color: darkTxt,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800),
                                  )
                                : AutoSizeText(
                                    "Genre",
                                    style: TextStyle(
                                        color: darkTxt,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800),
                                  ),
                            InkWell(
                              onTap: () {
                                selectedPod.value = !selectedPod.value;
                                dataController.genrelistPod.value =
                                    dataController.genrelistpodMaster;
                                dataController.podcastList.value =
                                    dataController.podcastListMasterCopy;
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 4),
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/ramdom.svg",
                                      fit: BoxFit.cover,
                                      height: 30,
                                      color: Colors.white,
                                    ),
                                    AutoSizeText(
                                      "Genre",
                                      style: TextStyle(
                                          color: darkTxt,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                selectedPod.isTrue
                    ? podView(context, currentScope)
                    : genreViewInPod(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget podView(context, currentScope) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            height: Get.height * 0.060,
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
            child: TextField(
              onChanged: (val) {
                _debouncer.run(() {
                  dataController.podcastList.value = dataController
                      .podcastListMasterCopy
                      .where((u) =>
                          (u.title.toLowerCase().contains(val.toLowerCase())))
                      .toList();
                });
                print("ser");
                print(dataController.radioList.length);
              },
              style: TextStyle(
                color: ThemeProvider.themeOf(context).id == "light"
                    ? darkBg
                    : darkTxt,
              ),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: ThemeProvider.themeOf(context).id == "light"
                            ? Colors.white
                            : Colors.transparent)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: ThemeProvider.themeOf(context).id == "light"
                            ? Colors.white
                            : Colors.transparent)),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                hintText: "Search",
                hintStyle: TextStyle(
                  color: ThemeProvider.themeOf(context).id != "light"
                      ? darkTxt
                      : Color(0xffA4A4A4),
                ),
                filled: true,
                fillColor: ThemeProvider.themeOf(context).id == "light"
                    ? Colors.white
                    : darkBg,
                suffixIcon: Container(
                  margin: EdgeInsets.all(7),
//                          padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: ThemeProvider.themeOf(context).id == "light"
                          ? backGroundColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(6)),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SvgPicture.asset(
                      "assets/feather-search.svg",
                      color: ThemeProvider.themeOf(context).id == "light"
                          ? Colors.white
                          : darkBg,
                    ),
                  ),
                ),
              ),
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
                padding: EdgeInsets.only(
                  left: Get.width * 0.05,
                  right: Get.width * 0.05,
                  top: Get.height * 0.02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText(
                      "Podcast",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: "Aeonik-medium",
                        color: ThemeProvider.themeOf(context).id == "light"
                            ? darkBg
                            : darkTxt,
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Get.to(() => MediaListView(
                                title: "Top Stations",
                                fromLibrary: false,
                              ));
                        },
                        child: AutoSizeText(
                          "View All",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: "Aeonik-medium",
                            color: ThemeProvider.themeOf(context).id == "light"
                                ? backGroundColor
                                : darkTxt,
                          ),
                        )),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Get.width * 0.04,
                      ),
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 105 / 140,
                          crossAxisCount: 3,
                        ),
                        itemCount: dataController.podcastList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              if (!currentScope.hasPrimaryFocus &&
                                  currentScope.hasFocus) {
                                FocusManager.instance.primaryFocus!.unfocus();
                              }

                              var podIndex = dataController
                                  .podcastListMasterCopy
                                  .indexWhere((w) =>
                                      w.id ==
                                      dataController.podcastList[index].id);
                              homeController.indexToPlayPod.value = podIndex;

                              dataController.podcastList.value =
                                  dataController.podcastListMasterCopy;
                              Get.to(SinglePodcastView());
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 8, left: 2, right: 2),
                              child: Container(
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
                                  height: Get.height * 0.24,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10)),
                                            child: StyledCachedNetworkImage(
                                              url: dataController
                                                  .podcastList[index].thumbnail,
                                              height: Get.height * 0.4,
                                            )),
                                        flex: 2,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: AutoSizeText(
                                          dataController
                                              .podcastList[index].title,
                                          // overflow: TextOverflow
                                          //     .ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                            color: Color(0xffA4A4A4),
                                            fontWeight: FontWeight.w500,
                                          ),

                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget genreViewInPod(context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom:
            homeController.whoAccess.value == "none" ? 0 : Get.height * 0.080,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                height: Get.height * 0.060,
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
                child: TextField(
                  onChanged: (val) {
                    _debouncer.run(() {
                      dataController.genrelistPod.value = dataController
                          .genrelistpodMaster
                          .where((u) => (u.name
                              .toLowerCase()
                              .contains(val.toLowerCase())))
                          .toList();
                    });
                  },
                  style: TextStyle(
                    color: ThemeProvider.themeOf(context).id == "light"
                        ? darkBg
                        : darkTxt,
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ThemeProvider.themeOf(context).id == "light"
                                ? Colors.white
                                : Colors.transparent)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ThemeProvider.themeOf(context).id == "light"
                                ? Colors.white
                                : Colors.transparent)),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    hintText: "Search",
                    hintStyle: TextStyle(
                      color: ThemeProvider.themeOf(context).id != "light"
                          ? darkTxt
                          : Color(0xffA4A4A4),
                    ),
                    filled: true,
                    fillColor: ThemeProvider.themeOf(context).id == "light"
                        ? Colors.white
                        : darkBg,
                    suffixIcon: Container(
                      margin: EdgeInsets.all(7),
//                          padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: ThemeProvider.themeOf(context).id == "light"
                              ? backGroundColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(6)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SvgPicture.asset(
                          "assets/feather-search.svg",
                          color: ThemeProvider.themeOf(context).id == "light"
                              ? Colors.white
                              : darkBg,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 105 / 65,
                  crossAxisSpacing: 15,
                  crossAxisCount: 2,
                ),
                itemCount: dataController.genrelistPod.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.to(GenreMediaListPodView(
                        title: dataController.genrelistPod[index].name
                            .replaceAll("&amp;", ","),
                        genreId: dataController.genrelistPod[index].id,
                      ));
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 100,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: LinearGradient(
                              colors: [
                                gradient[index]['grad']![0],
                                gradient[index]['grad']![1],
                              ],
                              begin: Alignment(0.0, -1.0),
                              end: Alignment(0.0, 0.0),
                              //  stops: [0.0, 0.0],
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            Container(
                              height: 100,
                              width: 200,
                              child: BlendMask(
                                opacity: 1.0,
                                blendMode: BlendMode.overlay,
                                child: SizedBox.expand(
                                  child: Image.asset(
                                    'assets/background-7.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    "assets/podgen.svg",
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: AutoSizeText(
                                      dataController.genrelistPod[index].name
                                          .replaceAll("&amp;", ","),
                                      style: TextStyle(
                                        fontFamily: 'Aeonik',
                                        fontSize: 16,
                                        color: const Color(0xffffffff),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                })
          ],
        ),
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
