import 'dart:convert';

import 'package:battery/models/response.dart';
import 'package:battery/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  String apiUrl = "${dotenv.env['API_URL']!}/auth";

  Future<User?> login(String username, String password) async {
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
    final data = Response.fromJson(json);
    final User user = User.fromJson(data.data);

    return user;
  }
}
