import 'package:battery/models/user.dart';
import 'package:battery/services/auth.service.dart';
import 'package:flutter/material.dart';

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
      Navigator.pushNamed(context, "/");
    }
  }

  Future<User?> _onSubmit() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final AuthService service = AuthService();

    final User? user = await service.login(username, password);

    if (user == null) {
      setState(() {
        _errorMessage = "username o contraseña incorrectos";
      });
      return null;
    }

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
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: Center(
              child: Image.asset("assets/images/rufus.png"),
            )),
        const SizedBox(height: 20),
        TextFormField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _passwordController,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        if (_errorMessage.isNotEmpty)
          Column(children: [
            const SizedBox(height: 20),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
            )
          ]),
        const SizedBox(height: 20),
        SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
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
