import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocaleProvider extends ChangeNotifier{
  Locale _locale = const Locale('uk');
  Locale get locale => _locale;

  void setLocale(Locale locale){
    if(!AppLocalizations.supportedLocales.contains(locale)) {
      return;
    }

    _locale = locale;
    notifyListeners();
  }
}