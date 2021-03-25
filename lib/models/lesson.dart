import 'dart:convert';

Lesson lessonFromJson(String str) => Lesson.fromJson(json.decode(str));

String lessonToJson(Lesson data) => json.encode(data.toJson());

class Lesson {
  Lesson({
    this.id,
    this.courseId,
    this.title,
    this.number,
    this.duration,
    this.videoUrl,
    this.textContent,
  });

  int id;
  int courseId;
  String title;
  int number;
  int duration;
  String videoUrl;
  String textContent;

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
    id: json["id"],
    courseId: json["course_id"],
    title: json["title"],
    number: json["number"],
    duration: json["duration"],
    videoUrl: json["video_url"],
    textContent: json["text_content"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "course_id": courseId,
    "title": title,
    "number": number,
    "duration": duration,
    "video_url": videoUrl,
    "text_content": textContent,
  };
}
