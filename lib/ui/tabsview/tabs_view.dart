import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tuneone/ui/shared/styles.dart';
import 'package:tuneone/ui/styled_widgets/mini_player.dart';
import 'package:tuneone/ui/tabsview/tabs_viewmodel.dart';

class TabsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TabsViewModel>(builder: (_) {
      return Scaffold(
        body: Stack(
          children: [
            Container(
              height: Get.height,
              child: _.items[_.index],
            ),
            Positioned(
              bottom: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: MiniPlayer(),
              ),
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: ThemeProvider.themeOf(context).id == "light"
              ? darkTxt
              : Theme.of(context).primaryColor,
          selectedLabelStyle: TextStyle(
            color: ThemeProvider.themeOf(context).id == "light"
                ? darkBg
                : Colors.white,
          ),
          selectedItemColor: ThemeProvider.themeOf(context).id == "light"
              ? darkBg
              : Colors.white,
          unselectedItemColor: ThemeProvider.themeOf(context).id == "light"
              ? darkBg
              : Colors.white,
          unselectedLabelStyle: TextStyle(
              color: ThemeProvider.themeOf(context).id == "light"
                  ? Colors.grey.withOpacity(0.8)
                  : Colors.white),
          onTap: _.changeIndex,
          currentIndex: _.index,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/Icon material-home.svg",
                  color: _.index == 0
                      ? ThemeProvider.themeOf(context).id == "light"
                          ? backGroundColor
                          : Colors.white
                      : Colors.grey.withOpacity(0.8)),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/Icon feather-radio.svg",
                  color: _.index == 1
                      ? ThemeProvider.themeOf(context).id == "light"
                          ? backGroundColor
                          : Colors.white
                      : Colors.grey.withOpacity(0.8)),
              label: "Radio",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/Icon awesome-podcast.svg",
                  color: _.index == 2
                      ? ThemeProvider.themeOf(context).id == "light"
                          ? backGroundColor
                          : Colors.white
                      : Colors.grey.withOpacity(0.8)),
              label: "Podcasts",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/Icon material-library-music.svg",
                  color: _.index == 3
                      ? ThemeProvider.themeOf(context).id == "light"
                          ? backGroundColor
                          : Colors.white
                      : Colors.grey.withOpacity(0.8).withOpacity(0.5)),
              label: "Library",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset("assets/Group 92.svg",
                  color: _.index == 4
                      ? ThemeProvider.themeOf(context).id == "light"
                          ? backGroundColor
                          : Colors.white
                      : Colors.grey.withOpacity(0.8)),
              label: "Following",
            ),
          ],
        ),
      );
    });
  }
}
