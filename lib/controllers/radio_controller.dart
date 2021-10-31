import 'package:get/state_manager.dart';
import 'package:tuneone/Services/remote_services.dart';
import 'package:tuneone/models/radio_model.dart';
import 'package:flutter/services.dart';
import 'package:audio_manager/audio_manager.dart';

class RadioController extends GetxController {
  var radioList = <RadioModel>[].obs;
  var txt = "new".obs;
  var isLoading = true.obs;
  var manualCallSet = false.obs;
  var nextStationIndex = 0.obs;
  var platformVersion = 'Unknown'.obs;
  var isPlaying = false.obs;
  var duration = Duration.zero.obs;
  var position = Duration.zero.obs;
  var slider = 0.0.obs;
  var sliderVolume = 0.0.obs;
  var error = "No".obs;
  RxInt curIndex = 0.obs;
  var playMode = AudioManager.instance.playMode.obs;
  var indexX = -1.obs;
  var appBar = "Radios".obs;

  @override
  void onInit() {
    print("init RadioController");
    print(radioList);
    initPlatformState();

    //fetchRadioList().then((value) {});
    super.onInit();
  }

  @override
  void dispose() {
    AudioManager.instance.release();
    print("Dispose");
    super.dispose();
  }

  void setupAudio() {
    List<AudioInfo> _list = [];
    radioList.forEach((item) => _list.add(
          AudioInfo(
            item.stream,
            title: item.title,
            desc: item.title,
            coverUrl: item.thumbnail,
          ),
        ));

    AudioManager.instance.audioList = _list;
    AudioManager.instance.intercepter = true;
    AudioManager.instance.play(auto: false);

    AudioManager.instance.onEvents((events, args) {
      print("$events, $args");
      switch (events) {
        case AudioManagerEvents.start:
          print(
              "start load data callback, curIndex is ${AudioManager.instance.curIndex}");
          position.value = AudioManager.instance.position;
          duration.value = AudioManager.instance.duration;
          slider.value = 0;
          break;
        case AudioManagerEvents.ready:
          print("ready to play");
          error.value = "";
          sliderVolume.value = AudioManager.instance.volume;
          position.value = AudioManager.instance.position;
          duration.value = AudioManager.instance.duration;

          // if you need to seek times, must after AudioManagerEvents.ready event invoked
          // AudioManager.instance.seekTo(Duration(seconds: 10));
          break;
        case AudioManagerEvents.seekComplete:
          position.value = AudioManager.instance.position;
          slider.value =
              position.value.inMilliseconds / duration.value.inMilliseconds;

          print("seek event is completed. position is [$args]/ms");
          break;
        case AudioManagerEvents.buffering:
          print("buffering $args");
          break;
        case AudioManagerEvents.playstatus:
          isPlaying.value = AudioManager.instance.isPlaying;
          print("Called AudioManagerEvents.playstatus ");
          print(isPlaying.value);

          break;
        case AudioManagerEvents.timeupdate:
          position.value = AudioManager.instance.position;
          slider.value =
              position.value.inMilliseconds / duration.value.inMilliseconds;

          AudioManager.instance.updateLrc(args["position"].toString());
          break;
        case AudioManagerEvents.error:
          error.value = args;

          break;
        case AudioManagerEvents.ended:
          AudioManager.instance.next();
          break;

        case AudioManagerEvents.volumeChange:
          sliderVolume.value = AudioManager.instance.volume;

          break;
        default:
          break;
      }
    });
  }

  Future<void> initPlatformState() async {
    try {
      platformVersion.value = await AudioManager.instance.platformVersion;
    } on PlatformException {
      platformVersion.value = 'Failed to get platform version.';
    }
    platformVersion = platformVersion;

    return;
  }
}
