// Code generated using SVG Painter package in DateTime
// ignore_for_file: unused_local_variable

import 'dart:math' as math;
import 'package:flutter/material.dart';

class WidgetName extends StatelessWidget {
  final Color? color;

  const WidgetName({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final colorScheme = Theme.of(context).colorScheme;
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        return CustomPaint(
          size: size,
          painter: PainterName(color: color ?? colorScheme.primary),
        );
      },
    );
  }
}

class PainterName extends CustomPainter {
  final Color color;

  const PainterName({super.repaint, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const svgWidth = -1;
    const svgHeight = -1;

    final scaleX = size.width / svgWidth;
    final scaleY = size.height / svgHeight;
    final scale = math.min(scaleX, scaleY);

    const dx = -1;
    const dy = -1;

    final translationX = (size.width - svgWidth * scale) / 2 - dx * scale;
    final translationY = (size.height - svgHeight * scale) / 2 - dy * scale;

    final path = Path();
    final paint = Paint()..color = color;

    // Code generation

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
