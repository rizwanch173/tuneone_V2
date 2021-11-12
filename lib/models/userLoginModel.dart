// To parse this JSON data, do
//
//     final userLoginModel = userLoginModelFromJson(jsonString);
import 'dart:convert';

UserLoginModel userLoginModelFromJson(String str) =>
    UserLoginModel.fromJson(json.decode(str));

String userLoginModelToJson(UserLoginModel data) => json.encode(data.toJson());

class UserLoginModel {
  UserLoginModel({
    required this.message,
    required this.status,
    required this.user,
    required this.userMeta,
  });

  String message;
  int status;
  User user;
  UserMeta userMeta;

  factory UserLoginModel.fromJson(Map<String, dynamic> json) => UserLoginModel(
        message: json["message"],
        status: json["status"],
        user: User.fromJson(json["user"]),
        userMeta: UserMeta.fromJson(json["user_meta"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "user": user.toJson(),
        "user_meta": userMeta.toJson(),
      };
}

class User {
  User({
    required this.id,
    required this.userLogin,
    required this.userPass,
    required this.userNicename,
    required this.userEmail,
    required this.userUrl,
    required this.userRegistered,
    required this.userActivationKey,
    required this.userSixdigit,
    required this.userStatus,
    required this.displayName,
  });

  String id;

  String userLogin;
  String userPass;
  String userNicename;
  String userEmail;
  String userUrl;
  DateTime userRegistered;
  String userActivationKey;
  dynamic userSixdigit;
  String userStatus;
  String displayName;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["ID"],
        userLogin: json["user_login"],
        userPass: json["user_pass"],
        userNicename: json["user_nicename"],
        userEmail: json["user_email"],
        userUrl: json["user_url"],
        userRegistered: DateTime.parse(json["user_registered"]),
        userActivationKey: json["user_activation_key"],
        userSixdigit: json["user_sixdigit"],
        userStatus: json["user_status"],
        displayName: json["display_name"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "user_login": userLogin,
        "user_pass": userPass,
        "user_nicename": userNicename,
        "user_email": userEmail,
        "user_url": userUrl,
        "user_registered": userRegistered.toIso8601String(),
        "user_activation_key": userActivationKey,
        "user_sixdigit": userSixdigit,
        "user_status": userStatus,
        "display_name": displayName,
      };
}

class UserMeta {
  UserMeta({
    required this.nickname,
    required this.firstName,
    required this.lastName,
    required this.description,
    required this.likes,
    required this.followings,
    required this.avtar,
  });
  String avtar;
  String nickname;
  String firstName;
  String lastName;
  String description;
  List<dynamic> likes;
  List<dynamic> followings;

  factory UserMeta.fromJson(Map<String, dynamic> json) => UserMeta(
        nickname: json["nickname"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        description: json["description"],
        avtar: json["avtar"],
        likes: List<dynamic>.from(json["likes"].map((x) => x)),
        followings: List<dynamic>.from(json["followings"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "nickname": nickname,
        "first_name": firstName,
        "last_name": lastName,
        "description": description,
        "avtar": avtar,
        "likes": List<dynamic>.from(likes.map((x) => x)),
        "followings": List<dynamic>.from(followings.map((x) => x)),
      };
}
