import 'package:flutter/material.dart';
import 'package:vector_graphics_compiler/vector_graphics_compiler.dart'
    as vector_graphics;
import 'dart:math' as math;

import '../entities/pair.dart';

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

    var min = const Pair(
      x: double.infinity,
      y: double.infinity,
    );

    var max = const Pair(
      x: double.negativeInfinity,
      y: double.negativeInfinity,
    );

    final paths = svg.paths;

    for (final path in paths) {
      for (final command in path.commands) {
        switch (command) {
          case vector_graphics.MoveToCommand moveTo:
            min = Pair(
              x: math.min(min.x, moveTo.x),
              y: math.min(min.y, moveTo.y),
            );
            max = Pair(
              x: math.max(max.x, moveTo.x),
              y: math.max(max.y, moveTo.y),
            );
            continue;
          case vector_graphics.LineToCommand lineTo:
            min = Pair(
              x: math.min(min.x, lineTo.x),
              y: math.min(min.y, lineTo.y),
            );
            max = Pair(
              x: math.max(max.x, lineTo.x),
              y: math.max(max.y, lineTo.y),
            );
            continue;
          case vector_graphics.CubicToCommand cubicTo:
            min = Pair(
              x: math.min(
                min.x,
                math.min(
                  math.min(cubicTo.x1, cubicTo.x2),
                  cubicTo.x3,
                ),
              ),
              y: math.min(
                min.y,
                math.min(
                  math.min(cubicTo.y1, cubicTo.y2),
                  cubicTo.y3,
                ),
              ),
            );

            max = Pair(
              x: math.max(
                max.x,
                math.max(
                  math.max(cubicTo.x1, cubicTo.x2),
                  cubicTo.x3,
                ),
              ),
              y: math.max(
                max.y,
                math.max(
                  math.max(cubicTo.y1, cubicTo.y2),
                  cubicTo.y3,
                ),
              ),
            );
            continue;
          default:
            continue;
        }
      }
    }

    final svgWidth = max.x - min.x;
    final svgHeight = max.y - min.y;

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
