import 'dart:ui';

import 'package:dwm/dwm.dart';
import 'package:flutter/material.dart';

class WindowCornersScreen extends StatefulWidget {
  const WindowCornersScreen({super.key});

  @override
  State<WindowCornersScreen> createState() => _WindowCornersScreenState();
}

class _WindowCornersScreenState extends State<WindowCornersScreen> {
  final ScrollController scrollController = ScrollController(
    initialScrollOffset: 0,
    keepScrollOffset: true,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
              children: <Widget>[
                Text(
                  'Window Corners',
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () async {
                    await Dwm.setWindowCornerPreference(DwmWindowCornerPreference.kDefault);
                  },
                  child: const Text('Default'),
                ),
                const SizedBox(height: 5),
                TextButton(
                  onPressed: () async {
                    await Dwm.setWindowCornerPreference(DwmWindowCornerPreference.kDoNotRound);
                  },
                  child: const Text('Do Not Round'),
                ),
                const SizedBox(height: 5),
                TextButton(
                  onPressed: () async {
                    await Dwm.setWindowCornerPreference(DwmWindowCornerPreference.kRound);
                  },
                  child: const Text('Round'),
                ),
                const SizedBox(height: 5),
                TextButton(
                  onPressed: () async {
                    await Dwm.setWindowCornerPreference(DwmWindowCornerPreference.kRoundSmall);
                  },
                  child: const Text('Round Small'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
