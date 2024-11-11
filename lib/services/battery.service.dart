import 'dart:convert';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:http/http.dart' as http;
import 'package:battery/models/response.dart';
import 'package:battery/models/battery.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BatteryService {
  String apiUrl = "${dotenv.env['API_URL']!}/status";

  Future<Battery> getBatteryLevel() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode != 200) {
        return Battery(level: 0, isCharging: true);
      }

      final json = jsonDecode(response.body);
      final data = Response.fromJson(json);
      final Battery battery = Battery.fromJson(data.data);

      return battery;
    } catch (e) {
      print("ERROR Getting Battery Level: ${e.toString()}");
      return Battery(level: 0, isCharging: true);
    }
  }

  Future<void> getBatteryLevelStream(callback) async {
    Battery battery;

    try {
      SSEClient.subscribeToSSE(
          method: SSERequestType.GET,
          url: "$apiUrl/stream",
          header: {
            "Accept": "text/event-stream",
            "Cache-Control": "no-cache",
          }).listen(
        (event) {
          final json = jsonDecode(event.data.toString());

          if (json["data"] != null) {
            battery = Battery.fromJson(json["data"]);
            callback(battery, json["is_cached"]);
          }
        },
      ).onError((error) {
        callback(Battery(level: 0, isCharging: false), false);
        print("Error: $error");
      });
    } catch (e) {
      print("ERROR Getting Battery Level: ${e.toString()}");
    }
  }
}
