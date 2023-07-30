import 'package:flutter/material.dart';

class SelectDateBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint rRactPaint = Paint()..color = const Color(0xFFE7E9EC); // gray
    Paint pathPaint = Paint()..color = Colors.white; // white
    Paint trianglePaint = Paint()..color = const Color(0xFF091B3D);

    final BorderRadius borderRadius = BorderRadius.circular(30);
    final Rect rect = Rect.fromLTRB(0, 0, size.width, size.height);
    final RRect outer = borderRadius.toRRect(rect);

    Path path = Path();
    path.moveTo(0, 0);
    path.addRect(rect);
    path.lineTo(0, size.height);
    path.lineTo(size.width / 2, size.height - size.height / 7);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height / 7);
    path.lineTo(0, 0);
    path.close();

    Path downTriangle = Path();
    downTriangle.moveTo((size.width / 2) - 32, 0);
    downTriangle.lineTo((size.width / 2) + 32, 0);
    downTriangle.lineTo(size.width / 2, size.height / 9);
    downTriangle.lineTo((size.width / 2) - 32, 0);
    downTriangle.close();

    Path upTriangle = Path();
    upTriangle.moveTo((size.width / 2) - 32, size.height);
    upTriangle.lineTo((size.width / 2) + 32, size.height);
    upTriangle.lineTo(size.width / 2, size.height - size.height / 9);
    upTriangle.lineTo((size.width / 2) - 32, size.height);
    upTriangle.close();

    canvas.drawRRect(outer, rRactPaint);
    canvas.drawPath(path, pathPaint);
    canvas.drawPath(downTriangle, trianglePaint);
    canvas.drawPath(upTriangle, trianglePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
