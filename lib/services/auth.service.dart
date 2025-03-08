import 'dart:convert';

import 'package:battery/utils/localstorage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  String apiUrl = "https://growatt-scrapping-production.up.railway.app/auth";

  Future<String?> login(String username, String password) async {
    final Map<String, String> headers = {"Content-Type": "application/json"};
    final Map<String, String> body = {
      "username": username,
      "password": password
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      return null;
    }

    final json = jsonDecode(response.body);

    return json["token"];
  }

  Future<bool> verify(String token) async {
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    };
    final url = Uri.parse("$apiUrl/verify");
    final response = await http.get(url, headers: headers);

    if (response.statusCode != 200) {
      return false;
    }

    return true;
  }

  Future<void> logout() async {
    final LocalStorage storage = LocalStorage();
    await storage.deleteAll();
  }
}
