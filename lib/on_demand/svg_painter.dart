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

    final offsets = calculateOffsets(paths);
    final svgSize = calculateSize(offsets.max, offsets.min);

    final scaleX = size.width / svgSize.width;
    final scaleY = size.height / svgSize.height;
    final scale = math.min(scaleX, scaleY);

    final translationX =
        (size.width - svgSize.width * scale) / 2 - offsets.min.dx * scale;
    final translationY =
        (size.height - svgSize.height * scale) / 2 - offsets.min.dy * scale;

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
