import 'dart:convert';

List<RadioModel> radioModelFromJson(String str) =>
    List<RadioModel>.from(json.decode(str).map((x) => RadioModel.fromJson(x)));

String radioModelToJson(List<RadioModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RadioModel {
  RadioModel({
    required this.id,
    required this.date,
    required this.title,
    required this.link,
    required this.stream,
    required this.duration,
    required this.postCountAll,
    required this.likeCount,
    required this.downloadCount,
    required this.copyright,
    required this.thumbnail,
    required this.author,
    required this.slug,
    required this.isRadio,
    required this.genres,
  });

  int id;
  DateTime date;
  String title;
  String link;
  String stream;
  int duration;
  int postCountAll;
  int likeCount;
  int downloadCount;
  String copyright;
  String thumbnail;
  Author author;
  String slug;
  bool isRadio;
  List<int> genres;

  factory RadioModel.fromJson(Map<String, dynamic> json) => RadioModel(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        title: json["title"],
        link: json["link"],
        stream: json["stream"],
        duration: 0,
        postCountAll: json["post-count-all"],
        likeCount: json["like_count"],
        downloadCount: json["download_count"],
        copyright: json["copyright"],
        thumbnail: json["thumbnail"],
        slug: json["slug"],
        isRadio: json["isradio"],
        genres: List<int>.from(json["genres"].map((x) => x)),
        author: Author.fromJson(json["author"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date.toIso8601String(),
        "title": title,
        "link": link,
        "stream": stream,
        "duration": duration,
        "post-count-all": postCountAll,
        "like_count": likeCount,
        "download_count": downloadCount,
        "copyright": copyright,
        "thumbnail": thumbnail,
        "author": author.toJson(),
      };
}

class Author {
  Author({
    required this.authorId,
    required this.username,
    required this.email,
    required this.displayName,
    required this.link,
    required this.avtarUrl,
    required this.totalPlayed,
    required this.whatsapp,
    required this.description,
    required this.instagram,
    required this.facebook,
    required this.follow,
    required this.following,
  });

  String authorId;
  String username;
  String email;
  String displayName;
  String link;
  String avtarUrl;
  String totalPlayed;
  String whatsapp;
  String description;
  String instagram;
  List<String> facebook;
  List<int> follow;
  List<int> following;

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        authorId: json["author_id"],
        username: json["username"],
        email: json["email"],
        displayName: json["display_name"],
        link: json["link"],
        avtarUrl: json["avtar_url"],
        totalPlayed: json["total_played"] ?? "0",
        whatsapp: json["whatsapp"] == "" ? "---" : json["whatsapp"],
        description: json["description"],
        instagram: json["instagram"],
        facebook: List<String>.from(json["facebook"].map((x) => x)),
        follow: List<int>.from(json["follow"].map((x) => x)),
        following: List<int>.from(json["following"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "author_id": authorId,
        "username": username,
        "email": email,
        "display_name": displayName,
        "link": link,
        "avtar_url": avtarUrl,
        "total_played": totalPlayed,
        "whatsapp": whatsapp,
        "description": description,
        "instagram": instagram,
        "facebook": List<dynamic>.from(facebook.map((x) => x)),
        "follow": List<dynamic>.from(follow.map((x) => x)),
        "following": List<dynamic>.from(following.map((x) => x)),
      };
}
