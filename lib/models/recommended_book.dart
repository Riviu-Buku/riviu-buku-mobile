import 'dart:convert';

List<RecommendedBook> recommendedBookFromJson(String str) => List<RecommendedBook>.from(json.decode(str).map((x) => RecommendedBook.fromJson(x)));

String recommendedBookToJson(List<RecommendedBook> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RecommendedBook {
    String model;
    int pk;
    Fields fields;

    RecommendedBook({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory RecommendedBook.fromJson(Map<String, dynamic> json) => RecommendedBook(
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
    String title;
    String author;

    Fields({
        required this.title,
        required this.author,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        title: json["title"],
        author: json["author"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "author": author,
    };
}
