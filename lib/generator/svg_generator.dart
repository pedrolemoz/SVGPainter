import 'dart:io';

import 'package:change_case/change_case.dart';
import 'package:path/path.dart';
import 'package:vector_graphics_compiler/vector_graphics_compiler.dart' as vg;

import '../utils/parser_utils.dart';

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

  SvgGenerator._internal({
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
  }) =>
      SvgGenerator.generateFromFile(
        File(path),
        output: output,
        widgetSuffix: widgetSuffix,
      );

  factory SvgGenerator.generateFromFile(
    File file, {
    String? output,
    String? widgetSuffix,
  }) {
    final name = file.path.split(Platform.pathSeparator).last.split('.').first;
    final source = file.readAsStringSync();
    return SvgGenerator._internal(
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

  String loadTemplate() {
    final path = join(Directory.current.path, 'template', 'template.dart');
    return File(path).readAsStringSync();
  }

  void generate() {
    final svg = vg.parse(
      source,
      enableMaskingOptimizer: false,
      enableClippingOptimizer: false,
      enableOverdrawOptimizer: false,
    );

    final paths = svg.paths;

    final offsets = calculateOffsets(paths);
    final size = calculateSize(offsets.max, offsets.min);

    final buffer = StringBuffer();

    for (final path in paths) {
      for (final command in path.commands) {
        switch (command) {
          case vg.CloseCommand _:
            buffer.writeln('    path.close();\n');
            continue;
          case vg.MoveToCommand moveTo:
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
          case vg.LineToCommand lineTo:
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
          case vg.CubicToCommand cubicTo:
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

    final template = loadTemplate()
        .replaceFirst(
          RegExp(r'\/\/\signore.+'),
          '// Avoid modifying it by hand',
        )
        .replaceAll('WidgetName', widgetName)
        .replaceAll('DateTime', DateTime.now().toIso8601String())
        .replaceAll('PainterName', painterName)
        .replaceAll('const svgWidth = -1', 'const svgWidth = ${size.width}')
        .replaceAll('const svgHeight = -1', 'const svgHeight = ${size.height}')
        .replaceAll('const dx = -1', 'const dx = ${offsets.min.dx}')
        .replaceAll('const dy = -1', 'const dy = ${offsets.min.dy}')
        .replaceAll('// Code generation', buffer.toString().trim());

    writeToFile(template);
  }
}
