import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuneone/Services/remote_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuneone/controllers/data_controller.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final DataController dataController = Get.find();
  var errorMsg = "Error".obs;

  var isLoading = false.obs;

  Future<bool?> userLoginController(email, password) async {
    try {
      isLoading(true);
      update();
      var user = await RemoteServices.loginUser(email, password);
      if (user![0]) {
        errorMsg.value = user[1];
        isLoading(false);
        update();
        return true;
      } else {
        isLoading(false);
        errorMsg.value = user[1];
        update();
        return false;
      }
    } finally {
      isLoading(false);
      update();
    }
  }

  Future<bool?> saveUserLogin({email, pass}) async {
    // RemoteServices.fetchPodcastList();
    // RemoteServices.fetchRadioList();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("islogin", true);
    prefs.setString("email", email);
    prefs.setString("pass", pass);
    prefs.setString('user', jsonEncode(dataController.userList));
  }
}
