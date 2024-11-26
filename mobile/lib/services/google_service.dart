import 'package:google_sign_in/google_sign_in.dart';

class GoogleService {
  static final _googleSignIn = GoogleSignIn(
    serverClientId: "905970938369-rbjqlrouqk117qa9g04gnnam21lapk8k.apps.googleusercontent.com",
  );

  static Future<GoogleSignInAccount?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();

      if (account != null) {
        final authentication = await account.authentication;

        print('ID Token: ${authentication.idToken}');
        print(account);

        return account;
      }

      return null;
    } catch (e) {
      print(e);
    }
  }
}
