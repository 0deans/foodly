import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  Object? _user;
  final _storage = const FlutterSecureStorage();

  bool? get isAuth => _token != null;

  void signIn() {}

  Future<void> signUp(
      BuildContext context, String name, String email, String password) async {
    final url = Uri.parse('http://10.0.2.2:3000/auth/signup');

    try {
      var request = http.MultipartRequest('POST', url);
      request.fields['name'] = name;
      request.fields['email'] = email;
      request.fields['password'] = password;

      final response = await request.send();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (context.mounted) Navigator.pushReplacementNamed(context, '/signin');
      } else {
        throw Exception('Failed to sign up');
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}