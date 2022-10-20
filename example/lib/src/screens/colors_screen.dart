import 'dart:ui';

import 'package:dwm/dwm.dart';
import 'package:flutter/material.dart';

class ColorsScreen extends StatelessWidget {
  final ScrollController scrollController = ScrollController(
    initialScrollOffset: 0,
    keepScrollOffset: true,
  );

  ColorsScreen({super.key});

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
                // TextButton(
                //   onPressed: () async {
                //     await Dwm.setDarkCaptionColor(const Color(0xffcccccc));
                //   },
                //   child: const Text('Set the custom dark color'),
                // ),
                // const SizedBox(height: 40),
                // Row(
                //   children: <Widget>[
                //     TextButton(
                //       onPressed: () async {
                //         await Dwm.setColorScheme(const DwmColorScheme.light());
                //       },
                //       child: const Text('Set the custom light color'),
                //     ),
                //     TextButton(
                //       onPressed: () async {
                //         await Dwm.resetColorScheme(const DwmColorScheme.light());
                //       },
                //       child: const Text('Set the custom dark color'),
                //     ),
                //   ],
                // ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Card(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Light',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () async {
                                await Dwm.setColorScheme(
                                  const DwmColorScheme.light(
                                    caption: Color(0xffffffff),
                                  ),
                                );
                              },
                              child: const Text('Set the color scheme'),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () async {
                                await Dwm.setColorScheme(const DwmColorScheme.light());
                              },
                              child: const Text('Reset the color scheme'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Dark',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () async {
                                await Dwm.setColorScheme(
                                  const DwmColorScheme.dark(
                                    caption: Color(0xff161b22),
                                    captionInactive: Color(0xff14181f),
                                    text: Color(0xff6a737d),
                                    textInactive: Color(0xff727479),
                                    border: Color(0xff30363d),
                                    borderInactive: Color(0xff30363d),
                                  ),
                                );
                              },
                              child: const Text('Set the GitHub color scheme'),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () async {
                                await Dwm.setColorScheme(
                                  const DwmColorScheme.dark(
                                    caption: Color(0xff242f3d),
                                    captionInactive: Color(0xff1f2936),
                                    text: Color(0xff91a3b3),
                                    textInactive: Color(0xff6a7680),
                                    border: Color(0xffffffff),
                                    borderInactive: Color(0xffffffff),
                                  ),
                                );
                              },
                              child: const Text('Set the Telegram color scheme'),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () async {
                                await Dwm.setColorScheme(const DwmColorScheme.dark());
                              },
                              child: const Text('Reset the color scheme'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                const Divider(height: 1),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
