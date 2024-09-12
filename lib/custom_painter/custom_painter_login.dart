import 'package:flutter/material.dart';

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Layer 1
    Paint paint_fill_0 = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color.fromARGB(255, 117, 198, 25),
          Color.fromARGB(255, 177, 238, 108),
        ],
        stops: [0.0, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.9975000);
    path_0.quadraticBezierTo(size.width * 0.1363500, size.height * 0.7219500,
        size.width * 0.7425000, size.height * 0.7725000);
    path_0.quadraticBezierTo(size.width * 0.9241750, size.height * 0.7744750,
        size.width * 1.0064000, size.height * 0.6891750);
    path_0.lineTo(size.width * 1.0019500, size.height * -0.0047250);
    path_0.lineTo(size.width * -0.0091750, size.height * -0.0041750);

    canvas.drawPath(path_0, paint_fill_0);

    // Layer 1

    Paint paint_stroke_0 = Paint()
      ..color = const Color.fromARGB(0, 33, 150, 243)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(path_0, paint_stroke_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
