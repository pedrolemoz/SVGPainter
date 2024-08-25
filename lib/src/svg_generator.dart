import 'dart:io';

import 'package:change_case/change_case.dart';
import 'package:path/path.dart';
import 'package:vector_graphics_compiler/vector_graphics_compiler.dart'
    as vector_graphics;
import 'dart:math' as math;

import 'entities/pair.dart';

class SvgGenerator {
  final String source;
  final String className;
  final String widgetSuffix;
  final String output;

  String get classNameInPascalCase => className.toPascalCase();
  String get classNameInSnakeCase => className.toSnakeCase();

  String get widgetSuffixInPascalCase => widgetSuffix.toPascalCase();
  String get widgetSuffixInSnakeCase => widgetSuffix.toSnakeCase();

  String get painterName => '${classNameInPascalCase}Painter';
  String get widgetName => '$classNameInPascalCase$widgetSuffixInPascalCase';
  String get fileName => '$classNameInSnakeCase.dart';

  SvgGenerator._({
    required this.source,
    required this.className,
    String? output,
    String? widgetSuffix,
  })  : output = output ?? Directory.current.path,
        widgetSuffix = widgetSuffix ?? 'Visualizer';

  factory SvgGenerator.generateFromPath(
    String path, {
    String? output,
    String? widgetSuffix,
  }) {
    final file = File(path);
    return SvgGenerator.generateFromFile(
      file,
      output: output,
      widgetSuffix: widgetSuffix,
    );
  }

  factory SvgGenerator.generateFromFile(
    File file, {
    String? output,
    String? widgetSuffix,
  }) {
    final name = file.path.split(Platform.pathSeparator).last.split('.').first;
    final source = file.readAsStringSync();
    return SvgGenerator._(
      source: source,
      className: name,
      output: output,
      widgetSuffix: widgetSuffix,
    );
  }

  void writeToFile(String content) {
    final path = join(output, fileName);
    Directory(output).createSync();
    File(path).writeAsStringSync(content);
  }

  void generate() {
    final svg = vector_graphics.parse(
      source,
      enableMaskingOptimizer: false,
      enableClippingOptimizer: false,
      enableOverdrawOptimizer: false,
    );

    final buffer = StringBuffer();

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

    final width = max.x - min.x;
    final height = max.y - min.y;

    final now = DateTime.now();

    buffer.writeAll(
      [
        '// Code generated using SVG Painter package',
        '// Generated in ${now.toIso8601String()}',
        '',
        'import \'dart:math\' as math;',
        '',
        'import \'package:flutter/material.dart\';',
        '',
        'class $widgetName extends StatelessWidget {',
        '  final Color? color;',
        '',
        '  const $widgetName({',
        '    super.key,',
        '    this.color,',
        '  });',
        '',
        '  @override',
        '  Widget build(BuildContext context) {',
        '    return LayoutBuilder(',
        '      builder: (context, constraints) {',
        '        final colorScheme = Theme.of(context).colorScheme;',
        '        final size = Size(constraints.maxWidth, constraints.maxHeight);',
        '',
        '        return CustomPaint(',
        '          size: size,',
        '          painter: $painterName(color: color ?? colorScheme.primary),',
        '        );',
        '      },',
        '    );',
        '  }',
        '}',
        '\n',
      ],
      '\n',
    );

    buffer.writeAll(
      [
        'class $painterName extends CustomPainter {',
        '  final Color color;',
        '',
        '  const $painterName({',
        '    super.repaint,',
        '    required this.color,',
        '  });',
        '',
        '  @override',
        '  void paint(Canvas canvas, Size size) {',
        '    final scaleX = size.width / $width;',
        '    final scaleY = size.height / $height;',
        '    final scale = math.min(scaleX, scaleY);',
        '',
        '    final translationX = (size.width - $width * scale) / 2 - ${min.x} * scale;',
        '    final translationY = (size.height - $height * scale) / 2 - ${min.y} * scale;',
        '',
        '    final path = Path();',
        '    final paint = Paint()..color = color;',
        '\n',
      ],
      '\n',
    );

    for (final path in paths) {
      for (final command in path.commands) {
        switch (command) {
          case vector_graphics.CloseCommand _:
            buffer.writeln('    path.close();\n');
            continue;
          case vector_graphics.MoveToCommand moveTo:
            buffer.writeAll(
              [
                '    path.moveTo(',
                '      ${moveTo.x} * scale + translationX,',
                '      ${moveTo.y} * scale + translationY,',
                '    );',
                '\n',
              ],
              '\n',
            );
            continue;
          case vector_graphics.LineToCommand lineTo:
            buffer.writeAll(
              [
                '    path.lineTo(',
                '      ${lineTo.x} * scale + translationX,',
                '      ${lineTo.y} * scale + translationY,',
                '    );',
                '\n',
              ],
              '\n',
            );
            continue;
          case vector_graphics.CubicToCommand cubicTo:
            buffer.writeAll(
              [
                '    path.cubicTo(',
                '      ${cubicTo.x1} * scale + translationX,',
                '      ${cubicTo.y1} * scale + translationY,',
                '      ${cubicTo.x2} * scale + translationX,',
                '      ${cubicTo.y2} * scale + translationY,',
                '      ${cubicTo.x3} * scale + translationX,',
                '      ${cubicTo.y3} * scale + translationY,',
                '    );',
                '\n',
              ],
              '\n',
            );
            continue;
          default:
            continue;
        }
      }
    }

    buffer.writeln('    canvas.drawPath(path, paint);');
    buffer.writeAll(
      [
        '  }',
        '',
        '  @override',
        '  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;',
        '}',
      ],
      '\n',
    );

    writeToFile(buffer.toString());
  }
}
