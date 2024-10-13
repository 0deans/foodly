import 'package:flutter/material.dart';
import 'package:foodly/pages/home.dart';
import 'package:foodly/pages/welcome.dart';
import 'package:foodly/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthProvider>(context);

    if (authService.isAuth!) {
      return const Home();
    } else {
      return const Welcome();
    }
  }
}