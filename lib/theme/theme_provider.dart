import 'package:flutter/material.dart';
import 'package:foodly/theme/theme.dart';
import 'package:foodly/utils/database_provider.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;
  bool _isAuto = false;

  ThemeData get themeData => _themeData;
  bool get isAuto => _isAuto;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  set isAuto(bool value) {
    _isAuto = value;
    notifyListeners();
  }
}
