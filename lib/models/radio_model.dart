import 'dart:convert';

List<RadioModel> radioModelFromJson(String str) =>
    List<RadioModel>.from(json.decode(str).map((x) => RadioModel.fromJson(x)));

String radioModelToJson(List<RadioModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RadioModel {
  RadioModel(
      {required this.id,
      required this.date,
      required this.title,
      required this.stream,
      required this.postCountAll,
      required this.likeCount,
      required this.downloadCount,
      required this.copyright,
      required this.thumbnail,
      required this.author,
      required this.duration});

  int id;
  DateTime date;
  String title;
  String stream;
  int postCountAll;
  int likeCount;
  int downloadCount;
  String copyright;
  String thumbnail;
  Author author;
  int duration;

  factory RadioModel.fromJson(Map<String, dynamic> json) => RadioModel(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        title: json["title"],
        stream: json["stream"],
        postCountAll: json["post-count-all"],
        likeCount: json["like_count"],
        downloadCount: json["download_count"],
        copyright: json["copyright"],
        thumbnail: json["thumbnail"],
        author: Author.fromJson(json["author"]),
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
      };
}

class Author {
  Author({
    required this.authorId,
    required this.username,
    required this.email,
    required this.displayName,
  });

  String username;
  String email;
  String displayName;
  String authorId;

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        authorId: json["author_id"],
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
