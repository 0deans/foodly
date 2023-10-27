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

  _select(int newIndex) {
    setState(() {
      for (int index = 0; index < isSelected.length; index++) {
        isSelected[index] = index == newIndex;
      }

      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      themeProvider.setThemeMode(ThemeMode.values[newIndex]);
    });
  }

  @override
  void initState() {
    super.initState();

    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    isSelected[themeProvider.themeMode.index] = true;
  }

  @override
  Widget build(BuildContext context) {
    final _appLocal = AppLocalizations.of(context)!;
    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(_appLocal.settings),
        backgroundColor: Colors.black12,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _appLocal.theme,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                ToggleButtons(
                  isSelected: isSelected,
                  fillColor: Theme.of(context).colorScheme.primary,
                  selectedColor: Provider.of<ThemeProvider>(context).isDark
                      ? Colors.white
                      : Colors.black,
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  renderBorder: true,
                  borderColor: Theme.of(context).colorScheme.primary,
                  selectedBorderColor: Theme.of(context).colorScheme.primary,
                  borderWidth: 2,
                  borderRadius: BorderRadius.circular(6),
                  onPressed: _select,
                  children: ThemeMode.values.map((mode) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(mode.name),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _appLocal.language,
                ),
                Container(
                    width: 60,
                    decoration: const BoxDecoration(
                      color: Colors.cyan,
                    ),
                    child: Center(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: locale,
                          items: AppLocalizations.supportedLocales
                              .map((nextLocale) {
                            return DropdownMenuItem(
                              value: nextLocale,
                              onTap: () {
                                final provider = Provider.of<LocaleProvider>(
                                    context,
                                    listen: false);
                                provider.setLocale(nextLocale);
                              },
                              child: Center(
                                child: Text(
                                  nextLocale.toString(),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (_) {},
                        ),
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
