import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:foodly/utils/database_service.dart';

class LocaleProvider with ChangeNotifier {
  late Locale _locale;
  Locale get locale => _locale;

  LocaleProvider(Locale locale) {
    _locale = locale;
  }

  void setLocale(Locale locale) {
    if(!AppLocalizations.supportedLocales.contains(locale)) {
      return;
    }

    _locale = locale;

    DatabaseService().database.then((db) {
      db.update('settings', {
        'language': _locale.languageCode,
      });
    });

    notifyListeners();
  }

  bool getLocale() => _locale.toString() == "en";
}