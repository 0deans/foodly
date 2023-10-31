import 'package:flutter/material.dart';
import 'package:foodly/providers/locale_provider.dart';
import 'package:foodly/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final List<bool> isSelected = [false, false, false];

  @override
  void initState() {
    super.initState();

    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    isSelected[themeProvider.themeMode.index] = true;
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final appLocal = AppLocalizations.of(context)!;

    final Map<String, String> localizedThemeMode = {
      'system': appLocal.system,
      'light': appLocal.light,
      'dark': appLocal.dark
    };

    final Map<String, String> localizedLangMode = {
      "en": "English",
      "uk": "Українська"
    };

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(appLocal.settings),
        backgroundColor: Colors.black12,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(appLocal.theme),
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    style: Theme.of(context).textTheme.bodySmall,
                    value: themeProvider.themeMode,
                    alignment: Alignment.centerRight,
                    items: ThemeMode.values.map((mode) {
                      return DropdownMenuItem(
                        value: mode,
                        child: Center(
                          child: Text(
                            localizedThemeMode[mode.name]!,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (themeMode) {
                      themeProvider.setThemeMode(themeMode!);
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(appLocal.language),
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    style: Theme.of(context).textTheme.bodySmall,
                    value: localeProvider.locale,
                    alignment: Alignment.centerRight,
                    items: AppLocalizations.supportedLocales.map((nextLocale) {
                      return DropdownMenuItem(
                        value: nextLocale,
                        child: Center(
                          child: Text(
                            localizedLangMode[nextLocale.toString()]!,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (locale) {
                      localeProvider.setLocale(locale!);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
