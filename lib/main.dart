import 'package:flutter/material.dart';
import 'package:foodly/pages/history.dart';
import 'package:foodly/pages/settings.dart';
import 'package:foodly/providers/locale_provider.dart';
import 'package:foodly/theme/theme_provider.dart';
import 'package:foodly/utils/database_service.dart';
import 'package:provider/provider.dart';
import 'package:foodly/pages/home.dart';
import 'package:foodly/pages/camera.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  late ThemeProvider themeProvider;
  final db = await DatabaseService().database;

  final result = await db.query('settings');
  if (result.isNotEmpty) {
    final themeMode = switch (result.first['theme']) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system
    };

    themeProvider = ThemeProvider(themeMode);
  } else {
    await db.insert('settings', {
      'theme': 'system',
      'language': 'en',
    });

    themeProvider = ThemeProvider(ThemeMode.system);
  }

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
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      builder: (context, child) {
        final provider = Provider.of<LocaleProvider>(context);

        return MaterialApp(
          theme: Provider.of<ThemeProvider>(context).themeData,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: provider.locale,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => const Home(),
            '/camera': (context) => const Camera(),
            '/history': (context) => const History(),
            '/settings': (context) => const Settings(),
          },
        );
      });
}
