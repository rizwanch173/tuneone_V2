import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuneone/controllers/splashscreen_controller.dart';

class SplashScreenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: GetBuilder<SplashScreenController>(
        builder: (_) {
          return Container(
              child: Image.asset(
            "assets/splash.png",
            fit: BoxFit.cover,
          ));
        },
      ),
    );
  }
}
