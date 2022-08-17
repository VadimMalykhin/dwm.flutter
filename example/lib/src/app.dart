import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:dwm/dwm.dart';
import 'package:flutter/material.dart';

import 'screens/screens.dart';
import 'state.dart' as state;

/// Create an Application
Future<void> createApp() async {
  Paint.enableDithering = true;

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
    Zone.current.handleUncaughtError(details.exception, details.stack as StackTrace);
  };

  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize the DWM plugin.
    await Dwm.ensureInitialized();

    // Set the theme mode.
    await Dwm.setThemeMode(DwmThemeMode.system);

    // Set the minimum window size.
    await Dwm.setWindowMinSize(const Size(800, 600));
  } catch (e) {
    log(e.toString());
  }

  return runZonedGuarded(() async {
    runApp(const App());
  }, (error, stackTrace) {
    WidgetsFlutterBinding.ensureInitialized();
    log(error.toString(), stackTrace: stackTrace);
  });
}

/// Application Widget
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
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
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: state.themeMode,
      builder: (BuildContext ctx, ThemeMode value, Widget? _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: value,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: const ColorScheme.light(
              primary: Color(0xfff0b90b),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: const ColorScheme.dark(
              primary: Color(0xfff0b90b),
            ),
            scaffoldBackgroundColor: const Color(0xff272727),
            dividerColor: const Color(0xff202020),
            navigationRailTheme: const NavigationRailThemeData(
              backgroundColor: Colors.black12,
              indicatorColor: Color(0xfff0b90b),
              unselectedIconTheme: IconThemeData(
                color: Color(0xff5c6470),
              ),
              selectedIconTheme: IconThemeData(
                color: Color(0xff1b1f29),
              ),
              unselectedLabelTextStyle: TextStyle(
                color: Color(0xff5c6470),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              selectedLabelTextStyle: TextStyle(
                color: Color(0xfff0b90b),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          home: Scaffold(
            body: ValueListenableBuilder(
              valueListenable: state.navigationRailIndex,
              builder: (BuildContext ctx, int value, Widget? _) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ScrollConfiguration(
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
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                NavigationButton(
                                  active: value == 0,
                                  onPressed: () {
                                    state.navigationRailIndex.value = 0;
                                  },
                                  child: const Text('Platform Version'),
                                ),
                                const SizedBox(height: 5),
                                NavigationButton(
                                  active: value == 1,
                                  onPressed: () {
                                    state.navigationRailIndex.value = 1;
                                  },
                                  child: const Text('Window States'),
                                ),
                                const SizedBox(height: 5),
                                NavigationButton(
                                  active: value == 2,
                                  onPressed: () {
                                    state.navigationRailIndex.value = 2;
                                  },
                                  child: const Text('Window Size'),
                                ),
                                const SizedBox(height: 5),
                                NavigationButton(
                                  active: value == 3,
                                  onPressed: () {
                                    state.navigationRailIndex.value = 3;
                                  },
                                  child: const Text('Theme Mode'),
                                ),
                                const SizedBox(height: 5),
                                NavigationButton(
                                  active: value == 4,
                                  onPressed: () {
                                    state.navigationRailIndex.value = 4;
                                  },
                                  child: const Text('Content Protection'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          switch (value) {
                            case 0:
                              return const PlatformVersionScreen();
                            case 1:
                              return const WindowStatesScreen();
                            case 2:
                              return const WindowSizeScreen();
                            case 3:
                              return ThemeModeScreen();
                            case 4:
                              return const ContentProtectionScreen();
                            default:
                              return Container();
                          }
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class NavigationButton extends StatelessWidget {
  final bool active;
  final VoidCallback onPressed;
  final Widget child;

  const NavigationButton({
    super.key,
    required this.onPressed,
    required this.active,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        alignment: Alignment.centerLeft,
        backgroundColor: active ? MaterialStateProperty.all<Color>(Colors.yellow.withAlpha(20)) : null,
        fixedSize: MaterialStateProperty.all<Size>(const Size(170, 50)),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.only(left: 20)),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide.none,
          ),
        ),
      ),
      child: child,
    );
  }
}
