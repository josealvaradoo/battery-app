import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16.0,
        children: [
          SizedBox(
              height: 80,
              width: 80,
              child: SvgPicture.asset(
                'assets/images/logo.svg',
                semanticsLabel: 'HomeWatt',
              )),
          const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text("HomeWatt",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300)))
        ]);
  }
}
