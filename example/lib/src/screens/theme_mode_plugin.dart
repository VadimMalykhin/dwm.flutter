import 'package:dwm/dwm.dart';
import 'package:flutter/material.dart';

class ThemeModePlugin extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeMode;

  const ThemeModePlugin({
    super.key,
    required this.themeMode,
  });

  @override
  State<ThemeModePlugin> createState() => _ThemeModePluginState();
}

class _ThemeModePluginState extends State<ThemeModePlugin> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Theme Mode (Plugin)',
          style: TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 20),
        FutureBuilder<DwmThemeMode>(
          future: Dwm.getThemeMode,
          builder: (BuildContext context, AsyncSnapshot<DwmThemeMode> snapshot) {
            if (snapshot.hasError) {
              return Text(' Error: ${snapshot.error}');
            }
            if (snapshot.hasData) {
              return Text('(${snapshot.data})');
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 20),
        Row(
          children: <Widget>[
            TextButton(
              onPressed: () async {
                await Dwm.setThemeMode(DwmThemeMode.system);
                setState(() {});
              },
              child: const Text('System'),
            ),
            const SizedBox(width: 5),
            TextButton(
              onPressed: () async {
                await Dwm.setThemeMode(DwmThemeMode.light);
                setState(() {});
              },
              child: const Text('Light'),
            ),
            const SizedBox(width: 5),
            TextButton(
              onPressed: () async {
                await Dwm.setThemeMode(DwmThemeMode.dark);
                setState(() {});
              },
              child: const Text('Dark'),
            ),
            const SizedBox(width: 5),
          ],
        ),
        const SizedBox(height: 20),
        const Text('Combined'),
        const SizedBox(height: 20),
        Row(
          children: <Widget>[
            TextButton(
              onPressed: () async {
                await Dwm.setThemeMode(DwmThemeMode.system);
                widget.themeMode.value = ThemeMode.system;
                setState(() {});
              },
              child: const Text('System'),
            ),
            const SizedBox(width: 5),
            TextButton(
              onPressed: () async {
                await Dwm.setThemeMode(DwmThemeMode.light);
                widget.themeMode.value = ThemeMode.light;
                setState(() {});
              },
              child: const Text('Light'),
            ),
            const SizedBox(width: 5),
            TextButton(
              onPressed: () async {
                await Dwm.setThemeMode(DwmThemeMode.dark);
                widget.themeMode.value = ThemeMode.dark;
                setState(() {});
              },
              child: const Text('Dark'),
            ),
            const SizedBox(width: 5),
          ],
        )
      ],
    );
  }
}
