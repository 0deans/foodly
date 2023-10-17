import 'package:flutter/material.dart';
import 'package:foodly/pages/history.dart';
import 'package:foodly/pages/settings.dart';
import 'package:foodly/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:foodly/pages/home.dart';
import 'package:foodly/pages/camera.dart';

void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
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
