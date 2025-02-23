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
      body: Container(
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
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Button(onPressed: showDialog))),
      ),
    );
  }
}
