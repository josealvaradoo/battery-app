import 'dart:convert';

import 'package:battery/constants.dart';
import 'package:battery/models/user.dart';
import 'package:battery/utils/localstorage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  String url = "$apiUrl/auth";
  final Map<String, String> headers = {"Content-Type": "application/json"};

  Future<String?> signIn(String username, String password) async {
    final Map<String, String> body = {
      "username": username,
      "password": password
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      return null;
    }

    final json = jsonDecode(response.body);

    return json["token"];
  }

  Future<String?> signInWithGoogle(String idToken) async {
    final response = await http.post(
      Uri.parse("$url/google"),
      headers: headers,
      body: jsonEncode({'token': idToken}),
    );

    if (response.statusCode != 200) {
      return null;
    }

    final json = jsonDecode(response.body);

    return json['token'];
  }

  Future<bool> checkAuth(String token) async {
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
    final response = await http.get(Uri.parse("$url/verify"), headers: headers);

    if (response.statusCode != 200) {
      return false;
    }

    return true;
  }

  Future<User> getProfile() async {
    final LocalStorage storage = LocalStorage();
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await storage.get("token")}"
    };
    final response =
        await http.get(Uri.parse("$url/profile"), headers: headers);
    final json = jsonDecode(response.body);

    return User.fromJson(json["data"]);
  }

  Future<void> logout() async {
    final LocalStorage storage = LocalStorage();
    await storage.deleteAll();
  }
}
