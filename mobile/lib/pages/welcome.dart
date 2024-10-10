import 'package:flutter/material.dart';
import 'package:foodly/widgets/confirm_button.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
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
                child:   const Column(
                  children: [
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        'Welcome to Foodly!',
                        style: TextStyle(
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Take a photo of your dish, and the app will identify the ingredients. Sign in or sign up to get started!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
              text: 'Sign In',
            ),
            ConfirmButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              text: 'Sign Up',
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