import 'package:flutter/material.dart';

import 'svg_painter.dart';

class SvgVisualizer extends StatelessWidget {
  final String svg;
  final Color? color;

  const SvgVisualizer({
    super.key,
    required this.svg,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return CustomPaint(
          size: size,
          painter: SvgPainter(
            svg: svg,
            color: color ?? Colors.white,
          ),
        );
      },
    );
  }
}
