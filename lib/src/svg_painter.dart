import 'package:flutter/material.dart';
import 'package:vector_graphics_compiler/vector_graphics_compiler.dart'
    as vector_graphics;
import 'dart:math' as math;

typedef Pair = (double, double);

class SvgPainter extends CustomPainter {
  final String svg;
  final Color color;

  const SvgPainter({
    super.repaint,
    required this.svg,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final parsedSvg = vector_graphics.parse(
      svg,
      enableMaskingOptimizer: false,
      enableClippingOptimizer: false,
      enableOverdrawOptimizer: false,
    );

    final svgPaths = parsedSvg.paths;

    Pair min = (double.infinity, double.infinity);
    Pair max = (double.negativeInfinity, double.negativeInfinity);

    for (final svgPath in svgPaths) {
      for (final command in svgPath.commands) {
        switch (command) {
          case vector_graphics.MoveToCommand moveTo:
            min = (math.min(min.$1, moveTo.x), math.min(min.$2, moveTo.y));
            max = (math.max(max.$1, moveTo.x), math.max(max.$2, moveTo.y));
            continue;
          case vector_graphics.LineToCommand lineTo:
            min = (math.min(min.$1, lineTo.x), math.min(min.$2, lineTo.y));
            max = (math.max(max.$1, lineTo.x), math.max(max.$2, lineTo.y));
            continue;
          case vector_graphics.CubicToCommand cubicTo:
            min = (
              math.min(
                min.$1,
                math.min(
                  math.min(cubicTo.x1, cubicTo.x2),
                  cubicTo.x3,
                ),
              ),
              math.min(
                min.$2,
                math.min(
                  math.min(cubicTo.y1, cubicTo.y2),
                  cubicTo.y3,
                ),
              )
            );

            max = (
              math.max(
                max.$1,
                math.max(
                  math.max(cubicTo.x1, cubicTo.x2),
                  cubicTo.x3,
                ),
              ),
              math.max(
                max.$2,
                math.max(
                  math.max(cubicTo.y1, cubicTo.y2),
                  cubicTo.y3,
                ),
              )
            );
            continue;
          default:
            continue;
        }
      }
    }

    final svgWidth = max.$1 - min.$1;
    final svgHeight = max.$2 - min.$2;

    final scaleX = size.width / svgWidth;
    final scaleY = size.height / svgHeight;
    final scale = math.min(scaleX, scaleY);

    final translationX = (size.width - svgWidth * scale) / 2 - min.$1 * scale;
    final translationY = (size.height - svgHeight * scale) / 2 - min.$2 * scale;

    final path = Path();
    final paint = Paint()..color = color;

    for (final svgPath in svgPaths) {
      for (final command in svgPath.commands) {
        switch (command) {
          case vector_graphics.CloseCommand _:
            path.close();
            continue;
          case vector_graphics.MoveToCommand moveTo:
            path.moveTo(
              moveTo.x * scale + translationX,
              moveTo.y * scale + translationY,
            );
            continue;
          case vector_graphics.LineToCommand lineTo:
            path.lineTo(
              lineTo.x * scale + translationX,
              lineTo.y * scale + translationY,
            );
            continue;
          case vector_graphics.CubicToCommand cubicTo:
            path.cubicTo(
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

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
