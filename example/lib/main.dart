import 'package:flutter/material.dart';
import 'package:svg_painter/painter.dart';

import 'svg_mocks.dart';

void main() => runApp(const Example());

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF6666FF),
          foregroundColor: Colors.white,
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF6666FF),
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'SVG Painter Example',
      home: IconsPage(),
    );
  }
}

class IconsPage extends StatelessWidget {
  final mocks = [
    SvgMocks.apps,
    SvgMocks.cog,
    SvgMocks.user,
    SvgMocks.schedule,
    SvgMocks.phone_volume,
    SvgMocks.trophy,
    SvgMocks.edit,
    SvgMocks.bed,
    SvgMocks.basketball_hoop,
    SvgMocks.airplay,
    SvgMocks.heartbeat,
    SvgMocks.suitcase,
    SvgMocks.comment_exclamation,
    SvgMocks.padlock,
    SvgMocks.usd_circle,
    SvgMocks.map_pin,
    SvgMocks.image_edit,
    SvgMocks.money_stack,
    SvgMocks.file_alt,
    SvgMocks.bus_alt,
    SvgMocks.book_open,
    SvgMocks.credit_card,
    SvgMocks.grin,
    SvgMocks.newspaper,
    SvgMocks.accessible_icon_alt,
    SvgMocks.calculator_alt,
    SvgMocks.unlock_alt,
    SvgMocks.search_alt,
    SvgMocks.package,
    SvgMocks.tablet,
    SvgMocks.english_to_chinese,
    SvgMocks.bars,
    SvgMocks.battery_empty,
    SvgMocks.android_alt,
    SvgMocks.home,
    SvgMocks.scroll,
    SvgMocks.car,
    SvgMocks.paperclip,
    SvgMocks.university,
    SvgMocks.medal,
    SvgMocks.image_upload,
    SvgMocks.mars,
    SvgMocks.fahrenheit,
    SvgMocks.bill,
    SvgMocks.bitcoin_circle,
    SvgMocks.camera,
    SvgMocks.gold,
    SvgMocks.ninja,
  ];

  IconsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Unicons Line (SVG Painter)'),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
        shrinkWrap: true,
        itemCount: mocks.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8),
          child: SvgVisualizer.fromString(
            svg: mocks[index].data,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
