import 'package:battery/services/google_auth.service.dart';
import 'package:battery/utils/dialog_utils.dart';
import 'package:battery/utils/localstorage.dart';
import 'package:battery/views/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoogleAuthButton extends StatefulWidget {
  const GoogleAuthButton({
    super.key,
  });

  @override
  State<GoogleAuthButton> createState() => _GoogleAuthButtonState();
}

class _GoogleAuthButtonState extends State<GoogleAuthButton> {
  void _onRedirect() {
    Get.off(() => const HomeView(),
        transition: Transition.circularReveal,
        duration: const Duration(seconds: 1),
        curve: Curves.linear.flipped);
  }

  Future<void> _onSubmit() async {
    final LocalStorage storage = LocalStorage();
    final GoogleAuthService googleAuthService = GoogleAuthService();
    final String? token = await googleAuthService.signIn();

    if (token == null) {
      if (!mounted) return;

      showPlatformDialog(context, 'Autenticación fallida',
          'Tu cuenta no está autorizada para acceder.');

      return;
    }

    await storage.set("token", token);
    _onRedirect();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            onPressed: _onSubmit,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Image.asset(
                    'assets/images/google.png',
                    height: 18,
                    width: 18,
                  ),
                  const Text('Ingresar con Google',
                      style: TextStyle(color: Colors.black, fontSize: 16))
                ])));
  }
}
