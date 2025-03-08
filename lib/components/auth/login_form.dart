import 'package:battery/services/auth.service.dart';
import 'package:battery/theme.dart';
import 'package:battery/utils/localstorage.dart';
import 'package:battery/views/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _errorMessage = "";
  bool isDisabled = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _onRedirect() {
    Get.off(() => const HomeView(),
        transition: Transition.circularReveal,
        duration: const Duration(seconds: 1),
        curve: Curves.linear.flipped);
  }

  Future<String?> _onAuth() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final AuthService service = AuthService();
    final LocalStorage storage = LocalStorage();

    final String? token = await service.login(username, password);

    if (token == null) {
      setState(() {
        isDisabled = false;
        _errorMessage = "username o contraseña incorrectos";
      });
      return null;
    }

    setState(() {
      isDisabled = false;
    });
    await storage.set("token", token);
    return token;
  }

  Future<void> _onSubmit() async {
    if (isDisabled) {
      return;
    }

    setState(() {
      _errorMessage = "";
      isDisabled = true;
    });

    final String? token = await _onAuth();

    if (token != null && mounted) {
      _onRedirect();
    }
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
                backgroundColor: isDisabled
                    ? const Color(EverforestTheme.shadowGray)
                    : const Color(EverforestTheme.deepSlate),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onPressed: _onSubmit,
              child: !isDisabled
                  ? const Text('Ingresar',
                      style: TextStyle(color: Colors.white, fontSize: 16))
                  : Lottie.asset(
                      'assets/lottie/loader.json',
                      repeat: true,
                      height: 50,
                      fit: BoxFit.fitHeight,
                      delegates: LottieDelegates(
                        values: [
                          ValueDelegate.color(
                            const ['**'],
                            value: Colors.grey,
                          ),
                        ],
                      ),
                    ),
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
