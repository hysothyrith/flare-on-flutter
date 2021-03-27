import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class ApiRepository {
  final storage = new FlutterSecureStorage();
  final String baseUrlPostfix;

  ApiRepository({this.baseUrlPostfix = ""});

  get baseUrl => "http://10.0.2.2:8000/api/$baseUrlPostfix";

  Future<String> get localToken async {
    return await storage.read(key: "token");
  }

  Future<DateTime> get localTokenExpiryDate async {
    return DateTime.parse(await storage.read(key: 'tokenExpiryDate'));
  }

  Future<Map<String, String>> getTokenHeader() async {
    return {'Authorization': "bearer ${await localToken}"};
  }
}
