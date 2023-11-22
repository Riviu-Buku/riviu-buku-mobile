// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'dart:convert';

List<Book> bookFromJson(String str) => List<Book>.from(json.decode(str).map((x) => Book.fromJson(x)));

String bookToJson(List<Book> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Book {
    Model model;
    int pk;
    Fields fields;

    Book({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Book.fromJson(Map<String, dynamic> json) => Book(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String title;
    String author;
    String? description;
    int? rating;
    double? price;
    Language? language;
    String? genres;
    dynamic characters;
    String? edition;
    int? pages;
    String? publisher;
    dynamic awards;
    int? numRatings;
    dynamic numLikes;
    String? coverImg;
    List<int> review;
    List<int> likedByUsers;

    Fields({
        required this.title,
        required this.author,
        required this.description,
        required this.rating,
        required this.price,
        required this.language,
        required this.genres,
        required this.characters,
        required this.edition,
        required this.pages,
        required this.publisher,
        required this.awards,
        required this.numRatings,
        required this.numLikes,
        required this.coverImg,
        required this.review,
        required this.likedByUsers,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        title: json["title"],
        author: json["author"],
        description: json["description"],
        rating: json["rating"],
        price: json["price"]?.toDouble(),
        language: languageValues.map[json["language"]]!,
        genres: json["genres"],
        characters: json["characters"],
        edition: json["edition"],
        pages: json["pages"],
        publisher: json["publisher"],
        awards: json["awards"],
        numRatings: json["numRatings"],
        numLikes: json["numLikes"],
        coverImg: json["coverImg"],
        review: List<int>.from(json["review"].map((x) => x)),
        likedByUsers: List<int>.from(json["liked_by_users"].map((x) => x)),
    );

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
        "review": List<dynamic>.from(review.map((x) => x)),
        "liked_by_users": List<dynamic>.from(likedByUsers.map((x) => x)),
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
