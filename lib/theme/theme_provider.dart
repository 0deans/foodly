import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:foodly/theme/theme.dart';
import 'package:foodly/utils/database_service.dart';

class ThemeProvider with ChangeNotifier {
  final _dispatcher = SchedulerBinding.instance.platformDispatcher;
  late ThemeMode _themeMode;
  late ThemeData _themeData;

  ThemeProvider(ThemeMode themeMode) {
    _themeMode = themeMode;
    _setThemeData(_themeMode);

    _dispatcher.onPlatformBrightnessChanged = _onBrightnessChanged;
  }

  ThemeData get themeData => _themeData;
  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeData == darkMode;

  setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    _setThemeData(_themeMode);

    DatabaseService().database.then((db) {
      db.update('settings', {
        'theme': _themeMode.name,
      });
    });

    notifyListeners();
  }

  _setThemeData(ThemeMode themeMode) {
    if (themeMode == ThemeMode.system) {
      var brightness = _dispatcher.platformBrightness;
      _themeData = brightness == Brightness.dark ? darkMode : lightMode;
      return;
    }

    _themeData = themeMode == ThemeMode.light ? lightMode : darkMode;
  }

  void _onBrightnessChanged() {
    if (_themeMode == ThemeMode.system) {
      var brightness = _dispatcher.platformBrightness;
      _themeData = brightness == Brightness.dark ? darkMode : lightMode;

      notifyListeners();
    }
  }
}
