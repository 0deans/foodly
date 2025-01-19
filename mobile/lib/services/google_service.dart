import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleService {
  static final _googleSignIn = GoogleSignIn(
    serverClientId:
        "905970938369-rbjqlrouqk117qa9g04gnnam21lapk8k.apps.googleusercontent.com",
  );

  static Future<String?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();

      if (account == null) return null;

      final authentication = await account.authentication;
      return authentication.idToken.toString();
    } catch (e) {
      debugPrint(e.toString());
    }

    return null;
  }

  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> deleteAnAccount() async {
    try {
      await _googleSignIn.disconnect();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
