import 'package:flutter/material.dart';
import 'package:svg_painter/utils/parser_utils.dart';
import 'package:vector_graphics_compiler/vector_graphics_compiler.dart'
    as vector_graphics;
import 'dart:math' as math;

class SvgPainter extends CustomPainter {
  final String source;
  final Color color;

  const SvgPainter({
    super.repaint,
    required this.source,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final svg = vector_graphics.parse(
      source,
      enableMaskingOptimizer: false,
      enableClippingOptimizer: false,
      enableOverdrawOptimizer: false,
    );

    final paths = svg.paths;

    final (max, min) = calculatePairs(paths);
    final (svgWidth, svgHeight) = calculateSize(max, min);

    final scaleX = size.width / svgWidth;
    final scaleY = size.height / svgHeight;
    final scale = math.min(scaleX, scaleY);

    final translationX = (size.width - svgWidth * scale) / 2 - min.x * scale;
    final translationY = (size.height - svgHeight * scale) / 2 - min.y * scale;

    final uiPath = Path();
    final paint = Paint()..color = color;

    for (final path in paths) {
      for (final command in path.commands) {
        switch (command) {
          case vector_graphics.CloseCommand _:
            uiPath.close();
            continue;
          case vector_graphics.MoveToCommand moveTo:
            uiPath.moveTo(
              moveTo.x * scale + translationX,
              moveTo.y * scale + translationY,
            );
            continue;
          case vector_graphics.LineToCommand lineTo:
            uiPath.lineTo(
              lineTo.x * scale + translationX,
              lineTo.y * scale + translationY,
            );
            continue;
          case vector_graphics.CubicToCommand cubicTo:
            uiPath.cubicTo(
              cubicTo.x1 * scale + translationX,
              cubicTo.y1 * scale + translationY,
              cubicTo.x2 * scale + translationX,
              cubicTo.y2 * scale + translationY,
              cubicTo.x3 * scale + translationX,
              cubicTo.y3 * scale + translationY,
            );
            continue;
          default:
            continue;
        }
      }
    }

    canvas.drawPath(uiPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
