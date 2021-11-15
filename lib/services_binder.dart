import 'package:get/instance_manager.dart';
import 'package:tuneone/controllers/data_controller.dart';
import 'package:tuneone/controllers/home_controllers.dart';
import 'package:tuneone/controllers/podcast_controller.dart';

class ServicesBinder extends Bindings {
  @override
  void dependencies() {
    Get.put<DataController>(DataController(), permanent: true);
    Get.put<PodcastController>(PodcastController(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
    // Get.put<LoginController>(LoginController(), permanent: true);

    print("binder");
  }
}
