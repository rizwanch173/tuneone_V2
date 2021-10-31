import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';

class MediaListViewModel extends GetxController {
  @override
  void onInit() {
    print("MediaListViewModel");
    super.onInit();
  }

  @override
  void dispose() {
    AudioService.stop();
    super.dispose();
  }
}
