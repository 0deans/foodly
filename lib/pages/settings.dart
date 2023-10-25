import 'package:flutter/material.dart';
import 'package:foodly/theme/theme_provider.dart';
import 'package:provider/provider.dart';

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
      body: ListView(
        children: [
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Theme',
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
        ],
      ),
    );
  }
}
