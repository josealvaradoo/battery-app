import 'package:battery/components/auth/login_form.dart';
import 'package:battery/components/logo/logo.dart';
import 'package:battery/theme.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

const double padding = 16.0;

class AnimatedDialog extends StatefulWidget {
  const AnimatedDialog({super.key});

  @override
  State<AnimatedDialog> createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    // Inicializar el controlador de animación
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Definir la animación de desplazamiento
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Comienza desde abajo (fuera de la pantalla)
      end: Offset.zero, // Termina en la posición original
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut, // Efecto de aceleración suave
    ));

    // Iniciar la animación
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Diálogo animado
        Align(
          alignment: Alignment.bottomCenter,
          child: SlideTransition(
            position: _offsetAnimation,
            child: const Dialog(),
          ),
        ),
      ],
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
      padding: const EdgeInsets.all(padding),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35), topRight: Radius.circular(35)),
      ),
      child: const Column(children: [
        SizedBox(height: 20),
        Logo(),
        SizedBox(height: 30),
        LoginForm()
      ]),
    );
  }
}

class Button extends StatelessWidget {
  final VoidCallback onPressed;
  const Button({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
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
          child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Icon(HugeIcons.strokeRoundedMail01, color: Colors.black),
                Text('Continuar con Email', style: TextStyle(fontSize: 16))
              ]),
        ));
  }
}
