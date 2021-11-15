import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tuneone/controllers/data_controller.dart';
import 'package:tuneone/controllers/follow_controller.dart';
import 'package:tuneone/controllers/home_controllers.dart';
import 'package:tuneone/ui/shared/styles.dart';
import 'package:tuneone/ui/styled_widgets/cached_network_image.dart';

import 'package:tuneone/ui/styled_widgets/styled_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class FollowingView extends StatelessWidget {
  final DataController dataController = Get.find();
  final FollowController followController = Get.put(FollowController());
  final HomeController homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: ThemeProvider.themeOf(context).id == "light"
            ? darkTxt
            : Theme.of(context).primaryColor.withOpacity(0.8),
        child: SingleChildScrollView(
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
                child: Container(
                  height: Get.height * 0.13,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: Get.width * 0.05,
                      right: Get.width * 0.05,
                      top: Get.height * 0.03,
                    ),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),
                          AutoSizeText(
                            "Settings",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800),
                          ),
                          dataController.islogin.isTrue
                              ? GestureDetector(
                                  onTap: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.remove("islogin");
                                    dataController.islogin(false);
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          "assets/logout-svgrepo-com.svg",
                                          height: 26,
                                          color: Colors.white),
                                      AutoSizeText(
                                        "Log out",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  dataController.islogin.isTrue
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: Get.height * 0.22,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: AspectRatio(
                                  aspectRatio: 1 / 1,
                                  child: StyledCachedNetworkImage2(
                                      url: dataController
                                          .userList.userMeta.avtar),
                                ),
                              ),
                            ),
                            SizedBox(height: Get.height * 0.02),
                            AutoSizeText(
                              " ${dataController.userList.userMeta.firstName} " +
                                  " " +
                                  "${dataController.userList.userMeta.lastName}",
                              style: TextStyle(
                                color:
                                    ThemeProvider.themeOf(context).id == "light"
                                        ? darkBg
                                        : darkTxt,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: Get.height * 0.01),
                            AutoSizeText(
                              dataController.userList.user.userEmail,
                              style: TextStyle(
                                color:
                                    ThemeProvider.themeOf(context).id == "light"
                                        ? Color(0xffa4a4a4)
                                        : darkTxt,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            // Adobe XD layer: 'background-01' (shape)

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
              SizedBox(height: Get.height * 0.03),
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
                    ListTile(
                      dense: true,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: AutoSizeText(
                          "Setting",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ThemeProvider.themeOf(context).id == "light"
                                ? darkBg
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      dense: true,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: AutoSizeText(
                          "Dark Mode",
                          style: TextStyle(
                            color: ThemeProvider.themeOf(context).id == "light"
                                ? Color(0xffA4A4A4)
                                : darkTxt,
                          ),
                        ),
                      ),
                      trailing: Container(
                        width: Get.width * 0.25,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: ThemeProvider.themeOf(context).id == "dark"
                                  ? Color(0x48000000)
                                  : Color(0xfffffff),
                              offset: Offset(0, 5),
                              blurRadius: 50,
                            ),
                          ],
                        ),
                        child: Center(
                            child: Theme(
                          data: ThemeData(),
                          child: ShaderMask(
                            child: Container(
                              child: CupertinoSwitch(
                                activeColor: Color(0xfffe6232),
                                value:
                                    ThemeProvider.themeOf(context).id == "dark",
                                onChanged: (v) {
                                  if (ThemeProvider.themeOf(context).id ==
                                      "dark") {
                                    ThemeProvider.controllerOf(context)
                                        .setTheme("light");
                                  } else {
                                    ThemeProvider.controllerOf(context)
                                        .setTheme("dark");
                                  }
                                },
                              ),
                            ),
                            shaderCallback: (r) {
                              return LinearGradient(
                                colors:
                                    ThemeProvider.themeOf(context).id == "dark"
                                        ? [Colors.white, Colors.white]
                                        : [Colors.white, Color(0xfff3f3f3)],
                              ).createShader(r);
                            },
                          ),
                        )),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ListTile(
                      dense: true,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: AutoSizeText(
                          "Play Last Station on Startup",
                          style: TextStyle(
                            color: ThemeProvider.themeOf(context).id == "light"
                                ? Color(0xffA4A4A4)
                                : darkTxt,
                          ),
                        ),
                      ),
                      trailing: Container(
                        width: Get.width * 0.25,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: ThemeProvider.themeOf(context).id == "dark"
                                  ? Color(0x48000000)
                                  : Color(0xfffffff),
                              offset: Offset(0, 5),
                              blurRadius: 50,
                            ),
                          ],
                        ),
                        child: Center(
                            child: Theme(
                          data: ThemeData(),
                          child: ShaderMask(
                            child: Container(
                              child: CupertinoSwitch(
                                activeColor: Color(0xfffe6232),
                                value: dataController.settings[0],
                                onChanged: (v) async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  if (dataController.settings[0]) {
                                    dataController.settings[0] = false;
                                    prefs.setBool("playLast", false);
                                  } else {
                                    dataController.settings[0] = true;
                                    prefs.setBool("playLast", true);
                                  }
                                },
                              ),
                            ),
                            shaderCallback: (r) {
                              return LinearGradient(
                                colors:
                                    ThemeProvider.themeOf(context).id == "dark"
                                        ? [Colors.white, Colors.white]
                                        : [Colors.white, Color(0xfff3f3f3)],
                              ).createShader(r);
                            },
                          ),
                        )),
                      ),
                    ),
                    SizedBox(height: Get.height * 0.02),
                  ],
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              Padding(
                padding: EdgeInsets.only(
                    bottom: homeController.whoAccess.value != "none"
                        ? Get.height * 0.10
                        : 0),
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
                      ListTile(
                        dense: true,
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: AutoSizeText(
                            "Help And Feedback",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  ThemeProvider.themeOf(context).id == "light"
                                      ? darkBg
                                      : darkTxt,
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () async {
                          String uri = Uri.encodeFull(
                              'mailto:support@tuneoneradio.com?subject=AboutTuneOne&body=');
                          await launch(uri);
                        },
                        dense: true,
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: AutoSizeText(
                            "Help",
                            style: TextStyle(
                              color:
                                  ThemeProvider.themeOf(context).id == "light"
                                      ? Color(0xffA4A4A4)
                                      : darkTxt,
                            ),
                          ),
                        ),
                        trailing: Container(
                          width: Get.width * 0.25,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color:
                                    ThemeProvider.themeOf(context).id == "dark"
                                        ? Color(0x48000000)
                                        : Color(0xfffffff),
                                offset: Offset(0, 5),
                                blurRadius: 50,
                              ),
                            ],
                          ),
                          child: Icon(Icons.arrow_forward_ios,
                              color:
                                  ThemeProvider.themeOf(context).id == "light"
                                      ? Color(0x48000000)
                                      : darkTxt),
                        ),
                      ),
                      ListTile(
                        onTap: () async {
                          await canLaunch(
                            'https://tuneoneradio.com/about/',
                          )
                              ? await launch('https://tuneoneradio.com/about/')
                              : throw 'Could not launch ${'https://tuneoneradio.com/about/'}';
                        },
                        dense: true,
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: AutoSizeText(
                            "About Us",
                            style: TextStyle(
                              color:
                                  ThemeProvider.themeOf(context).id == "light"
                                      ? Color(0xffA4A4A4)
                                      : darkTxt,
                            ),
                          ),
                        ),
                        trailing: Container(
                          width: Get.width * 0.25,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color:
                                    ThemeProvider.themeOf(context).id == "dark"
                                        ? Color(0x48000000)
                                        : Color(0xfffffff),
                                offset: Offset(0, 5),
                                blurRadius: 50,
                              ),
                            ],
                          ),
                          child: Icon(Icons.arrow_forward_ios,
                              color:
                                  ThemeProvider.themeOf(context).id == "light"
                                      ? Color(0x48000000)
                                      : darkTxt),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          // LaunchReview.launch();
                          LaunchReview.launch(
                              androidAppId: "org.tuneoneradio",
                              iOSAppId: "1588979954");
                        },
                        dense: true,
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: AutoSizeText(
                            "Rate Us",
                            style: TextStyle(
                              color:
                                  ThemeProvider.themeOf(context).id == "light"
                                      ? Color(0xffA4A4A4)
                                      : darkTxt,
                            ),
                          ),
                        ),
                        trailing: Container(
                          width: Get.width * 0.25,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color:
                                    ThemeProvider.themeOf(context).id == "dark"
                                        ? Color(0x48000000)
                                        : Color(0xfffffff),
                                offset: Offset(0, 5),
                                blurRadius: 50,
                              ),
                            ],
                          ),
                          child: Icon(Icons.arrow_forward_ios,
                              color:
                                  ThemeProvider.themeOf(context).id == "light"
                                      ? Color(0x48000000)
                                      : darkTxt),
                        ),
                      ),
                      SizedBox(height: Get.height * 0.02),
                    ],
                  ),
                ),
              ),
              // dataController.islogin.isTrue
              //     ? Padding(
              //         padding: EdgeInsets.symmetric(
              //           horizontal: Get.width * 00.35,
              //           vertical: Get.width * 0.040,
              //         ),
              //         child: StyledButton(
              //           onPressed: () async {
              //             SharedPreferences prefs =
              //                 await SharedPreferences.getInstance();
              //             prefs.remove("islogin");
              //             dataController.islogin(false);
              //           },
              //           title: "Log out",
              //           backgroundColor:
              //               ThemeProvider.themeOf(context).id == "light"
              //                   ? backGroundColor
              //                   : Colors.black26,
              //           titleColor: darkTxt,
              //           borderRadius: BorderRadius.circular(5),
              //           fontSize: 16,
              //         ),
              //       )
              //     : SizedBox(),
            ],
          ),
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
