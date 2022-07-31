import 'package:flutter/material.dart';

class ThemeModeFlutter extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeMode;

  const ThemeModeFlutter({
    super.key,
    required this.themeMode,
  });

  @override
  State<ThemeModeFlutter> createState() => _ThemeModeFlutterState();
}

class _ThemeModeFlutterState extends State<ThemeModeFlutter> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Theme Mode (Flutter)',
          style: TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 160,
          child: DropdownButtonFormField<ThemeMode>(
            isExpanded: false,
            borderRadius: BorderRadius.circular(2),
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            items: ThemeMode.values.map((ThemeMode value) {
              return DropdownMenuItem<ThemeMode>(
                value: value,
                child: Text(value.name.substring(0, 1).toUpperCase() + value.name.substring(1)),
              );
            }).toList(),
            value: widget.themeMode.value,
            hint: const Text('Theme'),
            onChanged: (value) {
              widget.themeMode.value = value!;
            },
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: <Widget>[
            TextButton(
              onPressed: () async {
                widget.themeMode.value = ThemeMode.light;
              },
              child: const Text('Light'),
            ),
            const SizedBox(width: 5),
            TextButton(
              onPressed: () async {
                widget.themeMode.value = ThemeMode.dark;
              },
              child: const Text('Dark'),
            ),
            const SizedBox(width: 5),
            TextButton(
              onPressed: () async {
                widget.themeMode.value = ThemeMode.system;
              },
              child: const Text('System'),
            ),
          ],
        )
      ],
    );
  }
}
