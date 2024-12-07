import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodly/classes/user.dart';
import 'package:foodly/services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foodly/services/google_service.dart';

class AuthProvider with ChangeNotifier {
  final _apiService = ApiService();
  final _storage = const FlutterSecureStorage();
  String? _token;
  User? user;
  bool isAuth = false;
  bool isGoogleSignIn = false;

  Future<void> autoLogin() async {
    final token = await _storage.read(key: 'token');
    final isGoogleAuth = await _storage.read(key: 'isGoogleAuth');

    if (token != null) {
      _token = token;
      isAuth = true;

      if (isGoogleAuth == 'true') {
        isGoogleSignIn = true;
      }

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
        }));

    final dataJson = await jsonDecode(response);

    _token = dataJson['session']['id'];
    isAuth = true;
    isGoogleSignIn = false;
    await _storage.write(key: 'token', value: _token!);

    if (context.mounted) Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> signInWithGoogle(BuildContext context, String tokenId) async {
    final response = await _apiService.httpReq(
      url: "/auth/login/google",
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'tokenId': tokenId,
      }),
    );

    final dataJson = jsonDecode(response);
    _token = dataJson['session']['id'];
    isAuth = true;
    isGoogleSignIn = true;

    await _storage.write(key: 'isGoogleAuth', value: true.toString());
    await _storage.write(key: 'token', value: _token!);

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }

    notifyListeners();
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
      context: context,
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
      context: context,
    );

    await _storage.delete(key: 'token');
    await _storage.delete(key: 'isGoogleAuth');
    _token = null;
    isAuth = false;
    if (isGoogleSignIn) {
      isGoogleSignIn = false;
    }
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

  Future<void> getUser(BuildContext context) async {
    if (user != null || _token == null) return;

    final response = await _apiService.httpReq(
      url: "/user",
      method: 'GET',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      context: context,
    );

    final dataJson = await jsonDecode(response);

    user = User(
      id: dataJson['user']['id'],
      name: dataJson['user']['name'],
      email: dataJson['user']['email'],
      avatar: dataJson['user']['avatar'],
    );

    debugPrint(user!.avatar);

    notifyListeners();
  }

  Future<void> deleteAnAccount(BuildContext context) async {
    final response = await _apiService.httpReq(
      url: "/user",
      method: 'DELETE',
      headers: {
        'Authorization': 'Bearer $_token',
      },
      context: context,
    );

    debugPrint(response);

    GoogleService.deleteAnAccount();
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'isGoogleAuth');
    _token = null;
    isAuth = false;
    if (isGoogleSignIn) {
      isGoogleSignIn = false;
    }
    user = null;

    if (context.mounted) Navigator.pushReplacementNamed(context, '/signin');
  }
}
