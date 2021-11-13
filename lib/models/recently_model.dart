import 'dart:convert';

List<RecentlyModel> recentlyModelFromJson(String str) =>
    List<RecentlyModel>.from(
        json.decode(str).map((x) => RecentlyModel.fromJson(x)));

String recentlyModelToJson(List<RecentlyModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RecentlyModel {
  RecentlyModel({
    required this.id,
    required this.date,
    required this.title,
    required this.stream,
    required this.postCountAll,
    required this.likeCount,
    required this.downloadCount,
    required this.copyright,
    required this.thumbnail,
    required this.author,
    required this.duration,
    required this.slug,
    required this.isRadio,
  });

  int id;
  DateTime date;
  String title;
  String stream;
  int postCountAll;
  int likeCount;
  int downloadCount;
  String copyright;
  String thumbnail;
  Author2 author;
  int duration;
  String slug;
  bool isRadio;

  factory RecentlyModel.fromJson(Map<String, dynamic> json) => RecentlyModel(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        title: json["title"],
        stream: json["stream"],
        postCountAll: json["post-count-all"],
        likeCount: json["like_count"],
        downloadCount: json["download_count"],
        copyright: json["copyright"],
        thumbnail: json["thumbnail"],
        slug: json["slug"],
        isRadio: json["isradio"],
        author: Author2.fromJson(json["author"]),
        duration: 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date.toIso8601String(),
        "title": title,
        "stream": stream,
        "post-count-all": postCountAll,
        "like_count": likeCount,
        "download_count": downloadCount,
        "copyright": copyright,
        "thumbnail": thumbnail,
        "author": author.toJson(),
        "duration": duration,
        "isradio": isRadio,
        "slug": slug,
      };
}

class Author2 {
  Author2({
    required this.username,
    required this.email,
    required this.displayName,
  });

  String username;
  String email;
  String displayName;

  factory Author2.fromJson(Map<String, dynamic> json) => Author2(
        username: json["username"],
        email: json["email"],
        displayName: json["display_name"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "display_name": displayName,
      };
}
