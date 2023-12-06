// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

// ignore_for_file: avoid_print, constant_identifier_names

import 'dart:convert';

List<Book> bookFromJson(String str) => List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

String bookToJson(List<Book> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
    Model? model;
    int? pk;
    Fields? fields;

    Book({
         this.model,
         this.pk,
         this.fields,
    });

    factory Book.fromJson(Map<String, dynamic> json) => Book(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"]!,
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields!.toJson(),
    };
}

class Fields {
    String? title;
    String? author;
    String? description;
    double? rating;
    double? price;
    Language? language;
    String? genres;
    String? characters;
    String? edition;
    int? pages;
    String? publisher;
    String? awards;
    int? numRatings;
    int? numLikes;
    String? coverImg;
    List<int>? review;
    List<int>? likedByUsers;

    Fields({
         this.title,
         this.author,
         this.description,
         this.rating,
         this.price,
         this.language,
         this.genres,
         this.characters,
         this.edition,
         this.pages,
         this.publisher,
         this.awards,
         this.numRatings,
         this.numLikes,
         this.coverImg,
         this.review,
         this.likedByUsers,
    });

    factory Fields.fromJson(Map<String, dynamic> json) {
      // print("Parsing Fields JSON: $json");
      // print("testestestest");
/// The commented code block is assigning values to variables by extracting them from the JSON object.
/// It is using the `json` object to access the corresponding values from the JSON data. If a value is
/// not present in the JSON data, it assigns a default value (empty string, 0, or an empty list) to the
/// variable using the null-aware operator `??`.

      // final title= json["title"] ?? "";
      // final author= json["author"] ?? "";
      // final description= json["description"] ?? "";
      // final rating= json["rating"] ?? 0;
      // final price= json["price"]?.toDouble() ?? 0.0;
      // final language= languageValues.map[json["language"]] ?? Language.ENGLISH;
      // final genres= json["genres"] ?? "";
      // final characters= json["characters"] ?? "";
      // final edition= json["edition"] ?? "";
      // final pages= json["pages"] ?? 0;
      // final publisher= json["publisher"] ?? "";
      // final awards= json["awards"] ?? "";
      // final numRatings= json["numRatings"] ?? 0;
      // final numLikes= json["numLikes"] ?? 0;
      // final coverImg= json["coverImg"] ?? "";
      // final review= List<int>.from(json["review"]?.map((x) => x) ?? []);
      // final likedByUsers = List<int>.from(json["liked_by_users"]?.map((x) => x) ?? []);

      // print("title"); print("$title");
      // print("titleaw");print("$author");
      // print("titledswa");print("$description");
      // print("titlebreas");print("$rating");
      // print("titlepfeaw");print("$price");
      // print("titlelsage");print("$language");
      // print("titlegreds");
      // print("$genres");
      // print("titlefcgaw");
      // print("$characters");
      // print("titleedtrwas");
      // print("$edition");
      // print("titlepage");
      // print("$pages");
      // print("titlepbisa");
      // print("$publisher");
      // print("titleawarsd");
      // print("$awards");
      // print("titlenumrat");
      // print("$numRatings");
      // print("titlelikes");
      // print("$numLikes");
      // print("titlevmoeger");
      // print("$coverImg");
      // print("titlereviwq");
      // print("$review");
      // print("titlelikesd");
      // print("$likedByUsers");

      
      final fields = Fields(
        title: json["title"] ?? "",
        author: json["author"] ?? "",
        description: json["description"] ?? "",
        rating: json["rating"]?.toDouble() ?? 0.0,
        price: json["price"]?.toDouble() ?? 0.0,
        language: languageValues.map[json["language"]] ?? Language.ENGLISH,
        genres: json["genres"] ?? "",
        characters: json["characters"] ?? "",
        edition: json["edition"] ?? "",
        pages: json["pages"] ?? 0,
        publisher: json["publisher"] ?? "",
        awards: json["awards"] ?? "",
        numRatings: json["numRatings"] ?? 0,
        numLikes: json["numLikes"] ?? 0,
        coverImg: json["coverImg"] ?? "",
        review: List<int>.from(json["review"]?.map((x) => x) ?? []), //how to print here?
        likedByUsers: List<int>.from(json["liked_by_users"]?.map((x) => x) ?? []),
      );
      // print("Parsed Fields: $fields");
      // print("seconseconseconsecond");
      return fields;
    }

    Map<String, dynamic> toJson() => {
        "title": title,
        "author": author,
        "description": description,
        "rating": rating,
        "price": price,
        "language": languageValues.reverse[language],
        "genres": genres,
        "characters": characters,
        "edition": edition,
        "pages": pages,
        "publisher": publisher,
        "awards": awards,
        "numRatings": numRatings,
        "numLikes": numLikes,
        "coverImg": coverImg,
        "review": List<dynamic>.from(review!.map((x) => x)),
        "liked_by_users": List<dynamic>.from(likedByUsers!.map((x) => x)),
    };
}

enum Language {
    ENGLISH,
    JAPANESE,
    PBP
}

final languageValues = EnumValues({
    "English": Language.ENGLISH,
    "Japanese": Language.JAPANESE,
    "PBP": Language.PBP
});

enum Model {
    HOMEPAGE_BOOK
}

final modelValues = EnumValues({
    "homepage.book": Model.HOMEPAGE_BOOK
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}