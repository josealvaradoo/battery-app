import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String src;
  const Avatar({super.key, required this.src});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.network(
        src,
        width: 40,
        height: 40,
        fit: BoxFit
            .cover, // Ensures the image fills the container without distortion
      ),
    );
  }
}
