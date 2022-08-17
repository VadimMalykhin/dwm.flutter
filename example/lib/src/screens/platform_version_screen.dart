import 'dart:ui';

import 'package:dwm/dwm.dart';
import 'package:flutter/material.dart';

class PlatformVersionScreen extends StatefulWidget {
  const PlatformVersionScreen({super.key});

  @override
  State<PlatformVersionScreen> createState() => _PlatformVersionScreenState();
}

class _PlatformVersionScreenState extends State<PlatformVersionScreen> {
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
                const Text(
                  'Platform Version',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                FutureBuilder<DwmPlatformVersion?>(
                  future: Dwm.getPlatformVersion,
                  builder: (BuildContext context, AsyncSnapshot<DwmPlatformVersion?> snapshot) {
                    if (snapshot.hasError) {
                      return Text(' Error: ${snapshot.error}');
                    }
                    if (snapshot.hasData) {
                      final version = snapshot.data;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Name: ${version?.name}',
                            style: const TextStyle(fontFamily: 'Consolas'),
                          ),
                          Text(
                            'Major: ${version?.major}',
                            style: const TextStyle(fontFamily: 'Consolas'),
                          ),
                          Text(
                            'Minor: ${version?.minor}',
                            style: const TextStyle(fontFamily: 'Consolas'),
                          ),
                          Text(
                            'Build: ${version?.build}',
                            style: const TextStyle(fontFamily: 'Consolas'),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Platform Id: ${version?.platformId}',
                            style: const TextStyle(fontFamily: 'Consolas'),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Is Windows Server: ${version?.isServer}',
                            style: const TextStyle(fontFamily: 'Consolas'),
                          ),
                          Text(
                            'Is Windows 10: ${version?.isWindows10}',
                            style: const TextStyle(fontFamily: 'Consolas'),
                          ),
                          Text(
                            'Is Windows 11: ${version?.isWindows11}',
                            style: const TextStyle(fontFamily: 'Consolas'),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
