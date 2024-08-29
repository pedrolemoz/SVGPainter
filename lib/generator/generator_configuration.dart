import 'dart:io';

import 'file_options.dart';
import 'painter_options.dart';
import 'widget_options.dart';

class GeneratorConfiguration {
  final String source;
  final String baseName;
  final String output;
  final WidgetOptions widgetOptions;
  final FileOptions fileOptions;
  final PainterOptions painterOptions;

  GeneratorConfiguration({
    required this.source,
    required this.baseName,
    required this.widgetOptions,
    required this.fileOptions,
    required this.painterOptions,
    String? output,
  }) : output = output ?? Directory.current.path;

  String get fileName => fileOptions.name(baseName);
  String get widgetName => widgetOptions.name(baseName);
  String get painterName => painterOptions.name(baseName);
}
