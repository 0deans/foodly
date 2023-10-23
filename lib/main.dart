import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:foodly/pages/history.dart';
import 'package:foodly/pages/settings.dart';
import 'package:foodly/theme/theme.dart';
import 'package:foodly/theme/theme_provider.dart';
import 'package:foodly/utils/database_provider.dart';
import 'package:provider/provider.dart';
import 'package:foodly/pages/home.dart';
import 'package:foodly/pages/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dispatcher = SchedulerBinding.instance.platformDispatcher;
  final db = await DatabaseProvider().database;
  final themeProvider = ThemeProvider();

  final result = await db.query('settings');

  var brightness = dispatcher.platformBrightness;
  bool isDarkMode = brightness == Brightness.dark;

  switch (result.first['theme']) {
    case 'light':
      themeProvider.themeData = lightMode;
      break;
    case 'dark':
      themeProvider.themeData = darkMode;
      break;
    case 'auto':
      themeProvider.isAuto = true;
      themeProvider.themeData = isDarkMode ? darkMode : lightMode;
      break;
    default:
      await db.insert(
        'settings',
        {
          'theme': isDarkMode ? 'dark' : 'light',
          'language': 'us',
        },
      );

      themeProvider.themeData = isDarkMode ? darkMode : lightMode;
  }

  dispatcher.onPlatformBrightnessChanged = () {
    if (!themeProvider.isAuto) {
      return;
    }

    var brightness = dispatcher.platformBrightness;
    if (brightness == Brightness.dark) {
      themeProvider.themeData = darkMode;
    } else {
      themeProvider.themeData = lightMode;
    }
  };

  runApp(
    ChangeNotifierProvider(
      create: (context) => themeProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).themeData,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/camera': (context) => const Camera(),
        '/history': (context) => const History(),
        '/settings': (context) => const Settings(),
      },
    );
  }
}
