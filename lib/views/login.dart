import 'package:battery/components/auth/login_form.dart';
import 'package:battery/services/auth.service.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key}) {
    // Remove previous user data saved in local storage
    AuthService auth = AuthService();
    auth.logout();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Padding(padding: EdgeInsets.all(16.0), child: LoginForm()),
    );
  }
}
