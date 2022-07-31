import 'package:dwm/dwm.dart';
import 'package:flutter/material.dart';

class WindowStates extends StatefulWidget {
  const WindowStates({super.key});

  @override
  State<WindowStates> createState() => _WindowStatesState();
}

class _WindowStatesState extends State<WindowStates> with DwmWindowStateListener {
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
  void onWindowMinimized() {
    print('_______________onMinimized');
  }

  @override
  void onWindowState(state) {
    print('_______________onWindowState($state)');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Window States',
          style: TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 20),
        FutureBuilder<bool>(
          future: Dwm.isWindowMinimized,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasError) {
              return Text(' Error: ${snapshot.error}');
            }
            if (snapshot.hasData) {
              return Text('Is Minimized: ${snapshot.data}');
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 20),
        FutureBuilder<bool>(
          future: Dwm.isWindowMaximized,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasError) {
              return Text(' Error: ${snapshot.error}');
            }
            if (snapshot.hasData) {
              return Text('Is Maximized: ${snapshot.data}');
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextButton(
              onPressed: () async {
                await Dwm.setWindowMinimized();
              },
              child: const Text('Minimize a Window'),
            ),
            TextButton(
              onPressed: () async {
                await Dwm.setWindowMaximized();
              },
              child: const Text('Maximize a Window'),
            ),
            TextButton(
              onPressed: () async {
                await Dwm.setWindowRestore();
              },
              child: const Text('Restore a Window'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text('setWindowResizable'),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextButton(
              onPressed: () async {
                await Dwm.setWindowResizable(true);
              },
              child: const Text('ON'),
            ),
            TextButton(
              onPressed: () async {
                await Dwm.setWindowResizable(false);
              },
              child: const Text('OFF'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text('setWindowMinimizable'),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextButton(
              onPressed: () async {
                await Dwm.setWindowMinimizable(true);
              },
              child: const Text('ON'),
            ),
            TextButton(
              onPressed: () async {
                await Dwm.setWindowMinimizable(false);
              },
              child: const Text('OFF'),
            ),
          ],
        ),
        // const SizedBox(height: 20),
        // const Text('setWindowMaximizable'),
        // const SizedBox(height: 20),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: <Widget>[
        //     TextButton(
        //       onPressed: () async {
        //         await Dwm.setWindowMaximizable(true);
        //       },
        //       child: const Text('ON'),
        //     ),
        //     TextButton(
        //       onPressed: () async {
        //         await Dwm.setWindowMaximizable(false);
        //       },
        //       child: const Text('OFF'),
        //     ),
        //   ],
        // ),
        const SizedBox(height: 20),
        const Text('setWindowClosable'),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextButton(
              onPressed: () async {
                await Dwm.setWindowClosable(true);
              },
              child: const Text('ON'),
            ),
            TextButton(
              onPressed: () async {
                await Dwm.setWindowClosable(false);
              },
              child: const Text('OFF'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text('setWindowIconAndCationVisibility'),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextButton(
              onPressed: () async {
                await Dwm.setWindowIconAndCationVisibility(true);
              },
              child: const Text('ON'),
            ),
            TextButton(
              onPressed: () async {
                await Dwm.setWindowIconAndCationVisibility(false);
              },
              child: const Text('OFF'),
            ),
          ],
        ),
      ],
    );
  }
}
