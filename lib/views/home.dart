import 'dart:async';

import 'package:battery/components/avatar/avatar.dart';
import 'package:battery/components/wrapper/lifecycle_handler.dart';
import 'package:battery/models/user.dart';
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
  late User _user;
  bool _userIsReady = false;
  BatteryService batteryService = BatteryService();

  Future<void> _validateAuthtentication() async {
    final LocalStorage storage = LocalStorage();
    final AuthService service = AuthService();

    final String token = await storage.get("token");

    if (token == "" && mounted) {
      Get.off(() => LoginView());
      return;
    }

    final bool isVerified = await service.checkAuth(token);

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

  Future<void> _fetchUserData() async {
    final AuthService service = AuthService();

    final User user = await service.getProfile();

    setState(() {
      _user = user;
      _userIsReady = true;
    });
  }

  void _init() async {
    await _validateAuthtentication();
    await _fetchUserData();
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

    if (!_userIsReady) {
      return Scaffold(
          backgroundColor: const Color(EverforestTheme.deepSlate),
          appBar: AppBar(
            toolbarHeight: 50,
            backgroundColor: Colors.transparent,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 8,
                children: [
                  Container(
                      decoration: const BoxDecoration(
                          color: Color(EverforestTheme.stormGray)),
                      width: 24,
                      height: 24),
                  Container(
                      decoration: const BoxDecoration(
                          color: Color(EverforestTheme.stormGray)),
                      width: 200,
                      height: 16),
                ]),
            centerTitle: false,
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
          body: const Center());
    }

    return AppLifecycleHandler(
        onResumed: () {
          _onRefresh();
        },
        child: Scaffold(
          backgroundColor: const Color(EverforestTheme.deepSlate),
          appBar: AppBar(
            toolbarHeight: 50,
            backgroundColor: Colors.transparent,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 8,
                children: [
                  Avatar(src: _user.picture),
                ]),
            centerTitle: false,
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
                                                      EverforestTheme
                                                          .pineGreen),
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
        ));
  }
}
