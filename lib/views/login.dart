import 'package:battery/components/auth/google_button.dart';
import 'package:battery/components/auth/login_dialog.dart';
import 'package:battery/services/auth.service.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key}) {
    // Remove previous user data saved in local storage
    AuthService auth = AuthService();
    auth.logout();
  }

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isOpen = false;

  void showDialog() {
    setState(() {
      _isOpen = true;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        alignment: Alignment.bottomCenter,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/house.jpg'),
            fit: BoxFit.fitHeight,
            scale: 1.0,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
        child: SizedBox(
            child: _isOpen
                ? const AnimatedDialog()
                : Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const GoogleAuthButton(),
                          const SizedBox(height: 10),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 10,
                              children: [
                                Container(
                                  width: 100,
                                  height: 1,
                                  color: Colors.white,
                                ),
                                const Text("o",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
                                Container(
                                  width: 100,
                                  height: 1,
                                  color: Colors.white,
                                ),
                              ]),
                          const SizedBox(height: 10),
                          Button(onPressed: showDialog)
                        ]))),
      ),
    ));
  }
}
