import 'package:flare/models/course.dart';
import 'package:flare/models/course_summary.dart';
import 'package:flare/repositories/api_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class CourseRepo extends ApiRepository {
  CourseRepo() : super(baseUrlPostfix: "courses");

  Future<List<CourseSummary>> getAll() async {
    http.Response response =
        await http.get(baseUrl, headers: await getTokenHeader());

    if (response.statusCode == 200) {
      print("GET /courses successful. Computing response...");
      return compute(courseSummaryFromJson, response.body);
    } else {
      print(response.body);
      throw Exception("GET /courses failed");
    }
  }

  Future<Course> get(int id) async {
    http.Response response =
        await http.get("$baseUrl/$id", headers: await getTokenHeader());

    if (response.statusCode == 200) {
      print("GET /courses/$id successful. Computing response...");
      return compute(courseFromJson, response.body);
    } else {
      print(response.body);
      throw Exception("GET /courses/$id failed");
    }
  }
}
