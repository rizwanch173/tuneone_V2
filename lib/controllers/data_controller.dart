import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:tuneone/models/podcast_model.dart';
import 'package:tuneone/models/radio_model.dart';
import 'package:tuneone/models/recently_model.dart';
import 'package:tuneone/models/userLoginModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataController extends GetxController {
  var podcastList = <PodcastModel>[].obs;
  var podcastListMasterCopy = <PodcastModel>[].obs;
  var radioList = <RadioModel>[].obs;
  var radioListLike = <RadioModel>[].obs;
  var radioListMasterCopy = <RadioModel>[].obs;
  var mediaListPodcast = <MediaItem>[].obs;
  var mediaListRadio = <MediaItem>[].obs;
  late UserLoginModel userList;

  var likeList = <dynamic>[].obs;
  //var recentlyList = <int>[].obs;
  var recentlyList = <RecentlyModel>[].obs;

  var isPayed = true.obs;

  var email = "".obs;
  var pass = "".obs;
  var islogin = false.obs;

  ///loader
  var isRadioLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  addRecently(dynamic played, bool fromPod) async {
    var recently = new RecentlyModel(
      id: played.id,
      date: played.date,
      title: played.title,
      stream: played.stream,
      postCountAll: played.postCountAll,
      likeCount: played.likeCount,
      downloadCount: played.downloadCount,
      copyright: played.copyright,
      thumbnail: played.thumbnail,
      author: Author2(
          username: played.author.username,
          email: played.author.email,
          displayName: played.author.displayName),
      duration: fromPod ? 1 : 0,
    );
    recentlyList.removeWhere((element) => element.id == played.id);

    recentlyList.insert(0, recently);

    // recentlyList.addIf(
    //     recentlyList.every((w) => w.id != recently.id), recently);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('recently', jsonEncode(recentlyList));
    print(recentlyList.length);
  }
}

// var mediaItem = <MediaItem>[];
//List<MediaItem> get itemsListO => mediaItem;
