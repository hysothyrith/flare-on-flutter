import 'package:flare/models/lesson.dart';
import 'package:flare/repositories/api_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LessonRepo extends ApiRepository {
  LessonRepo() : super(baseUrlPostfix: "lessons");

  Future<Lesson> get(int id) async {
    http.Response response =
        await http.get("$baseUrl/$id", headers: await tokenHeader);

    if (response.statusCode == 200) {
      print("GET /lessons/$id successful. Computing response...");
      return compute(lessonFromJson, response.body);
    } else {
      print(response.body);
      throw Exception("GET /lessons/$id failed");
    }
  }
//
// Future<Note> getNote(int lessonId) async {
//   http.Response response =
//       await http.get("$baseUrl/$lessonId/note", headers: await tokenHeader);
//
//   if (response.statusCode == 200) {
//     print("GET /lessons/$lessonId/note successful. Computing response...");
//     return compute(noteFromJson, response.body);
//   } else if (response.statusCode == 204) {
//     print("GET /lessons/$lessonId/note returns no content");
//     return null;
//   } else {
//     throw Exception("GET /lessons/$lessonId/note failed");
//   }
// }
//
// Future<bool> createNote(int lessonId, {String noteContent}) async {
//   http.Response response = await http.post("$baseUrl/$lessonId/note",
//       body: {'note_content': noteContent}, headers: await tokenHeader);
//
//   if (response.statusCode == 201) {
//     print("POST /lessons/$lessonId/note successful");
//     return true;
//   } else {
//     throw Exception("POST /lessons/$lessonId/note failed");
//   }
// }
}
