import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodly/classes/user.dart';
import 'package:foodly/services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foodly/services/google_service.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:foodly/utils/snackbar_util.dart';

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
    try {
      final response = await _apiService.httpReq(
        url: "/auth/login",
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'email': email,
            'password': password,
          },
        ),
      );

      final dataJson = await jsonDecode(response);

      _token = dataJson['session']['id'];
      isAuth = true;
      isGoogleSignIn = false;
      await _storage.write(key: 'token', value: _token!);

      if (context.mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      debugPrint(e.toString());

      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final tokenId = await GoogleService.signIn();

      if (tokenId == null) {
        throw Exception('Google sign in failed.');
      }

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
    } catch (e) {
      await GoogleService.signOut();

      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }

  Future<void> signUp(
      BuildContext context, String name, String email, String password) async {
    try {
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

      if (context.mounted) {
        showSnackBar(context, 'Account created.', Colors.green, seconds: 4);
      }

      if (context.mounted) Navigator.pushReplacementNamed(context, '/signin');
    } catch (e) {
      debugPrint(e.toString());

      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _apiService.httpReq(
        url: "/auth/logout",
        method: 'POST',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        context: context,
      );

      if (isGoogleSignIn) {
        GoogleService.signOut();
        debugPrint('Google sign out');
      }

      await _storage.delete(key: 'token');
      await _storage.delete(key: 'isGoogleAuth');

      _token = null;
      isAuth = false;
      if (isGoogleSignIn) {
        isGoogleSignIn = false;
      }
      user = null;

      if (context.mounted) Navigator.pushReplacementNamed(context, '/signin');
    } catch (e) {
      debugPrint(e.toString());

      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }

  Future<void> sendRecoveryLinkEmail(BuildContext context, String email) async {
    try {
      await _apiService.httpReq(
        url: "/auth/reset-password",
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            'email': email,
          },
        ),
        context: context,
      );

      if (context.mounted) {
        showSnackBar(context, 'Recovery link sent to your email', Colors.green,
            seconds: 4);
      }
    } catch (e) {
      debugPrint(e.toString());

      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }

  Future<void> getUser(BuildContext context) async {
    if (user != null || _token == null) return;

    try {
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
        avatar: dataJson['user']['avatar'].toString().replaceFirst(
            "http://s3.localhost.localstack.cloud", "http://10.0.2.2"),
      );

      debugPrint(user!.avatar.toString());

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());

      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }

  Future<void> deleteAnAccount(BuildContext context) async {
    try {
      await _apiService.httpReq(
        url: "/user",
        method: 'DELETE',
        headers: {
          'Authorization': 'Bearer $_token',
        },
        context: context,
      );

      GoogleService.deleteAnAccount();
      await _storage.delete(key: 'token');
      await _storage.delete(key: 'isGoogleAuth');
      _token = null;
      isAuth = false;
      if (isGoogleSignIn) {
        isGoogleSignIn = false;
      }
      user = null;

      if (context.mounted) {
        showSnackBar(context, 'Account deleted', Colors.green, seconds: 4);
      }

      if (context.mounted) Navigator.pushReplacementNamed(context, '/signin');
    } catch (e) {
      debugPrint(e.toString());

      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }

  Future<void> updateUser(BuildContext context, String name) async {
    try {
      final response = await _apiService.httpReq(
        url: "/user/name",
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
        }),
        context: context,
      );

      final dataJson = await jsonDecode(response);

      user!.name = dataJson['name'];

      notifyListeners();

      if (context.mounted) {
        showSnackBar(context, 'Name updated', Colors.green, seconds: 4);
      }
    } catch (e) {
      debugPrint(e.toString());

      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }

  Future<void> updateAvatar(BuildContext context, File image) async {
    try {
      final request = http.MultipartRequest(
          'PUT', Uri.parse("http://10.0.2.2:3000/user/avatar"))
        ..headers['Authorization'] = 'Bearer $_token'
        ..files.add(await http.MultipartFile.fromPath(
          'avatar',
          image.path,
          filename: path.basename(image.path),
        ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final dataJson =
            await jsonDecode(await response.stream.bytesToString());

        user!.avatar = dataJson['avatar'].toString().replaceFirst(
            "http://s3.localhost.localstack.cloud", "http://10.0.2.2");
      }

      notifyListeners();

      if (context.mounted) {
        showSnackBar(context, 'Avatar updated', Colors.green, seconds: 4);
      }
    } catch (e) {
      debugPrint(e.toString());

      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }
}
