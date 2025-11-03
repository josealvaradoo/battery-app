import 'package:flutter_dotenv/flutter_dotenv.dart';

const String apiUrlFallback = "http://localhost:8080";
String get apiUrl => dotenv.env['API_URL'] ?? apiUrlFallback;
String get googleClientId => dotenv.env['GOOGLE_CLIENT_ID'] ?? "Not found";
String get googleServerClientId =>
    dotenv.env['GOOGLE_SERVER_CLIENT_ID'] ?? "Not found";
