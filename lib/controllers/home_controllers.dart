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
  var indexToPlayRadio = -1.obs;
  var indexToPlayPod = -2.obs;
  var podAppbar = "Podcasts".obs;

  @override
  void onInit() {
    super.onInit();
  }

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
}
