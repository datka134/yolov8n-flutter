

import 'package:flutter/material.dart';


class ObjectPainter extends CustomPainter {
  ObjectPainter(this.imgSize,this.results);
  final Size imgSize;
  final List<dynamic> results;

  @override
  void paint(Canvas canvas, Size size) {
    // Using TouchyCanvas to enable interactivity
    // Calculating the scale factor to resize the rectangle (newSize/originalSize)
    final double scaleX = size.width / imgSize.width;
    final double scaleY = size.height / imgSize.height;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..color = const Color.fromARGB(255, 255, 0, 0);

    for (Rect rect in results) {
      canvas.drawRect(
        Rect.fromLTRB(
          rect.left * scaleX ,
          rect.top * scaleY,
          rect.right * scaleX ,
          rect.bottom * scaleY,
        ),
        paint,
      );
    
      
    }
  }

  @override
  bool shouldRepaint(ObjectPainter oldDelegate) {
    // Repaint if object is moving or new objects detected
    return oldDelegate.imgSize != imgSize || oldDelegate.results != results;
  }
}