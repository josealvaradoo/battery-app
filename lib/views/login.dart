import 'package:battery/components/auth/login_form.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Padding(padding: EdgeInsets.all(16.0), child: LoginForm()),
    );
  }
}
