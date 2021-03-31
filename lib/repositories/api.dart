import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class ApiRepo {
  final storage = new FlutterSecureStorage();
  final absoluteBaseUrl = "http://10.0.2.2:8000/api";
  final String baseUrlPostfix;

  ApiRepo({this.baseUrlPostfix = ""});

  String get baseUrl => "$absoluteBaseUrl/$baseUrlPostfix";

  Future<String> get localToken async {
    return await storage.read(key: "token");
  }

  Future<DateTime> get localTokenExpiryDate async {
    return DateTime.parse(await storage.read(key: 'tokenExpiryDate'));
  }

  Future<Map<String, String>> get tokenHeader async {
    return {'Authorization': "bearer ${await localToken}"};
  }

  Uri createUriWithQuery(Map<String, dynamic> queryParams) {
    return Uri.http("10.0.2.2:8000", "api/$baseUrlPostfix",
        _createQueryParams(queryParams));
  }

  Map<String, String> _createQueryParams(Map<String, dynamic> params) {
    var query = new Map<String, String>();
    params.forEach((key, value) {
      if (value != null) {
        if (value is bool) {
          query[key] = value ? '1' : '0';
        } else {
          query[key] = value.toString();
        }
      }
    });
    return query;
  }
}
