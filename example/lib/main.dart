import 'package:flutter/material.dart';
import 'package:svg_painter/painter.dart';

import 'svg_icons.dart';

void main() => runApp(const UniconsExample());

class UniconsExample extends StatelessWidget {
  const UniconsExample({super.key});

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
  final _iconsLine = [
    SvgIcons.apps,
    SvgIcons.cog,
    SvgIcons.user,
    SvgIcons.schedule,
    SvgIcons.phone_volume,
    SvgIcons.trophy,
    SvgIcons.edit,
    SvgIcons.bed,
    SvgIcons.basketball_hoop,
    SvgIcons.airplay,
    SvgIcons.heartbeat,
    SvgIcons.suitcase,
    SvgIcons.comment_exclamation,
    SvgIcons.padlock,
    SvgIcons.usd_circle,
    SvgIcons.map_pin,
    SvgIcons.image_edit,
    SvgIcons.money_stack,
    SvgIcons.file_alt,
    SvgIcons.bus_alt,
    SvgIcons.book_open,
    SvgIcons.credit_card,
    SvgIcons.grin,
    SvgIcons.newspaper,
    SvgIcons.accessible_icon_alt,
    SvgIcons.calculator_alt,
    SvgIcons.unlock_alt,
    SvgIcons.search_alt,
    SvgIcons.package,
    SvgIcons.tablet,
    SvgIcons.english_to_chinese,
    SvgIcons.bars,
    SvgIcons.battery_empty,
    SvgIcons.android_alt,
    SvgIcons.home,
    SvgIcons.scroll,
    SvgIcons.car,
    SvgIcons.paperclip,
    SvgIcons.university,
    SvgIcons.medal,
    SvgIcons.image_upload,
    SvgIcons.mars,
    SvgIcons.fahrenheit,
    SvgIcons.bill,
    SvgIcons.bitcoin_circle,
    SvgIcons.camera,
    SvgIcons.gold,
    SvgIcons.ninja,
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
        itemCount: _iconsLine.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8),
          child: SvgVisualizer(
            svg: _iconsLine[index],
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
