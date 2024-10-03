import 'package:vector_graphics_compiler/vector_graphics_compiler.dart'
    as vector_graphics;
import 'dart:math' as math;

import '../entities/vector_2d.dart';

({Offset max, Offset min}) calculateOffsets(List<vector_graphics.Path> paths) {
  var min = const Offset(double.infinity, double.infinity);
  var max = const Offset(double.negativeInfinity, double.negativeInfinity);

  for (final path in paths) {
    for (final command in path.commands) {
      switch (command) {
        case vector_graphics.MoveToCommand moveTo:
          min = Offset(
            math.min(min.dx, moveTo.x),
            math.min(min.dy, moveTo.y),
          );
          max = Offset(
            math.max(max.dx, moveTo.x),
            math.max(max.dy, moveTo.y),
          );
          continue;
        case vector_graphics.LineToCommand lineTo:
          min = Offset(
            math.min(min.dx, lineTo.x),
            math.min(min.dy, lineTo.y),
          );
          max = Offset(
            math.max(max.dx, lineTo.x),
            math.max(max.dy, lineTo.y),
          );
          continue;
        case vector_graphics.CubicToCommand cubicTo:
          min = Offset(
            math.min(
              min.dx,
              math.min(
                math.min(cubicTo.x1, cubicTo.x2),
                cubicTo.x3,
              ),
            ),
            math.min(
              min.dy,
              math.min(
                math.min(cubicTo.y1, cubicTo.y2),
                cubicTo.y3,
              ),
            ),
          );

          max = Offset(
            math.max(
              max.dx,
              math.max(
                math.max(cubicTo.x1, cubicTo.x2),
                cubicTo.x3,
              ),
            ),
            math.max(
              max.dy,
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

  return (max: max, min: min);
}

Size calculateSize(Offset max, Offset min) {
  final width = max.dx - min.dx;
  final height = max.dy - min.dy;
  return Size(width, height);
}
