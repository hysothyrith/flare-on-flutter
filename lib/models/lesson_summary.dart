import 'dart:convert';

List<LessonSummary> lessonSummaryFromJson(String str) => List<LessonSummary>.from(json.decode(str).map((x) => LessonSummary.fromJson(x)));

String lessonSummaryToJson(List<LessonSummary> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LessonSummary {
  LessonSummary({
    this.id,
    this.title,
    this.number,
    this.duration,
    this.videoUrl,
  });

  int id;
  String title;
  int number;
  int duration;
  String videoUrl;

  factory LessonSummary.fromJson(Map<String, dynamic> json) => LessonSummary(
    id: json["id"],
    title: json["title"],
    number: json["number"],
    duration: json["duration"],
    videoUrl: json["video_url"] == null ? null : json["video_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "number": number,
    "duration": duration,
    "video_url": videoUrl == null ? null : videoUrl,
  };
}
