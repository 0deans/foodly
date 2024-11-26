import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleService {
  static final _googleSignIn = GoogleSignIn(
    serverClientId:
        "905970938369-rbjqlrouqk117qa9g04gnnam21lapk8k.apps.googleusercontent.com",
  );

  static Future<GoogleSignInAccount?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();

      if (account != null) {
        final authentication = await account.authentication;

        // print('ID Token: ${authentication.idToken}');
        // print(account);

        final response = await http.post(
          Uri.parse("http://10.0.2.2:3000/auth/login/google"),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "tokenId": authentication.idToken,
          }),
        );

        print(response.body);

        return account;
      }

      return null;
    } catch (e) {
      print(e);
    }
  }
}
