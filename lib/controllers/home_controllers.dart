import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:tuneone/Services/remote_services.dart';
import 'package:tuneone/controllers/data_controller.dart';
import 'package:tuneone/models/home_model.dart';
import 'package:get/get.dart';

import '../main.dart';

class HomeController extends GetxController {
  final DataController dataController = Get.find();
  var isLoading = true.obs;
  var productList = <Product>[].obs;
  var whoAccess = "none".obs;
  var indexToPlayRadio = 0.obs;
  var indexToPlayPod = 0.obs;
  var podAppbar = "Podcasts".obs;
  var colorX = Colors.white.obs;
  var selectedIndex = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  // var gradient = [
  //   {
  //     "grad": [Color(0xff000000), Color(0xff000000)]
  //   },
  //   {
  //     "grad": [Color(0xff000000), Color(0xff000000)]
  //   }
  // ];

  String greetingMessage() {
    var timeNow = DateTime.now().hour;

    if (timeNow <= 12) {
      return 'Good Morning';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      return 'Good Afternoon';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  prepareAuthorList({String? authorId}) {
    dataController.currentRadioCopy.value = dataController.radioListMasterCopy
        .where((u) => (u.author.authorId == authorId))
        .toList();
    dataController.currentPodCopy.value = dataController.podcastListMasterCopy
        .where((u) => (u.author.authorId == authorId))
        .toList();
    dataController.morefromList.clear();
    dataController.morefromList.addAll(dataController.currentRadioCopy);
    dataController.morefromList.addAll(dataController.currentPodCopy);

    print("prepareAuthorList");
    print(dataController.currentRadioCopy.length);
    print(dataController.currentPodCopy.length);
  }

  String k_m_b_generator(num) {
    if (num > 999 && num < 99999) {
      return "${(num / 1000).toStringAsFixed(1)} K";
    } else if (num > 99999 && num < 999999) {
      return "${(num / 1000).toStringAsFixed(0)} K";
    } else if (num > 999999 && num < 999999999) {
      return "${(num / 1000000).toStringAsFixed(1)} M";
    } else if (num > 999999999) {
      return "${(num / 1000000000).toStringAsFixed(1)} B";
    } else {
      return num.toString();
    }
  }

  queUpdater() {
    audioHandler.updateQueue(dataController.mediaListRadio);
  }

  updateView() {
    print("object0");
    Future.delayed(Duration(milliseconds: 1), () {
      dataController.radioList.value = dataController.radioListMasterCopy;
      dataController.podcastList.value = dataController.podcastListMasterCopy;
    });
  }

  Future<bool?> showAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String cancelActionText,
    required String defaultActionText,
  }) async {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          CupertinoDialogAction(
              child: Text(
                cancelActionText,
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              }),
          CupertinoDialogAction(
              child: Text(
                defaultActionText,
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                Get.toNamed("/authoption");
                //Navigator.of(context).pop(true);
              }),
        ],
      ),
    );
  }
}
