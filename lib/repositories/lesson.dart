import 'package:flare/models/lesson.dart';
import 'package:flare/repositories/api.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class LessonRepo extends ApiRepo {
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
}
