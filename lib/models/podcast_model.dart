import 'dart:convert';

List<PodcastModel> podcastModelFromJson(String str) => List<PodcastModel>.from(
    json.decode(str).map((x) => PodcastModel.fromJson(x)));

String podcastModelToJson(List<PodcastModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PodcastModel {
  PodcastModel(
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
  Duration duration;

  factory PodcastModel.fromJson(Map<String, dynamic> json) => PodcastModel(
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
        duration: Duration(milliseconds: json["duration"]),
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
    required this.username,
    required this.email,
    required this.displayName,
  });

  String username;
  String email;
  String displayName;

  factory Author.fromJson(Map<String, dynamic> json) => Author(
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
