import 'package:flutter/material.dart';
import 'package:foodly/history.dart';
import 'package:foodly/settings.dart';
import 'home.dart';
import 'camera.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
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
