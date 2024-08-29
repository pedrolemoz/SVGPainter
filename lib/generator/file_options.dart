import 'package:change_case/change_case.dart';

import 'options.dart';

class FileOptions implements Options {
  final String? _prefix;
  final String _suffix;

  const FileOptions({
    String? prefix,
    String? suffix,
  })  : _suffix = suffix ?? 'visualizer',
        _prefix = prefix;

  @override
  String? get prefix => _prefix?.toSnakeCase();

  @override
  String get suffix => _suffix.toSnakeCase();

  @override
  String name(String file) {
    final fileName = '$prefix${file.toSnakeCase()}$suffix'.toSnakeCase();
    return '$fileName.dart';
  }
}
