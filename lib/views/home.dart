import 'dart:async';

import 'package:battery/services/auth.service.dart';
import 'package:battery/theme.dart';
import 'package:battery/utils/localstorage.dart';
import 'package:battery/views/login.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:battery/models/battery.dart';
import 'package:battery/components/battery/battery.dart';
import 'package:battery/services/battery.service.dart';
import 'package:get/get.dart';
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

    final String token = await storage.get("token");

    if (token == "" && mounted) {
      Get.off(() => LoginView());
      return;
    }

    final bool isVerified = await service.verify(token);

    if (!isVerified && mounted) {
      Get.off(() => LoginView());
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
    Get.off(() => LoginView(),
        duration: const Duration(milliseconds: 500),
        transition: Transition.leftToRightWithFade,
        curve: Curves.linear.flipped);
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
    final double padding = (MediaQuery.of(context).size.height - 650) / 2;
    final double leftPosition = (MediaQuery.of(context).size.width - 200) / 2;

    return Scaffold(
      backgroundColor: const Color(EverforestTheme.deepSlate),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        leading: Container(),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarBrightness: Brightness.light,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            decoration: BoxDecoration(
              color: const Color(EverforestTheme.pineGreen),
              borderRadius: BorderRadius.circular(100),
            ),
            child: IconButton(
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedLogout02,
                  color: Colors.white,
                ),
                onPressed: _onLogout),
          )
        ],
      ),
      body: Center(
          child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: Stack(
                children: _isAuthenticated
                    ? <Widget>[
                        Positioned(
                            bottom: 50,
                            left: leftPosition,
                            child: _isLoading
                                ? Lottie.asset(
                                    'assets/lottie/loader.json',
                                    repeat: true,
                                    height: 200,
                                    fit: BoxFit.fitHeight,
                                    delegates: LottieDelegates(
                                      values: [
                                        ValueDelegate.color(
                                          const ['**'],
                                          value: const Color(
                                              EverforestTheme.pineGreen),
                                        ),
                                      ],
                                    ),
                                  )
                                : Transform.flip(
                                    flipY: _isCharging,
                                    child: Lottie.asset(
                                        'assets/lottie/arrows.json',
                                        repeat: true,
                                        height: 200,
                                        fit: BoxFit.fitHeight,
                                        delegates: LottieDelegates(
                                          values: [
                                            ValueDelegate.color(
                                              const ['**'],
                                              value: const Color(
                                                  EverforestTheme.pineGreen),
                                            ),
                                          ],
                                        )))),
                        ListView(
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top: padding)),
                            BatteryWidget(level: _batteryLevel),
                          ],
                        ),
                      ]
                    : [],
              ))),
    );
  }
}
