import 'dart:async';
import 'package:battery/theme.dart';
import 'package:flutter/material.dart';

const opacity = 1.0;

const Map<String, Color> colors = {
  "low": Color(EverforestTheme.redAccent),
  "medium": Color(EverforestTheme.yellowAccent),
  "high": Color(EverforestTheme.greenAccent),
};

class BatteryWidget extends StatefulWidget {
  final int level;
  final bool isEmpty;
  const BatteryWidget({super.key, required this.level, this.isEmpty = false})
      : super();

  @override
  BatteryState createState() => BatteryState();
}

class BatteryState extends State<BatteryWidget> with TickerProviderStateMixin {
  late AnimationController _firstController;
  late Animation _firstAnimation;

  late AnimationController _secondController;
  late Animation _secondAnimation;

  late AnimationController _thirdController;
  late Animation _thirdAnimation;

  late AnimationController _fourthController;
  late Animation _fourthAnimation;

  Color color = colors["high"]!;

  @override
  void initState() {
    super.initState();

    _firstController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));

    _firstAnimation = Tween<double>(begin: 1.9, end: 2.1).animate(
        CurvedAnimation(parent: _firstController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _firstController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _firstController.forward();
        }
      });

    _secondController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));

    _secondAnimation = Tween<double>(begin: 1.8, end: 2.4).animate(
        CurvedAnimation(parent: _secondController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _secondController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _secondController.forward();
        }
      });

    _thirdController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));

    _thirdAnimation = Tween<double>(begin: 1.8, end: 2.4).animate(
        CurvedAnimation(parent: _thirdController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _thirdController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _thirdController.forward();
        }
      });

    _fourthController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));

    _fourthAnimation = Tween<double>(begin: 1.9, end: 2.1).animate(
        CurvedAnimation(parent: _fourthController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _fourthController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _fourthController.forward();
        }
      });

    Timer(const Duration(seconds: 2), () {
      _firstController.forward();
    });

    Timer(const Duration(milliseconds: 1600), () {
      _secondController.forward();
    });

    Timer(const Duration(milliseconds: 800), () {
      _thirdController.forward();
    });

    _fourthController.forward();
  }

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    _thirdController.dispose();
    _fourthController.dispose();
    super.dispose();
  }

  void setColor(int level) {
    setState(() {
      if (level < 30) {
        color = colors["low"]!;
      } else if (level < 50) {
        color = colors["medium"]!;
      } else {
        color = colors["high"]!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const double maxHeight = 300;
    final double containerHeight = maxHeight * (widget.level / 100);
    const double painterHeight = 50;

    setColor(widget.level);

    return Column(children: [
      Container(
        width: 80,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
          color: widget.isEmpty
              ? Colors.black12
              : widget.level < 100
                  ? const Color(EverforestTheme.pineGreen)
                  : colors["high"]!,
        ),
      ),
      Container(
        width: 200,
        height: 300,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: widget.isEmpty
              ? Colors.black12
              : const Color(EverforestTheme.pineGreen),
        ),
        child: Stack(alignment: AlignmentDirectional.center, children: <Widget>[
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            !widget.isEmpty && containerHeight < 250
                ? CustomPaint(
                    painter: MyPainter(
                        _firstAnimation.value,
                        _secondAnimation.value,
                        _thirdAnimation.value,
                        _fourthAnimation.value,
                        color),
                    child: const SizedBox(
                      height: painterHeight,
                      width: 200,
                    ))
                : Container(),
            Container(
              width: 200,
              height: containerHeight,
              decoration: BoxDecoration(
                color: Color(color.value).withOpacity(opacity),
              ),
            )
          ]),
          Text("${widget.level.toString()}%",
              style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 48,
                  fontWeight: FontWeight.bold)),
        ]),
      ),
    ]);
  }
}

class MyPainter extends CustomPainter {
  final double firstValue;
  final double secondValue;
  final double thirdValue;
  final double fourthValue;
  Color color = colors["high"]!;

  MyPainter(
    this.firstValue,
    this.secondValue,
    this.thirdValue,
    this.fourthValue,
    this.color,
  );

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Color(color.value).withOpacity(opacity)
      ..style = PaintingStyle.fill;

    var path = Path()
      ..moveTo(0, size.height / firstValue)
      ..cubicTo(size.width * .4, size.height / secondValue, size.width * .7,
          size.height / thirdValue, size.width, size.height / fourthValue)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
