import 'dart:async';
import 'dart:convert';

import 'package:battery/models/user.dart';
import 'package:battery/services/auth.service.dart';
import 'package:battery/utils/localstorage.dart';
import 'package:flutter/material.dart';
import 'package:battery/models/battery.dart';
import 'package:battery/components/battery/battery.dart';
import 'package:battery/services/battery.service.dart';
import 'package:hugeicons/hugeicons.dart';
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
  bool _isAuthenticated = false;
  BatteryService batteryService = BatteryService();

  Future<void> _validateAuthtentication() async {
    final LocalStorage storage = LocalStorage();
    final AuthService service = AuthService();

    final String value = await storage.get("user");

    if (value == "" && mounted) {
      Navigator.pushNamed(context, "/login");
      return;
    }

    final Map<String, dynamic> json = jsonDecode(value);
    final User user = User.fromJson(json);
    final String decodedPassword = utf8.decode(base64.decode(user.password));
    final User? data = await service.login(user.username, decodedPassword);

    if (data == null && mounted) {
      Navigator.pushNamed(context, "/login");
      return;
    }

    setState(() {
      _isAuthenticated = true;
    });
  }

  Future<void> _getBatteryLevelHttp() async {
    if (!_isAuthenticated) {
      return;
    }

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

  void _onLogout() {
    AuthService service = AuthService();
    service.logout();
    Navigator.pushNamed(context, "/login");
  }

  void _init() async {
    await _validateAuthtentication();
    await _getBatteryLevelHttp();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final double padding = (MediaQuery.of(context).size.height - 500) / 2;
    final double leftPosition = (MediaQuery.of(context).size.width - 200) / 2;

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          IconButton(
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedLogout02,
                color: Colors.black,
              ),
              onPressed: _onLogout),
        ],
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
