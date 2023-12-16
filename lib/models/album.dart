// To parse this JSON data, do
//
//     final album = albumFromJson(jsonString);

import 'dart:convert';

List<Album> albumFromJson(String str) => List<Album>.from(json.decode(str).map((x) => Album.fromJson(x)));

String albumToJson(List<Album> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Album {
  String model;
  int pk;
  Fields fields;

  Album({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Album.fromJson(Map<String, dynamic> json) => Album(
    model: json["model"],
    pk: json["pk"],
    fields: Fields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "model": model,
    "pk": pk,
    "fields": fields.toJson(),
  };
}

class Fields {
  String name;
  String slug;
  int user;
  String description;
  String coverImage;
  List<int> books;

  Fields({
    required this.name,
    required this.slug,
    required this.user,
    required this.description,
    required this.coverImage,
    required this.books,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    name: json["name"],
    slug: json["slug"],
    user: json["user"],
    description: json["description"],
    coverImage: json["cover_image"],
    books: List<int>.from(json["books"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "slug": slug,
    "user": user,
    "description": description,
    "cover_image": coverImage,
    "books": List<dynamic>.from(books.map((x) => x)),
  };
}
