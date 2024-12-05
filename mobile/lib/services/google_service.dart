import 'package:flutter/material.dart';
import 'package:foodly/providers/auth_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleService {
  static final _googleSignIn = GoogleSignIn(
    serverClientId:
        "905970938369-rbjqlrouqk117qa9g04gnnam21lapk8k.apps.googleusercontent.com",
  );

  static Future<void> signIn(
      BuildContext context, AuthProvider authProvider) async {
    try {
      final account = await _googleSignIn.signIn();

      if (account != null) {
        final authentication = await account.authentication;

        if (context.mounted) {
          await authProvider.signInWithGoogle(context, authentication.idToken!);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> signOut(
      BuildContext context, AuthProvider authProvider) async {
    try {
      await _googleSignIn.signOut();

      if (context.mounted) {
        await authProvider.signOut(context);
      }
    } catch (e) {
      print(e);
    }
  }
}
