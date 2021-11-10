import 'dart:convert';
import 'dart:ui';

import 'package:adobe_xd/adobe_xd.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tuneone/controllers/data_controller.dart';
import 'package:tuneone/controllers/follow_controller.dart';
import 'package:tuneone/ui/shared/styles.dart';
import 'package:tuneone/ui/styled_widgets/styled_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FollowingView extends StatelessWidget {
  final DataController dataController = Get.find();
  final FollowController followController = Get.put(FollowController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: ThemeProvider.themeOf(context).id == "light"
            ? darkTxt
            : Theme.of(context).primaryColor.withOpacity(0.8),
        child: Column(
          children: [
            Container(
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
                        "Follow",
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
            Card(
              color: ThemeProvider.themeOf(context).id == "light"
                  ? darkTxt
                  : darkBg,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              elevation: 2,
              margin: EdgeInsets.only(bottom: Get.height * 0.02),
              child: Column(
                children: [
                  // Padding(
                  //   padding: EdgeInsets.symmetric(
                  //       horizontal: Get.width * 0.05,
                  //       vertical: Get.height * 0.02),
                  //   // child: Row(
                  //   //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   //   children: [
                  //   //     AutoSizeText(
                  //   //       "Podcast you Following",
                  //   //       presetFontSizes: [20, 18],
                  //   //       style: TextStyle(
                  //   //         color: ThemeProvider.themeOf(context).id == "light"
                  //   //             ? darkBg
                  //   //             : darkTxt,
                  //   //       ),
                  //   //     ),
                  //   //     AutoSizeText(
                  //   //       "View All",
                  //   //       presetFontSizes: [20, 18],
                  //   //       style: TextStyle(
                  //   //         color: ThemeProvider.themeOf(context).id == "light"
                  //   //             ? backGroundColor
                  //   //             : darkTxt,
                  //   //       ),
                  //   //     ),
                  //   //   ],
                  //   // ),
                  // ),
                  dataController.islogin.isTrue
                      ?
                      // ? Padding(
                      //     padding: EdgeInsets.symmetric(
                      //         horizontal: Get.width * 0.05,
                      //         vertical: Get.height * 0.01),
                      //     child: Column(
                      //       children: [
                      //         Row(
                      //           children: [
                      //             ClipRRect(
                      //                 borderRadius: BorderRadius.circular(5),
                      //                 child: Image.asset(
                      //                   "assets/image_4.png",
                      //                   width: Get.width * 0.2,
                      //                 )),
                      //             SizedBox(
                      //               width: 10,
                      //             ),
                      //             Expanded(
                      //               child: Column(
                      //                 crossAxisAlignment:
                      //                     CrossAxisAlignment.start,
                      //                 children: [
                      //                   AutoSizeText(
                      //                     "Black Men Can’t Jump in Hollywood",
                      //                     presetFontSizes: [20, 18],
                      //                   ),
                      //                   SizedBox(
                      //                     height: 5,
                      //                   ),
                      //                   AutoSizeText(
                      //                     "John Doe",
                      //                     style:
                      //                         TextStyle(color: backGroundColor),
                      //                   )
                      //                 ],
                      //               ),
                      //             )
                      //           ],
                      //         ),
                      //         SizedBox(
                      //           height: 5,
                      //         ),
                      //         Row(
                      //           children: [
                      //             Expanded(
                      //                 flex: 2,
                      //                 child: AutoSizeText(
                      //                   "Entertainment \u0387 39 Episodes",
                      //                   style: TextStyle(color: Colors.grey),
                      //                 )),
                      //             Expanded(
                      //               child: Transform.translate(
                      //                 offset: Offset(0, -10),
                      //                 child: Container(
                      //                   padding: EdgeInsets.symmetric(
                      //                       vertical: Get.height * 0.01),
                      //                   decoration: BoxDecoration(
                      //                       borderRadius:
                      //                           BorderRadius.circular(5),
                      //                       border: Border.all(
                      //                           color: Colors.grey[400]!)),
                      //                   child: Center(
                      //                     child: AutoSizeText(
                      //                       "Following",
                      //                       style: TextStyle(
                      //                           color: Colors.grey[400]),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ),
                      //             )
                      //           ],
                      //         )
                      //       ],
                      //     ),
                      //   )
                      SizedBox()
                      : Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            // Adobe XD layer: 'background-01' (shape)
                            Stack(
                              children: [
                                Container(
                                  height: 100,
                                  child: Image.asset("assets/background-7.png"),
                                ),
                                Container(
                                  height: 100,
                                  child: Image.asset("assets/wk-4.png",
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 0.6),
                                      colorBlendMode: BlendMode.modulate),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            // Container(
                            //   height: 100,
                            //   child: MaskedImage(
                            //       asset: 'assets/background-7.png',
                            //       mask: 'assets/wk-4.png'),
                            // ),
                            AutoSizeText(
                              "Please login to proceed",
                              presetFontSizes: [14, 16],
                              style: TextStyle(
                                color:
                                    ThemeProvider.themeOf(context).id == "light"
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
                                    ThemeProvider.themeOf(context).id == "light"
                                        ? backGroundColor
                                        : Colors.black26,
                                titleColor: darkTxt,
                                borderRadius: BorderRadius.circular(5),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )
                ],
              ),
            ),
            ListTile(
              dense: true,
              leading: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: AutoSizeText(
                  "Display Mode",
                  style: TextStyle(
                    color: ThemeProvider.themeOf(context).id == "light"
                        ? darkBg
                        : darkTxt,
                  ),
                ),
              ),
              trailing: Container(
                width: Get.width * 0.25,
//              padding: EdgeInsets.symmetric(vertical: Get.height*0.007),

                child: Center(
                  child: Container(
                    height: Get.height * 0.07,
                    width: Get.width * 0.25,
                    child: DayNightSwitcher(
                      dayBackgroundColor: backGroundColor.withOpacity(0.5),
                      isDarkModeEnabled:
                          ThemeProvider.themeOf(context).id == "dark",
                      onStateChanged: (isDarkModeEnabled) {
                        if (isDarkModeEnabled)
                          ThemeProvider.controllerOf(context).setTheme("dark");
                        else
                          ThemeProvider.controllerOf(context).setTheme("light");
                      },
                    ),
                  ),
                ),
              ),
            ),
            dataController.islogin.isTrue
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 00.35,
                      vertical: Get.width * 0.040,
                    ),
                    child: StyledButton(
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.remove("islogin");
                        dataController.islogin(false);
                      },
                      title: "Log out",
                      backgroundColor:
                          ThemeProvider.themeOf(context).id == "light"
                              ? backGroundColor
                              : Colors.black26,
                      titleColor: darkTxt,
                      borderRadius: BorderRadius.circular(5),
                      fontSize: 16,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

class MaskedImage extends StatelessWidget {
  final String asset;
  final String mask;

  MaskedImage({required this.asset, required this.mask});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return FutureBuilder<List>(
        future: _createShaderAndImage(
            asset, mask, constraints.maxWidth, constraints.maxHeight),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          return ShaderMask(
            blendMode: BlendMode.dstATop,
            shaderCallback: (rect) => snapshot.data![0],
            child: snapshot.data![1],
          );
        },
      );
    });
  }

  Future<List> _createShaderAndImage(
      String asset, String mask, double w, double h) async {
    ByteData data = await rootBundle.load(asset);
    ByteData maskData = await rootBundle.load(mask);

    var codec = await instantiateImageCodec(maskData.buffer.asUint8List(),
        targetWidth: w.toInt(), targetHeight: h.toInt());
    FrameInfo fi = await codec.getNextFrame();

    ImageShader shader = ImageShader(
        fi.image, TileMode.clamp, TileMode.clamp, Matrix4.identity().storage);
    Image image = Image.memory(data.buffer.asUint8List(),
        fit: BoxFit.cover, width: w, height: h);
    return [shader, image];
  }
}
