import 'dart:convert';
import 'lesson_summary.dart';

Course courseFromJson(String str) => Course.fromJson(json.decode(str));

String courseToJson(Course data) => json.encode(data.toJson());

class Course {
  Course({
    this.id,
    this.title,
    this.description,
    this.category,
    this.author,
    this.coverImage,
    this.numberOfLesson,
    this.duration,
    this.lessons,
  });

  int id;
  String title;
  String description;
  String category;
  String author;
  String coverImage;
  int numberOfLesson;
  int duration;
  List<LessonSummary> lessons;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    category: json["category"],
    author: json["author"],
    coverImage: json["cover_image"],
    numberOfLesson: json["number_of_lesson"],
    duration: json["duration"],
    lessons: List<LessonSummary>.from(json["lessons"].map((x) => LessonSummary.fromJson(x))),
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
    "lessons": List<dynamic>.from(lessons.map((x) => x.toJson())),
  };
}
