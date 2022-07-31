import 'package:dwm/dwm.dart';
import 'package:flutter/material.dart';

class PlatformVersion extends StatefulWidget {
  const PlatformVersion({super.key});

  @override
  State<PlatformVersion> createState() => _PlatformVersionState();
}

class _PlatformVersionState extends State<PlatformVersion> {
  // Dwm.setContentProtection2(DwmDisplayAffinity.excludeFromCapture);

  DwmDisplayAffinity displayAffinity = DwmDisplayAffinity.none;

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
    return Column(
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
    );
  }
}
