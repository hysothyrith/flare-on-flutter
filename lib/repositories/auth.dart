import 'package:flare/models/auth_response.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Auth {
  final baseUrl = "http://10.0.2.2:8000/api/auth";

  Future<bool> signIn({String email, String password}) async {
    http.Response response = await http
        .post("$baseUrl/login", body: {'email': email, 'password': password});

    if (response.statusCode == 200) {
      AuthResponse authResponse =
          await compute(authResponseFromJson, response.body);
      await _saveCredentials(authResponse);
      return true;
    } else {
      return false;
    }
  }

  Future<AuthResponse> signUp(
      {String name,
      String email,
      String password,
      String passwordConfirmation}) async {
    http.Response response = await http.post("$baseUrl/register", body: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation
    });

    if (response.statusCode == 200) {
      return compute(authResponseFromJson, response.body);
    } else {
      throw Exception("Sign up failed");
    }
  }

  Future<bool> verifyExistingCredentials() async {
    final storage = new FlutterSecureStorage();

    String token = await storage.read(key: 'token');
    if (token == null) {
      return false;
    }
    DateTime tokenExpiryDate =
        DateTime.parse(await storage.read(key: 'tokenExpiryDate'));
    if (tokenExpiryDate.isBefore(DateTime.now())) {
      storage.delete(key: 'token');
      storage.delete(key: 'tokenExpiryDate');
      return false;
    }
    return true;
  }

  Future<void> _saveCredentials(AuthResponse response) async {
    final storage = new FlutterSecureStorage();
    print("Saving token...");
    storage.write(key: 'token', value: response.accessToken).then((value) {
      print("Token saved");

      print("Saving token expiry date...");
      DateTime now = DateTime.now();
      DateTime tokenExpiryDate = now.add(Duration(minutes: response.expiresIn));
      storage.write(key: 'tokenExpiryDate', value: tokenExpiryDate.toString());
      print("Token expiry date saved");
    });
  }
}
