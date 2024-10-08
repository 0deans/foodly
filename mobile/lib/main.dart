import 'package:flutter/material.dart';
import 'package:foodly/pages/sign_up.dart';
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
  final db = await DatabaseService().database;

  late ThemeProvider themeProvider;
  late LocaleProvider localeProvider;

  final result = await db.query('settings');
  if (result.isNotEmpty) {
    final themeMode = switch (result.first['theme']) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system
    };

    themeProvider = ThemeProvider(themeMode);
    localeProvider = LocaleProvider(
      Locale((result.first['language'] as String?) ?? 'en'),
    );
  } else {
    await db.insert('settings', {
      'theme': 'system',
      'language': 'en',
    });

    themeProvider = ThemeProvider(ThemeMode.system);
    localeProvider = LocaleProvider(const Locale('en'));
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => themeProvider),
        ChangeNotifierProvider(create: (context) => localeProvider),
      ],
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
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Provider.of<LocaleProvider>(context).locale,
      debugShowCheckedModeBanner: false,
      initialRoute: '/auth',
      routes: {
        '/': (context) => const Home(),
        '/auth': (context) => const SignUp(),
        '/camera': (context) => const Camera(),
        '/history': (context) => const History(),
        '/settings': (context) => const Settings(),
      },
    );
  }
}
