import 'package:flutter/material.dart';
import 'package:foodly/widgets/confirm_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            SizedBox(
              height: 275,
              width: 275,
              child: Image.asset('assets/images/logo.png'),
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child:  Column(
                  children: [
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        appLocal.welcome,
                        style: const TextStyle(
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      appLocal.welcomeInfo,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            ConfirmButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signin');
              },
              text: appLocal.signIn,
            ),
            ConfirmButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              text: appLocal.signUp,
              color: Colors.blue.shade700,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
