import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart';

import 'generator/svg_generator.dart';

void main(List<String> args) {
  final parser = ArgParser();

  final defaultOutput = join(
    Directory.current.path,
    'generated',
  );

  parser.addOption('source', abbr: 's');
  parser.addOption('output', abbr: 'o', defaultsTo: defaultOutput);
  parser.addOption('widget-suffix', abbr: 'w', defaultsTo: 'Visualizer');

  final results = parser.parse(args);

  if (!results.wasParsed('source')) {
    stdout.writeAll(
      [
        'Error: You must specify a path where your SVGs are located',
        'Use source (or -s) argument',
      ],
      '\n',
    );

    return;
  }

  final source = results.option('source')!;
  final output = results.option('output')!;
  final widgetSuffix = results.option('widget-suffix')!;

  final directory = Directory(source);
  final files = directory.listSync();

  for (final file in files) {
    final generator = SvgGenerator.generateFromFile(
      file as File,
      output: output,
      widgetSuffix: widgetSuffix,
    );

    generator.generate();
  }
}
