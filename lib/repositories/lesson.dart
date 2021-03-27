import 'package:flare/models/lesson.dart';
import 'package:flare/repositories/api_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LessonRepo extends ApiRepository {
  LessonRepo() : super(baseUrlPostfix: "lessons");

  Future<Lesson> get(int id) async {
    http.Response response =
        await http.get("$baseUrl/$id", headers: await getTokenHeader());

    if (response.statusCode == 200) {
      print("GET /lessons/$id successful. Computing response...");
      return compute(lessonFromJson, response.body);
    } else {
      print(response.body);
      throw Exception("GET /lessons/$id failed");
    }
  }
}
