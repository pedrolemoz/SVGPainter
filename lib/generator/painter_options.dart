import 'package:change_case/change_case.dart';

import 'options.dart';

class PainterOptions implements Options {
  final String? _prefix;
  final String _suffix;

  const PainterOptions({
    String? prefix,
    String? suffix,
  })  : _suffix = suffix ?? 'Painter',
        _prefix = prefix;

  @override
  String? get prefix => _prefix?.toPascalCase();

  @override
  String get suffix => _suffix.toPascalCase();

  @override
  String name(String file) {
    final fileName = '$prefix${file.toPascalCase()}$suffix'.toPascalCase();
    return fileName;
  }
}
