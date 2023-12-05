// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

List<Review> reviewFromJson(String str) => List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
    String model;
    int pk;
    Fields fields;

    Review({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
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
    int user;
    int stars;
    String name;
    dynamic reply;
    int upvote;
    int downvote;
    DateTime dateAdded;
    String description;

    Fields({
        required this.user,
        required this.stars,
        required this.name,
        required this.reply,
        required this.upvote,
        required this.downvote,
        required this.dateAdded,
        required this.description,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        stars: json["stars"],
        name: json["name"],
        reply: json["reply"],
        upvote: json["upvote"],
        downvote: json["downvote"],
        dateAdded: DateTime.parse(json["date_added"]),
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "stars": stars,
        "name": name,
        "reply": reply,
        "upvote": upvote,
        "downvote": downvote,
        "date_added": "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
        "description": description,
    };
}
