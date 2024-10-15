import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  String? _token;
  Map<String, String>? user;
  bool? isAuth = false;

  Future<void> autoLogin() async {
    final token = await _storage.read(key: 'token');

    debugPrint(token.toString());

    if (token != null) {
      _token = token;
      isAuth = true;
      notifyListeners();
    }
  }

  Future<void> signIn(
      BuildContext context, String email, String password) async {
    final url = Uri.parse('http://10.0.2.2:3000/auth/login');

    try {
      var request = http.MultipartRequest('POST', url)
        ..fields['email'] = email
        ..fields['password'] = password;

      final response = await request.send();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final date = await response.stream.bytesToString();

        final dataJson = await jsonDecode(date);
        _token = dataJson['session']['id'];

        await _storage.write(key: 'token', value: _token!);

        if (context.mounted) Navigator.pushReplacementNamed(context, '/home');
      } else {
        throw Exception('Failed to sign in. Try again later');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(
      BuildContext context, String name, String email, String password) async {
    final url = Uri.parse('http://10.0.2.2:3000/auth/signup');

    try {
      var request = http.MultipartRequest('POST', url);
      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['password'] = password;

      final response = await request.send();

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          context.mounted) {
        Navigator.pushReplacementNamed(context, '/signin');
      } else {
        throw Exception('Failed to sign up');
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _storage.delete(key: 'token');
      _token = null;
      isAuth = false;
      user = null;

      if (context.mounted) Navigator.pushReplacementNamed(context, '/signin');
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getUser() async {
    if (user != null || _token == null) return;

    final url = Uri.parse('http://10.0.2.2:3000/user');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final dataJson = await jsonDecode(response.body);

        user = {
          'name': dataJson['user']['name'],
          'email': dataJson['user']['email'],
        };

        notifyListeners();
      } else {
        throw Exception('Failed to get user data');
      }
    } catch (error) {
      rethrow;
    }
  }
}
