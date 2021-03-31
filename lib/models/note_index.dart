import 'dart:convert';

List<NoteIndex> noteIndexFromJson(String str) => List<NoteIndex>.from(json.decode(str).map((x) => NoteIndex.fromJson(x)));

String noteIndexToJson(List<NoteIndex> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NoteIndex {
  NoteIndex({
    this.id,
    this.course,
    this.lesson,
  });

  int id;
  String course;
  String lesson;

  factory NoteIndex.fromJson(Map<String, dynamic> json) => NoteIndex(
    id: json["id"],
    course: json["course"],
    lesson: json["lesson"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "course": course,
    "lesson": lesson,
  };
}
