import 'package:flutter/material.dart';
import 'package:svg_painter/utils/parser_utils.dart';
import 'package:vector_graphics_compiler/vector_graphics_compiler.dart' as vg;
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
    final svg = vg.parse(
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
          case vg.CloseCommand _:
            uiPath.close();
            continue;
          case vg.MoveToCommand moveTo:
            uiPath.moveTo(
              moveTo.x * scale + translationX,
              moveTo.y * scale + translationY,
            );
            continue;
          case vg.LineToCommand lineTo:
            uiPath.lineTo(
              lineTo.x * scale + translationX,
              lineTo.y * scale + translationY,
            );
            continue;
          case vg.CubicToCommand cubicTo:
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
