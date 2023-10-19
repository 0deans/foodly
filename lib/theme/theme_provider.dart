import 'package:flutter/material.dart';
import 'package:foodly/theme/theme.dart';
import 'package:foodly/utils/database_provider.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() async {
    final db = await DatabaseProvider().database;
    if (_themeData == lightMode) {
      themeData = darkMode;
      db.update(
        'settings',
        {'theme': 'dark'},
      );
    } else {
      themeData = lightMode;
      db.update(
        'settings',
        {'theme': 'light'},
      );
    }
  }
}
