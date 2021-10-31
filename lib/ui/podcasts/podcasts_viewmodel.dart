import 'package:get/get.dart';

class PodCastsViewModel extends GetxController{
  bool showMyPodCast=false;

  changeShowPodCast(bool val){
    showMyPodCast=val;
    update();
  }
}