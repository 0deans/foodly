import 'package:flutter/material.dart';
import 'package:foodly/pages/delete_account.dart';
import 'package:foodly/pages/edit_profile.dart';
import 'package:foodly/pages/forgot_password.dart';
import 'package:foodly/pages/profile.dart';
import 'package:foodly/pages/sign_in.dart';
import 'package:foodly/pages/sign_up.dart';
import 'package:foodly/pages/history.dart';
import 'package:foodly/pages/settings.dart';
import 'package:foodly/providers/auth_provider.dart';
import 'package:foodly/providers/history_provider.dart';
import 'package:foodly/providers/locale_provider.dart';
import 'package:foodly/theme/theme_provider.dart';
import 'package:foodly/utils/database_service.dart';
import 'package:foodly/widgets/auth_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:foodly/pages/home.dart';
import 'package:foodly/pages/camera.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await DatabaseService().database;

  late ThemeProvider themeProvider;
  late LocaleProvider localeProvider;
  final authProvider = AuthProvider();
  final historyProvider = HistoryProvider();

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

  await authProvider.autoLogin();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => themeProvider),
        ChangeNotifierProvider(create: (context) => localeProvider),
        ChangeNotifierProvider(create: (context) => authProvider),
        ChangeNotifierProvider(create: (context) => historyProvider),
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
      home: const AuthWrapper(),
      routes: {
        '/signin': (context) => const SignIn(),
        '/signup': (context) => const SignUp(),
        '/forgot_password': (context) => const ForgotPassword(),
        '/home': (context) => const Home(),
        '/profile': (context) => const Profile(),
        '/camera': (context) => const Camera(),
        '/history': (context) => const History(),
        '/settings': (context) => const Settings(),
        '/edit_profile': (context) => const EditProfile(),
        '/delete_account': (context) => const DeleteAccount(),
      },
    );
  }
}
