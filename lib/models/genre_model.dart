import 'dart:convert';

List<GenreModel> genreModelFromJson(String str) =>
    List<GenreModel>.from(json.decode(str).map((x) => GenreModel.fromJson(x)));

String genreModelToJson(List<GenreModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GenreModel {
  GenreModel({
    required this.id,
    required this.count,
    required this.description,
    required this.link,
    required this.name,
    required this.slug,
    required this.taxonomy,
    required this.parent,
  });

  int id;
  int count;
  String description;
  String link;
  String name;
  String slug;
  String taxonomy;
  int parent;

  factory GenreModel.fromJson(Map<String, dynamic> json) => GenreModel(
        id: json["id"],
        count: json["count"],
        description: json["description"],
        link: json["link"],
        name: json["name"],
        slug: json["slug"],
        taxonomy: json["taxonomy"],
        parent: json["parent"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "count": count,
        "description": description,
        "link": link,
        "name": name,
        "slug": slug,
        "taxonomy": taxonomy,
        "parent": parent,
      };
}
