import 'dart:ui';

import 'package:flutter/material.dart';

import '../state.dart' as state;
import 'theme_mode_flutter.dart';
import 'theme_mode_plugin.dart';

class ThemeModeScreen extends StatelessWidget {
  final ScrollController scrollController = ScrollController(
    initialScrollOffset: 0,
    keepScrollOffset: true,
  );

  ThemeModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
        },
        scrollbars: false,
      ),
      child: Scrollbar(
        controller: scrollController,
        interactive: true,
        thumbVisibility: true,
        thickness: 6,
        radius: const Radius.circular(6),
        child: SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ThemeModeFlutter(themeMode: state.themeMode),
                const SizedBox(height: 40),
                const Divider(height: 1),
                const SizedBox(height: 40),
                ThemeModePlugin(themeMode: state.themeMode),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
