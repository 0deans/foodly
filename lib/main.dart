import 'package:flutter/material.dart';
import 'home.dart';
import 'camera.dart';

void main() async{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark,
      primaryColor: Colors.grey),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/camera': (context) => const Camera(),
      },
    );
  }
}