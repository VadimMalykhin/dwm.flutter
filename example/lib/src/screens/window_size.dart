import 'package:dwm/dwm.dart';
import 'package:flutter/material.dart';

class WindowSize extends StatefulWidget {
  const WindowSize({super.key});

  @override
  State<WindowSize> createState() => _WindowSizeState();
}

class _WindowSizeState extends State<WindowSize> with DwmWindowSizeListener {
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
    return Column(
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
              future: Dwm.getMinWindowSize,
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
                await Dwm.setMinWindowSize(const Size(600, 600));
                setState(() {});
              },
              child: const Text('600x600'),
            ),
            const SizedBox(width: 5),
            TextButton(
              onPressed: () async {
                await Dwm.setMinWindowSize(const Size(800, 600));
                setState(() {});
              },
              child: const Text('800x600'),
            ),
            const SizedBox(width: 5),
            TextButton(
              onPressed: () async {
                await Dwm.setMinWindowSize(const Size(600, 800));
                setState(() {});
              },
              child: const Text('600x800'),
            ),
            const SizedBox(width: 5),
            TextButton(
              onPressed: () async {
                await Dwm.setMinWindowSize(const Size(1280, 720));
                setState(() {});
              },
              child: const Text('1280x720 (HD)'),
            ),
            const SizedBox(width: 5),
            TextButton(
              onPressed: () async {
                await Dwm.removeMinWindowSize();
                setState(() {});
              },
              child: const Text('Remove'),
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
              future: Dwm.getMaxWindowSize,
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
                await Dwm.setMaxWindowSize(const Size(600, 600));
                setState(() {});
              },
              child: const Text('600x600'),
            ),
            const SizedBox(width: 5),
            TextButton(
              onPressed: () async {
                await Dwm.setMaxWindowSize(const Size(800, 600));
                setState(() {});
              },
              child: const Text('800x600'),
            ),
            const SizedBox(width: 5),
            TextButton(
              onPressed: () async {
                await Dwm.setMaxWindowSize(const Size(1280, 720));
                setState(() {});
              },
              child: const Text('1280x720 (HD)'),
            ),
            const SizedBox(width: 5),
            TextButton(
              onPressed: () async {
                await Dwm.removeMaxWindowSize();
                setState(() {});
              },
              child: const Text('Remove'),
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
    );
  }
}
