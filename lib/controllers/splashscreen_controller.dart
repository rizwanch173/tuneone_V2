import 'dart:convert';
import 'package:get/get.dart';
import 'package:tuneone/Services/remote_services.dart';
import 'package:tuneone/controllers/data_controller.dart';
import 'package:tuneone/controllers/home_controllers.dart';
import 'package:tuneone/models/recently_model.dart';
import 'package:tuneone/models/userLoginModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class SplashScreenController extends GetxController {
  final DataController dataController = Get.find();
  checkStartUpLogic() {
    RemoteServices.fetchPodcastList();
    RemoteServices.fetchRadioList();
    checkLogin();
    loadSettings();

    RemoteServices.fetchPodcastList();
    RemoteServices.fetchRadioList();
    RemoteServices.getGenre();
    RemoteServices.checkPay();
    Future.delayed(Duration(seconds: 2), () {
      Get.offAndToNamed("/tabs");
      if (dataController.islogin.isTrue) {
        //  RemoteServices.loginUser(dataController., password);
      }
    });
  }

  @override
  void onInit() {
    checkStartUpLogic();
    super.onInit();
  }

  Future<bool> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("recently")) {
      fetchSpDataRecently();
    }
    if (prefs.containsKey("islogin")) {
      dataController.islogin(true);
      fetchSpData().then((value) {});
      return true;
    }

    return false;
  }

  Future<bool?> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("playLast")) {
      dataController.settings[0] = prefs.getBool("playLast")!;
    }

    return false;
  }

  Future<UserLoginModel> fetchSpData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> userMap;
    final String userStr = prefs.getString('user')!;
    userMap = jsonDecode(userStr) as Map<String, dynamic>;
    dataController.userList = userLoginModelFromJson(userStr);

    dataController.email.value = prefs.getString("email")!;
    dataController.pass.value = prefs.getString("pass")!;

    print(dataController.userList.user.userEmail);

    RemoteServices.loginUserByCode(
        prefs.getString("email"), prefs.getString("pass"));

    return dataController.userList;
  }

  fetchSpDataRecently() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String recently = prefs.getString('recently')!;
    dataController.recentlyList.value = recentlyModelFromJson(recently);
  }
}
