import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:battery/models/battery.dart';
import 'package:battery/components/battery/battery.dart';
import 'package:battery/services/battery.service.dart';
import 'package:lottie/lottie.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const MyHomePage(title: 'battery Battery Level'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isCharging = true;
  bool _isLoading = true;
  int _batteryLevel = 0;
  BatteryService batteryService = BatteryService();

  Future<void> _getBatteryLevelStream() async {
    await batteryService.getBatteryLevelStream((Battery value, bool isCached) {
      setState(() {
        _isLoading = isCached;
        _isCharging = value.isCharging;
        _batteryLevel = value.level;
      });
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    await _getBatteryLevelStream();
  }

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final double padding = (MediaQuery.of(context).size.height - 500) / 2;
    final double leftPosition = (MediaQuery.of(context).size.width - 200) / 2;

    return Scaffold(
        body: Center(
      child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: Expanded(
              child: Stack(
            children: <Widget>[
              Positioned(
                  bottom: 50,
                  left: leftPosition,
                  child: Expanded(
                      child: _isLoading
                          ? Lottie.asset('assets/lottie/loader.json',
                              repeat: true, height: 200, fit: BoxFit.fitHeight)
                          : Transform.flip(
                              flipY: _isCharging,
                              child: Lottie.asset(
                                'assets/lottie/arrows.json',
                                repeat: true,
                                height: 200,
                                fit: BoxFit.fitHeight,
                              )))),
              ListView(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: padding)),
                  BatteryWidget(level: _batteryLevel),
                ],
              ),
            ],
          ))),
    ));
  }
}
