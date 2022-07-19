import 'dart:async';
import 'dart:developer';

import 'package:dwm/dwm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Create an Application
Future<void> createApp() async {
  Paint.enableDithering = true;

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
    Zone.current.handleUncaughtError(details.exception, details.stack as StackTrace);
  };

  return runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Dwm.ensureInitialized();

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

class _AppState extends State<App> with DwmListener {
  bool _contentProtectionStatus = false;

  ThemeMode _themeMode = ThemeMode.system;
  String _platformVersion = 'Unknown';

  final _dwm = Dwm();

  @override
  void initState() {
    super.initState();

    Dwm.addListener(this);

    _dwm.setContentProtection(true);

    initPlatformState();
  }

  @override
  void dispose() {
    Dwm.removeListener(this);
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _dwm.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    try {
      final value = await _dwm.getContentProtection ?? false;
      setState(() {
        _contentProtectionStatus = value;
      });
    } on PlatformException {
      if (kDebugMode) {
        print('Failed to get content protection.');
      }
    }

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  void onContentProtectionEnabled() {
    if (kDebugMode) {
      print('onContentProtectionEnabled');
    }
    setState(() {
      _contentProtectionStatus = true;
    });
  }

  @override
  void onContentProtectionDisabled() {
    if (kDebugMode) {
      print('onContentProtectionDisabled');
    }
    setState(() {
      _contentProtectionStatus = false;
    });
  }

  void _onChanged(bool value) async {
    try {
      await _dwm.setContentProtection(value);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Colors.blue,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
        ),
        scaffoldBackgroundColor: const Color(0xff272727),
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Theme Mode',
                style: TextStyle(fontSize: 26),
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  DropdownButton<ThemeMode>(
                    isDense: true,
                    items: ThemeMode.values.map((ThemeMode value) {
                      return DropdownMenuItem<ThemeMode>(
                        value: value,
                        child: Text(value.name.substring(0, 1).toUpperCase() + value.name.substring(1)),
                      );
                    }).toList(),
                    value: _themeMode,
                    hint: const Text('Theme'),
                    onChanged: (ThemeMode? value) {
                      setState(() {
                        _themeMode = value!;
                      });
                    },
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        _themeMode = ThemeMode.light;
                      });
                    },
                    child: const Text('Light'),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        _themeMode = ThemeMode.dark;
                      });
                    },
                    child: const Text('Dark'),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        _themeMode = ThemeMode.system;
                      });
                    },
                    child: const Text('System'),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                children: <Widget>[
                  const Text(
                    'Content Protection',
                    style: TextStyle(fontSize: 26),
                  ),
                  const SizedBox(width: 20),
                  Icon(_contentProtectionStatus ? Icons.visibility_off : Icons.visibility),
                  const SizedBox(width: 10),
                  FutureBuilder(
                    future: _dwm.getContentProtection,
                    initialData: _contentProtectionStatus,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return Text(snapshot.data ? 'on' : 'off');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Switch(
                    value: _contentProtectionStatus,
                    onChanged: _onChanged,
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () async {
                      await _dwm.setContentProtection(true);
                    },
                    child: const Text('Enable'),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () async {
                      await _dwm.setContentProtection(false);
                    },
                    child: const Text('Disable'),
                  ),
                ],
              ),
              const SizedBox(height: 120),
              Text('Theme Mode: $_themeMode'),
              Text('Running on: $_platformVersion'),
            ],
          ),
        ),
      ),
    );
  }
}
