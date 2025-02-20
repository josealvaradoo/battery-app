import 'dart:async';

import 'package:flutter/material.dart';
import 'package:battery/models/battery.dart';
import 'package:battery/components/battery/battery.dart';
import 'package:battery/services/battery.service.dart';
import 'package:lottie/lottie.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _isCharging = true;
  bool _isLoading = true;
  int _batteryLevel = 0;
  BatteryService batteryService = BatteryService();

  Future<void> _getBatteryLevelHttp() async {
    Battery status = await batteryService.getBatteryLevel();

    setState(() {
      _isLoading = false;
      _isCharging = status.isCharging;
      _batteryLevel = status.level;
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    await _getBatteryLevelHttp();
  }

  @override
  void initState() {
    super.initState();
    _getBatteryLevelHttp();
  }

  @override
  Widget build(BuildContext context) {
    final double padding = (MediaQuery.of(context).size.height - 500) / 2;
    final double leftPosition = (MediaQuery.of(context).size.width - 200) / 2;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
       leading: IconButton(icon: Icon(IconData.), onPressed: () => Navigator.pop(context)),
        ),
      body: Center(
          child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: Stack(
                children: <Widget>[
                  Positioned(
                      bottom: 50,
                      left: leftPosition,
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
                              ))),
                  ListView(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top: padding)),
                      BatteryWidget(level: _batteryLevel),
                    ],
                  ),
                ],
              ))),
    );
  }
}
