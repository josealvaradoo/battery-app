import 'dart:convert';
import 'package:battery/models/user.dart';
import 'package:battery/services/auth.service.dart';
import 'package:battery/theme.dart';
import 'package:battery/utils/localstorage.dart';
import 'package:battery/views/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _errorMessage = "";
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _onRedirect(BuildContext? context) {
    if (context != null) {
      Get.off(() => const HomeView(),
          transition: Transition.circularReveal,
          duration: const Duration(seconds: 1),
          curve: Curves.linear.flipped);
    }
  }

  Future<User?> _onSubmit() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final AuthService service = AuthService();
    final LocalStorage storage = LocalStorage();

    final User? user = await service.login(username, password);

    if (user == null) {
      setState(() {
        _errorMessage = "username o contraseña incorrectos";
      });
      return null;
    }

    await storage.set("user", jsonEncode(user.toJson()));
    return user;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _errorMessage = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: CustomInput(
                controller: _usernameController,
                error: _errorMessage.isNotEmpty,
                label: 'Username')),
        const SizedBox(height: 20),
        Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: CustomInput(
                controller: _passwordController,
                error: _errorMessage.isNotEmpty,
                obscureText: true,
                label: 'Password')),
        const SizedBox(height: 20),
        if (_errorMessage.isNotEmpty)
          Text(_errorMessage,
              style: const TextStyle(color: Color(EverforestTheme.redAccent))),
        const SizedBox(height: 20),
        SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(EverforestTheme.deepSlate),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onPressed: () async {
                final User? user = await _onSubmit();
                if (user != null && mounted) {
                  _onRedirect(mounted ? context : null);
                }
              },
              child: const Text('Ingresar',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            )),
      ],
    );
  }
}

class CustomInput extends StatelessWidget {
  final bool error;
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  const CustomInput(
      {super.key,
      required this.error,
      required this.label,
      this.obscureText = false,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
                borderSide: BorderSide(
              color: error
                  ? const Color(EverforestTheme.redAccent)
                  : const Color(EverforestTheme.pineGreen),
            )),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
              color: error
                  ? const Color(EverforestTheme.redAccent)
                  : const Color(EverforestTheme.pineGreen),
            ))));
  }
}
