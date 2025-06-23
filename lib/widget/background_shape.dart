import 'package:flutter/material.dart';

class BackgroundShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final topPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF6BCB77), Color(0xFFA4DD00)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, 200));

    final bottomPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFA4DD00), Color(0xFF6BCB77)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, size.height - 200, size.width, 200));

    final topPath = Path()
      ..lineTo(0, 120)
      ..quadraticBezierTo(size.width * 0.25, 80, size.width * 0.5, 110)
      ..quadraticBezierTo(size.width * 0.75, 140, size.width, 100)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(topPath, topPaint);

    final bottomPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height - 100)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height - 20,
        size.width,
        size.height - 100,
      )
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(bottomPath, bottomPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 👉 Widget pembungkus
class BackgroundShape extends StatelessWidget {
  const BackgroundShape({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: BackgroundShapePainter(),
      ),
    );
  }
}
