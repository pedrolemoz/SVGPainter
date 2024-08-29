import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart';

void main(List<String> args) {
  final parser = ArgParser();
  final widgetOptionsParser = ArgParser();
  final fileOptionsParser = ArgParser();
  final painterOptionsParser = ArgParser();

  widgetOptionsParser.addOption('prefix');
  widgetOptionsParser.addOption('suffix', defaultsTo: defaultWidgetSuffix);

  fileOptionsParser.addOption('prefix');
  fileOptionsParser.addOption('suffix', defaultsTo: defaultFileSuffix);

  painterOptionsParser.addOption('prefix');
  painterOptionsParser.addOption('suffix', defaultsTo: defaultPainterSuffix);

  parser.addOption('source');
  parser.addOption('output', defaultsTo: defaultOutput);

  parser.addCommand('widget', widgetOptionsParser);
  parser.addCommand('file', fileOptionsParser);
  parser.addCommand('painter', painterOptionsParser);

  final results = parser.parse(args);

  print(results.arguments);
  // final results = parser.parse(args);

  // if (!results.wasParsed('source')) {
  //   stdout.writeAll(
  //     [
  //       'Error: You must specify a path where your SVGs are located',
  //       'Use source (or -s) argument',
  //     ],
  //     '\n',
  //   );

  //   return;
  // }

  // final source = results.option('source')!;
  // final output = results.option('output')!;
  // final widgetSuffix = results.option('widget-suffix')!;

  // final directory = Directory(source);
  // final files = directory.listSync();

  // for (final file in files) {
  //   final generator = SvgGenerator.generateFromFile(
  //     file as File,
  //     widgetOptions: WidgetOptions(),
  //   );

  //   generator.generate();
  // }
}

final defaultOutput = join(
  Directory.current.path,
  'generated',
);

const defaultWidgetSuffix = 'Visualizer';
const defaultFileSuffix = 'visualizer';
const defaultPainterSuffix = 'Painter';
