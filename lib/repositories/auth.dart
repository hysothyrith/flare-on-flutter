import 'package:flare/models/auth_response.dart';
import 'package:flare/repositories/api_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthRepo extends ApiRepository {
  AuthRepo() : super(baseUrlPostfix: "auth");

  Future<bool> signIn({String email, String password}) async {
    http.Response response = await http
        .post("$baseUrl/login", body: {'email': email, 'password': password});

    if (response.statusCode == 200) {
      print("Sign in successful. Computing response...");
      AuthResponse authResponse =
          await compute(authResponseFromJson, response.body);
      print("Saving credentials...");
      await _saveCredentials(authResponse);
      return true;
    } else {
      print("Sign in failed");
      print(response.body);
      return false;
    }
  }

  Future<bool> signUp(
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
      print("Sign up successful. Computing response...");
      AuthResponse authResponse =
          await compute(authResponseFromJson, response.body);
      print("Saving credentials...");
      await _saveCredentials(authResponse);
      return true;
    } else {
      print("Sign up failed");
      print(response.body);
      return false;
    }
  }

  signOut() async {
    await _clearLocalCredentials();
  }

  Future<bool> verifyLocalCredentials() async {
    print("Verifying local credentials...");

    if (await localToken == null) {
      print("No local token");
      return false;
    }

    if ((await localTokenExpiryDate).isBefore(DateTime.now())) {
      print("Local token expired");
      _clearLocalCredentials();
      return false;
    }
    print("Local credentials verification successful");
    return true;
  }

  Future<void> _saveCredentials(AuthResponse response) async {
    print("Saving token...");
    _setLocalToken(response.accessToken).then((value) {
      print("Token saved");

      print("Saving token expiry date...");
      DateTime now = DateTime.now();
      DateTime tokenExpiryDate = now.add(Duration(minutes: response.expiresIn));
      _setLocalTokenExpiryDate(tokenExpiryDate);
      print("Token expiry date saved");
    });
  }

  Future<void> _clearLocalCredentials() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'tokenExpiryDate');
  }

  Future<void> _setLocalToken(String token) =>
      storage.write(key: 'token', value: token);

  Future<void> _setLocalTokenExpiryDate(DateTime expiryDate) =>
      storage.write(key: 'tokenExpiryDate', value: expiryDate.toString());
}
