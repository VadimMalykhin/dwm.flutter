import 'dart:ui';

import 'package:dwm/dwm.dart';
import 'package:flutter/material.dart';

class WindowSizeScreen extends StatefulWidget {
  const WindowSizeScreen({super.key});

  @override
  State<WindowSizeScreen> createState() => _WindowSizeScreenState();
}

class _WindowSizeScreenState extends State<WindowSizeScreen> with DwmWindowSizeListener {
  final ScrollController scrollController = ScrollController(
    initialScrollOffset: 0,
    keepScrollOffset: true,
  );

  @override
  void initState() {
    super.initState();
    Dwm.addListener(this);
  }

  @override
  void dispose() {
    Dwm.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowSize() {
    print('onWindowSize');
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
                  'Window Size',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Set minimum window size',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 20),
                    FutureBuilder<Size>(
                      future: Dwm.getWindowMinSize,
                      builder: (BuildContext context, AsyncSnapshot<Size> snapshot) {
                        if (snapshot.hasError) {
                          return Text(' Error: ${snapshot.error}');
                        }
                        if (snapshot.hasData) {
                          return Text('(${snapshot.data?.width ?? 0}x${snapshot.data?.height ?? 0})');
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    TextButton(
                      onPressed: () async {
                        await Dwm.setWindowMinSize(const Size(600, 600));
                        setState(() {});
                      },
                      child: const Text('600x600'),
                    ),
                    const SizedBox(width: 5),
                    TextButton(
                      onPressed: () async {
                        await Dwm.setWindowMinSize(const Size(800, 600));
                        setState(() {});
                      },
                      child: const Text('800x600'),
                    ),
                    const SizedBox(width: 5),
                    TextButton(
                      onPressed: () async {
                        await Dwm.setWindowMinSize(const Size(600, 800));
                        setState(() {});
                      },
                      child: const Text('600x800'),
                    ),
                    const SizedBox(width: 5),
                    TextButton(
                      onPressed: () async {
                        await Dwm.setWindowMinSize(const Size(1280, 720));
                        setState(() {});
                      },
                      child: const Text('1280x720 (HD)'),
                    ),
                    const SizedBox(width: 5),
                    TextButton(
                      onPressed: () async {
                        await Dwm.resetWindowMinSize();
                        setState(() {});
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Set maximum window size',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 20),
                    FutureBuilder<Size>(
                      future: Dwm.getWindowMaxSize,
                      builder: (BuildContext context, AsyncSnapshot<Size> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (snapshot.hasData) {
                          return Text('(${snapshot.data?.width ?? 0}x${snapshot.data?.height ?? 0})');
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    TextButton(
                      onPressed: () async {
                        await Dwm.setWindowMaxSize(const Size(600, 600));
                        setState(() {});
                      },
                      child: const Text('600x600'),
                    ),
                    const SizedBox(width: 5),
                    TextButton(
                      onPressed: () async {
                        await Dwm.setWindowMaxSize(const Size(800, 600));
                        setState(() {});
                      },
                      child: const Text('800x600'),
                    ),
                    const SizedBox(width: 5),
                    TextButton(
                      onPressed: () async {
                        await Dwm.setWindowMaxSize(const Size(1280, 720));
                        setState(() {});
                      },
                      child: const Text('1280x720 (HD)'),
                    ),
                    const SizedBox(width: 5),
                    TextButton(
                      onPressed: () async {
                        await Dwm.resetWindowMaxSize();
                        setState(() {});
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Set window size',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    TextButton(
                      onPressed: () async {
                        await Dwm.setWindowSize(const Size(600, 600));
                      },
                      child: const Text('600x600'),
                    ),
                    const SizedBox(width: 5),
                    TextButton(
                      onPressed: () async {
                        await Dwm.setWindowSize(const Size(800, 800));
                      },
                      child: const Text('800x800'),
                    ),
                    const SizedBox(width: 5),
                    TextButton(
                      onPressed: () async {
                        await Dwm.setWindowSize(const Size(1280, 720));
                      },
                      child: const Text('1280x720 (HD)'),
                    ),
                    const SizedBox(width: 5),
                    TextButton(
                      onPressed: () async {
                        await Dwm.setWindowSize(const Size(1920, 1080));
                      },
                      child: const Text('1920x1080 (FHD)'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
