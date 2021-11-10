import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:tuneone/controllers/data_controller.dart';

class PodcastController extends GetxController {
  var isLoading = false.obs;
  var indexX = -2.obs;
  var appBar = "podcast".obs;
  final DataController dataController = Get.find();
  var height = (Get.height * 0.06).obs;

  @override
  void onInit() {
    print("con");
    Future.delayed(Duration(milliseconds: 0), () {
      dataController.radioList.value = dataController.radioListMasterCopy;
      dataController.podcastList.value = dataController.podcastListMasterCopy;
    });
    super.onInit();
  }

  @override
  void onClose() {
    print("con2");
    // called just before the Controller is deleted from memory
    // dataController.radioList.value = dataController.radioListMasterCopy;
    // dataController.podcastList.value = dataController.podcastListMasterCopy;
    super.onClose();
  }

  @override
  void onReady() {
    // called after the widget is rendered on screen
    print("con3");
    // dataController.radioList.value = dataController.radioListMasterCopy;
    // dataController.podcastList.value = dataController.podcastListMasterCopy;
    super.onReady();
  }
}
