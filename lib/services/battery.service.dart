import 'dart:async';
import 'dart:convert';
import 'package:battery/constants.dart';
import 'package:battery/utils/localstorage.dart';
import 'package:battery/utils/retry.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:http/http.dart' as http;
import 'package:battery/models/response.dart';
import 'package:battery/models/battery.dart';

class BatteryService {
  String url = "$apiUrl/status";

  // Get the battery value from the server through a GET request.
  Future<Battery> getBatteryLevel() async {
    try {
      final LocalStorage storage = LocalStorage();
      final String token = await storage.get("token");
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };
      final response = await retry(
        () async => await http.get(Uri.parse(url), headers: headers),
        maxAttempts: 3,
      );

      if (response.statusCode != 200) {
        return Battery(level: 0, isCharging: true);
      }

      final json = jsonDecode(response.body);
      final data = Response.fromJson(json);
      final Battery battery = Battery.fromJson(data.data);

      return battery;
    } catch (e) {
      return Battery(level: 0, isCharging: true);
    }
  }

  // Subscribe to a Server Side Event stream and get the battery level
  // from the server. First the cached value and then the live value.
  Future<void> getBatteryLevelStream(callback) async {
    Battery battery;

    // Suibscribe to a Server Side Event stream and listen for events
    SSEClient.subscribeToSSE(
        method: SSERequestType.GET,
        url: "$url/stream",
        header: {
          "Accept": "text/event-stream",
          "Cache-Control": "no-cache",
        }).listen((event) {
      final json = jsonDecode(event.data.toString());

      if (json["data"] != null) {
        battery = Battery.fromJson(json["data"]);
        callback(battery, json["is_cached"]);
      }
    }, onDone: () {
      SSEClient.unsubscribeFromSSE();
    }, onError: (error) {
      SSEClient.unsubscribeFromSSE();
      callback(Battery(level: 0, isCharging: false), false);
    });
  }
}
