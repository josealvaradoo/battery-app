import 'package:battery/theme.dart';
import 'package:flutter/material.dart';

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
