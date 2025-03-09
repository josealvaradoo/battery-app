import 'package:battery/theme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SignInButton extends StatelessWidget {
  final bool isDisabled;
  final VoidCallback onPressed;

  const SignInButton(
      {super.key, required this.isDisabled, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          onPressed: onPressed,
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
        ));
  }
}
