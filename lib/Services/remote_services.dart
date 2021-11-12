import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:tuneone/controllers/data_controller.dart';
import 'package:tuneone/controllers/login_controller.dart';
import 'package:tuneone/controllers/signup_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuneone/models/genre_model.dart';
import 'package:tuneone/models/podcast_model.dart';
import 'package:tuneone/models/radio_model.dart';
import 'package:tuneone/models/userLoginModel.dart';

class RemoteServices {
  static var client = http.Client();

  static final DataController dataController = Get.find();

  static Future<http.Response> apiRequest(String url, Map jsonMap) async {
    var body = jsonEncode(jsonMap);
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
      },
      body: body,
    );
    return response;
  }

  static Future<List?> fetchRadioList() async {
    print("API fetchRadioList");
    var response = await client.get(Uri.parse(
        'https://tuneoneradio.com/wp-json/wp/v2/station?genre=58&_embed&per_page=100'));
    if (response.statusCode == 200) {
      var jsonString = response.body;
      var data = radioModelFromJson(jsonString);
      dataController.radioListMasterCopy.value = data;
      dataController.radioList.value = dataController.radioListMasterCopy;
      dataController.isRadioLoading(false);

      dataController.mediaListRadio
          .addAll(dataController.radioList.map((song) => MediaItem(
                id: song.stream,
                album: song.author.displayName,
                title: song.title,
                artist: song.author.displayName,
                // duration: Duration(milliseconds: 2856950),
                artUri: Uri.parse(song.thumbnail),
              )));

      // dataController.radioListLike.value = dataController.radioListMasterCopy
      //     .where(
      //         (u) => (u.id.isEqual(dataController.userList.userMeta.likes.where((element) => (element)))))
      //     .toList();

      return [true];
    } else {
      //show error message
      return [false];
    }
  }

  static Future<List?> fetchPodcastList() async {
    print("API fetchpodCast");
    var response = await client.get(Uri.parse(
        'https://tuneoneradio.com/wp-json/wp/v2/station?genre=52&_embed&per_page=100'));
    if (response.statusCode == 200) {
      var jsonString = response.body;
      dataController.podcastListMasterCopy.value =
          podcastModelFromJson(jsonString);
      dataController.podcastList.value = dataController.podcastListMasterCopy;

      // dataController.podcastList.forEach((element) {
      //   element.duration = fetchDuration(element.stream);
      // });

      dataController.mediaListPodcast
          .addAll(dataController.podcastList.map((song) => MediaItem(
                id: song.stream,
                album: song.author.displayName,
                title: song.title,
                artist: song.author.displayName,
                duration: song.duration,
                artUri: Uri.parse(song.thumbnail),
              )));

      //  await fetchDuration();

      print(dataController.mediaListPodcast.length);

      return [true];
    } else {
      return [false];
    }
  }

  static fetchDuration() {
    // for(var i=0;i<3;i++)
    //   {
    //     final player = new AudioPlayer();
    //     var dur = player.setUrl(dataController.podcastList[i].stream).then((value) {
    //       // element.duration = value!;
    //       print("object");
    //
    //       print(dataController.podcastList[i].stream);
    //       print("comp");
    //       print(value.toString());
    //     });
    //
    //   }
    dataController.podcastList.forEach((element) {
      final player = new AudioPlayer();
      var dur = player.setUrl(element.stream).then((value) {
        // element.duration = value!;
        print("object");

        print(element.stream);
        print("comp");
        print(value.toString());
      });
    });

    // return Duration();
    //print(dur.runtimeType);
  }

  static Future<List?> loginUser(username, password) async {
    LoginController controller = Get.find();

    final param = {
      "username": username,
      "password": password,
    };

    var response = await apiRequest(
        "https://tuneoneradio.com/wp-json/wp/v2/users/userlogin", param);
    var jsonString = response.body;

    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      print(response.body);
      if (item['status'] == 201) {
        var user = userLoginModelFromJson(jsonString);
        dataController.userList = user;
        dataController.islogin(true);

        dataController.likeList.addAll(user.userMeta.likes);

        return [true, "", user];
      } else {
        controller.errorMsg.value = item['message'];
        return [false, item['message'], null];
      }
    } else {
      return [false, "try again", null];
    }
  }

  static Future<List?> checkPay() async {
    try {
      var response = await http.get(
        Uri.parse("https://floein.com/checkpayment"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
      );
      final item = json.decode(response.body);
      print(item['ispaid']);
      dataController.isPayed.value = item["ispaid"];
    } catch (v) {
      print("catch");
    }
  }

  static Future<bool?> loginUserByCode(username, password) async {
    print(username);
    final param = {
      "username": username,
      "password": password,
    };

    var response = await apiRequest(
        "https://tuneoneradio.com/wp-json/wp/v2/users/userlogin", param);
    var jsonString = response.body;

    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      print(response.body);
      if (item['status'] == 201) {
        var user = userLoginModelFromJson(jsonString);
        dataController.userList = user;
        dataController.likeList.addAll(user.userMeta.likes);
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<bool?> likeDislike(
      {required bool like, required int postId}) async {
    if (like)
      dataController.likeList.add(postId);
    else
      dataController.likeList.remove(postId);

    print(postId);
    final param = {
      "meta": {"id": postId},
      "is_like": like
    };

    var response = await apiRequest(
        "https://tuneoneradio.com/wp-json/wp/v2/users/" +
            dataController.userList.user.id,
        param);
    var jsonString = response.body;

    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      if (like) {
        dataController.userList.userMeta.likes.add(postId);
      } else {
        print("remove");
        dataController.userList.userMeta.likes.remove(postId);
      }
      print(response.body);

      return true;
    } else {
      return false;
    }
  }

  static Future<bool?> getGenre() async {
    var response = await client.get(Uri.parse(
        'https://tuneoneradio.com/wp-json/wp/v2/genre?&per_page=100'));

    if (response.statusCode == 200) {
      var jsonString = response.body;
      dataController.genrelistMaster.value = genreModelFromJson(jsonString);

      dataController.genrelistRadio.value = dataController.genrelistMaster
          .where((p0) => p0.parent == 58)
          .toList();

      dataController.genrelistPod.value = dataController.genrelistMaster
          .where((p0) => p0.parent == 52)
          .toList();

      return true;
    } else {
      return false;
    }
  }

  static Future<List?> registerUser(
      {firstName, lastName, username, email, password}) async {
    final SignUpController signUpController = Get.find();
    final param = {
      "firstname": firstName,
      "lastname": lastName,
      "username": username,
      "email": email,
      "password": password,
      "confirmpassword": password
    };

    var response =
        await apiRequest("https://tuneoneradio.com/wp-json/wp/v2/users", param);
    var jsonString = response.body;

    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final item = json.decode(response.body);
      print(response.body);
      var user;
      // userLoginModelFromJson(jsonString);

      return [true, "", user];
    } else {
      final item = json.decode(response.body);
      signUpController.errorMsg.value = item['message'];
      return [false, item['message'], null];
    }
  }

  Future<bool?> saveUserLoginBYCode({email, pass}) async {
    // RemoteServices.fetchPodcastList();
    // RemoteServices.fetchRadioList();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("islogin", true);
    prefs.setString("email", email);
    prefs.setString("pass", pass);
    prefs.setString('user', jsonEncode(dataController.userList));
  }
}
