library state;

import 'package:flutter/material.dart';

final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.system);
final ValueNotifier<int> navigationRailIndex = ValueNotifier(0);
