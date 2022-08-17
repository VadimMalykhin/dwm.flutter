import 'dart:ui';

import 'package:dwm/dwm.dart';
import 'package:flutter/material.dart';

class ContentProtectionScreen extends StatefulWidget {
  const ContentProtectionScreen({super.key});

  @override
  State<ContentProtectionScreen> createState() => _ContentProtectionScreenState();
}

class _ContentProtectionScreenState extends State<ContentProtectionScreen> with DwmContentProtectionListener {
  final ScrollController scrollController = ScrollController(
    initialScrollOffset: 0,
    keepScrollOffset: true,
  );

  DwmDisplayAffinity displayAffinity = DwmDisplayAffinity.none;

  @override
  void initState() {
    Dwm.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    Dwm.removeListener(this);
    super.dispose();
  }

  @override
  void onContentProtectionChanged(DwmDisplayAffinity displayAffinity) {
    print('11111111111111');
    print({'--> onContentProtectionChanged': displayAffinity});
    setState(() {});
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
                  'Content Protection',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                FutureBuilder<DwmDisplayAffinity?>(
                  future: Dwm.getContentProtection,
                  builder: (BuildContext context, AsyncSnapshot<DwmDisplayAffinity?> snapshot) {
                    print(snapshot.data);

                    if (snapshot.hasError) {
                      return Text(' Error: ${snapshot.error}');
                    }
                    if (snapshot.hasData) {
                      return Text('${snapshot.data}');
                    }
                    return const Text('No data.');
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: DropdownButtonFormField<DwmDisplayAffinity>(
                    isExpanded: false,
                    borderRadius: BorderRadius.circular(2),
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    items: DwmDisplayAffinity.values.map((DwmDisplayAffinity val) {
                      return DropdownMenuItem<DwmDisplayAffinity>(
                        value: val,
                        child: Text(val.name.substring(0, 1).toUpperCase() + val.name.substring(1)),
                      );
                    }).toList(),
                    value: displayAffinity,
                    hint: const Text('Theme'),
                    onChanged: (value) {
                      setState(() {
                        displayAffinity = value!;
                        Dwm.setContentProtection(displayAffinity);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Press to test'),
                const SizedBox(width: 10),
                winShiftSKeyHint(['Win', 'Shift', 'S']),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget winShiftSKeyHint(List<String> args) {
  var n = 0;
  return Row(
    children: <Widget>[
      for (final arg in args)
        Builder(
          builder: (context) {
            n++;
            return Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                  child: Text(arg),
                ),
                if (n != args.length) const SizedBox(width: 5),
                if (n != args.length) const Text('+'),
                if (n != args.length) const SizedBox(width: 5),
              ],
            );
          },
        ),
    ],
  );
}
