import 'dart:async';

import 'package:flutter/material.dart';

import 'svg_painter.dart';

class SvgVisualizer extends StatelessWidget {
  final String svg;
  final Color? color;

  const SvgVisualizer._({
    required this.svg,
    this.color,
  });

  factory SvgVisualizer.fromString({required String svg, Color? color}) =>
      SvgVisualizer._(svg: svg, color: color);

  static Widget fromAsset(
    BuildContext context, {
    required String asset,
    Color? color,
    Widget Function(BuildContext context)? onLoading,
  }) {
    return FutureBuilder<SvgVisualizer>(
      future: _loadFromAsset(context, asset: asset, color: color),
      builder: (context, snapshot) {
        return switch (snapshot.connectionState) {
          ConnectionState.done => snapshot.data!,
          _ => onLoading?.call(context) ?? const SizedBox.shrink(),
        };
      },
    );
  }

  static Future<SvgVisualizer> _loadFromAsset(
    BuildContext context, {
    required String asset,
    Color? color,
  }) async {
    final bundle = DefaultAssetBundle.of(context);
    final byteData = await bundle.load(asset);
    final charCodes = byteData.buffer.asUint8List();
    final svg = String.fromCharCodes(charCodes);
    return SvgVisualizer._(svg: svg, color: color);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return CustomPaint(
          size: size,
          painter: SvgPainter(
            source: svg,
            color: color ?? Colors.white,
          ),
        );
      },
    );
  }
}
