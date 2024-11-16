import 'package:google_sign_in/google_sign_in.dart';

class GoogleService {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();

      print(account);
      return account;
    } catch (e) {
      print(e);
    }
  }
}