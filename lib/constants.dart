import 'package:flutter_dotenv/flutter_dotenv.dart';

const String apiUrlFallback = "http://localhost:8080";
String get apiUrl => dotenv.env['API_URL'] ?? apiUrlFallback;
