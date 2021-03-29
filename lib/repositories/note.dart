import 'package:flare/models/note.dart';
import 'package:flare/repositories/api_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NoteRepo extends ApiRepository {
  NoteRepo() : super(baseUrlPostfix: "notes");

  Future<Note> getByLessonId(int lessonId) async {
    final uri = createUriWithQuery({'lesson_id': lessonId});
    final response = await http.get(uri, headers: await tokenHeader);

    if (response.statusCode == 200) {
      print("GET /notes?lesson_id=$lessonId successful");
      return compute(noteFromJson, response.body);
    } else if (response.statusCode == 204) {
      print("GET /notes?lesson_id=$lessonId returns no content");
      return Note();
    } else {
      print(response.body);
      throw Exception("GET /notes?lesson_id=$lessonId failed");
    }
  }

  Future<void> create({int lessonId, String content}) async {
    final response = await http.post("$baseUrl",
        body: {'lesson_id': lessonId.toString(), 'note_content': content},
        headers: await tokenHeader);

    if (response.statusCode == 201) {
      print("POST /notes successful");
    } else {
      print(response.body);
      throw Exception("POST /notes failed");
    }
  }

  Future<void> updateContent({int id, String content}) async {
    final response = await http.patch("$baseUrl/$id",
        body: {'note_content': content}, headers: await tokenHeader);

    if (response.statusCode == 200) {
      print("UPDATE /notes/$id successful");
    } else {
      print(response.body);
      throw Exception("UPDATE /notes/$id failed");
    }
  }

  Future<void> delete(int id) async {
    final response =
        await http.delete("$baseUrl/$id", headers: await tokenHeader);

    if (response.statusCode == 200) {
      print("DELETE /notes/$id successful");
    } else {
      throw Exception("DELETE /notes/$id failed");
    }
  }
}
