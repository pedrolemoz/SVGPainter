import '../entities/pair.dart';
import 'package:vector_graphics_compiler/vector_graphics_compiler.dart'
    as vector_graphics;
import 'dart:math' as math;

(Pair max, Pair min) calculatePairs(List<vector_graphics.Path> paths) {
  var min = const Pair(
    x: double.infinity,
    y: double.infinity,
  );

  var max = const Pair(
    x: double.negativeInfinity,
    y: double.negativeInfinity,
  );

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

  return (max, min);
}

(double width, double height) calculateSize(Pair max, Pair min) {
  final width = max.x - min.x;
  final height = max.y - min.y;
  return (width, height);
}
