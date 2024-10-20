import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodly/services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final _apiService = ApiService();
  final _storage = const FlutterSecureStorage();
  String? _token;
  Map<String, String>? user;
  bool? isAuth = false;

  Future<void> autoLogin() async {
    final token = await _storage.read(key: 'token');

    if (token != null) {
      _token = token;
      isAuth = true;

      notifyListeners();
    }
  }

  Future<void> signIn(
      BuildContext context, String email, String password) async {
    final response = await _apiService.httpReq(
      url: "/auth/login",
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final dataJson = await jsonDecode(response);

    _token = dataJson['session']['id'];
    isAuth = true;
    await _storage.write(key: 'token', value: _token!);

    if (context.mounted) Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> signUp(
      BuildContext context, String name, String email, String password) async {
    await _apiService.httpReq(
      url: "/auth/signup",
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (context.mounted) Navigator.pushReplacementNamed(context, '/signin');
  }

  Future<void> signOut(BuildContext context) async {
    await _apiService.httpReq(
      url: "/auth/logout",
      method: 'POST',
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    await _storage.delete(key: 'token');
    _token = null;
    isAuth = false;
    user = null;

    if (context.mounted) Navigator.pushReplacementNamed(context, '/signin');
  }
  
  Future<void> sendRecoveryLinkEmail(String email) async {
    await _apiService.httpReq(
      url: "/auth/reset-password",
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
      }),
    );
  }

  Future<void> getUser() async {
    if (user != null || _token == null) return;

    final response =
        await _apiService.httpReq(url: "/user", method: 'GET', headers: {
      'Authorization': 'Bearer $_token',
    });

    final dataJson = await jsonDecode(response);

    user = {
      'name': dataJson['user']['name'],
      'email': dataJson['user']['email'],
    };

    notifyListeners();
  }
}
