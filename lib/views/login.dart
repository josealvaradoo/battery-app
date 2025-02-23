import 'package:battery/components/auth/login_form.dart';
import 'package:battery/services/auth.service.dart';
import 'package:battery/theme.dart';
import 'package:flutter/material.dart';

const double padding = 16.0;

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
            child: _isOpen ? const Dialog() : Button(onPressed: showDialog)),
      ),
    );
  }
}

class Dialog extends StatelessWidget {
  const Dialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,
      padding: const EdgeInsets.only(left: padding, right: padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
      ),
      child: const LoginForm(),
    );
  }
}

class Button extends StatelessWidget {
  final VoidCallback onPressed;
  const Button({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(padding),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(EverforestTheme.deepSlate),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.all(padding),
            elevation: 0,
          ),
          onPressed: onPressed,
          child: const Text('Ingresar', style: TextStyle(fontSize: 16)),
        ));
  }
}
