import 'dart:convert';

List<CourseSummary> courseSummaryFromJson(String str) => List<CourseSummary>.from(json.decode(str).map((x) => CourseSummary.fromJson(x)));

String courseSummaryToJson(List<CourseSummary> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CourseSummary {
  CourseSummary({
    this.id,
    this.title,
    this.description,
    this.category,
    this.author,
    this.coverImage,
    this.numberOfLesson,
    this.duration,
  });

  int id;
  String title;
  String description;
  String category;
  String author;
  String coverImage;
  int numberOfLesson;
  int duration;

  factory CourseSummary.fromJson(Map<String, dynamic> json) => CourseSummary(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    category: json["category"],
    author: json["author"],
    coverImage: json["cover_image"],
    numberOfLesson: json["number_of_lesson"],
    duration: json["duration"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "category": category,
    "author": author,
    "cover_image": coverImage,
    "number_of_lesson": numberOfLesson,
    "duration": duration,
  };
}
