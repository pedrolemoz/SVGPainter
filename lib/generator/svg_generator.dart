import 'dart:io';

import 'package:path/path.dart';
import 'package:vector_graphics_compiler/vector_graphics_compiler.dart'
    as vector_graphics;

import '../utils/parser_utils.dart';
import 'file_options.dart';
import 'generator_configuration.dart';
import 'painter_options.dart';
import 'widget_options.dart';

class SvgGenerator {
  final GeneratorConfiguration configuration;

  const SvgGenerator._({required this.configuration});

  factory SvgGenerator.generateFromPath(
    String path, {
    required WidgetOptions widgetOptions,
    required FileOptions fileOptions,
    required PainterOptions painterOptions,
  }) {
    final file = File(path);
    return SvgGenerator.generateFromFile(
      file,
      widgetOptions: widgetOptions,
      fileOptions: fileOptions,
      painterOptions: painterOptions,
    );
  }

  factory SvgGenerator.generateFromFile(
    File file, {
    required WidgetOptions widgetOptions,
    required FileOptions fileOptions,
    required PainterOptions painterOptions,
  }) {
    final name = file.path.split(Platform.pathSeparator).last.split('.').first;
    final source = file.readAsStringSync();
    return SvgGenerator._(
      configuration: GeneratorConfiguration(
        source: source,
        baseName: name,
        widgetOptions: widgetOptions,
        fileOptions: fileOptions,
        painterOptions: painterOptions,
      ),
    );
  }

  void writeToFile(String content) {
    final path = join(configuration.output, configuration.fileName);
    Directory(configuration.output).createSync();
    File(path).writeAsStringSync(content);
  }

  void generate() {
    final svg = vector_graphics.parse(
      configuration.source,
      enableMaskingOptimizer: false,
      enableClippingOptimizer: false,
      enableOverdrawOptimizer: false,
    );

    final buffer = StringBuffer();

    final paths = svg.paths;

    final (max, min) = calculatePairs(paths);
    final (width, height) = calculateSize(max, min);

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
        'class ${configuration.widgetName} extends StatelessWidget {',
        '  final Color? color;',
        '',
        '  const ${configuration.widgetName}({',
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
        '          painter: ${configuration.painterName}(color: color ?? colorScheme.primary),',
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
        'class ${configuration.painterName} extends CustomPainter {',
        '  final Color color;',
        '',
        '  const ${configuration.painterName}({',
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
