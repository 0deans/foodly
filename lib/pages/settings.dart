import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:foodly/theme/theme_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../theme/theme.dart';

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

      // Change the theme or isAuto based on the selected index
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      switch (newIndex) {
        case 0:
          themeProvider.themeData = lightMode;
          themeProvider.isAuto = false;
          break;
        case 1:
          themeProvider.themeData = darkMode;
          themeProvider.isAuto = false;
          break;
        case 2:
          var dispatcher = SchedulerBinding.instance.platformDispatcher;
          var brightness = dispatcher.platformBrightness;
          bool isDarkMode = brightness == Brightness.dark;
          themeProvider.themeData = isDarkMode ? darkMode : lightMode;
          themeProvider.isAuto = true;
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final theme = themeProvider.themeData;
    final isAuto = themeProvider.isAuto;

    int selectedIndex = 0;
    if (isAuto) {
      selectedIndex = 2;
    } else if(theme == darkMode) {
      selectedIndex = 1;
    }

    isSelected[selectedIndex] = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Settings'),
        backgroundColor: Colors.black12,
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView(
        children: [
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Theme',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              ToggleButtons(
                isSelected: isSelected,
                fillColor: Colors.white,
                selectedColor: Colors.black,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                renderBorder: true,
                borderColor: Colors.white,
                selectedBorderColor: Colors.white,
                borderWidth: 2,
                borderRadius: BorderRadius.circular(6),
                onPressed: _select,
                children: ['Light', 'Dark', 'Auto'].map((name) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(name),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
