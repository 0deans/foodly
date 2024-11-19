import 'package:google_sign_in/google_sign_in.dart';

class GoogleService {
  static final _googleSignIn = GoogleSignIn(
    // serverClientId: "your_server_client_id",
  );

  static Future<GoogleSignInAccount?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();

      if (account != null) {
        final authentication = await account.authentication;

        print("Google ID Token: ${authentication.idToken}");
        print(account);

        return account;
      }

      return null;
    } catch (e) {
      print(e);
    }
  }
}
