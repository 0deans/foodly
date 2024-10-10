import 'package:flutter/material.dart';
import 'package:foodly/widgets/confirm_button.dart';
import 'package:foodly/widgets/or_divider.dart';
import 'package:foodly/widgets/social_buttons.dart';
import 'package:foodly/widgets/text_form_field_custom.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  void _signIn() {
    debugPrint('Sign in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const TextFormFieldCustom(
                  labelText: "Enter your email",
                ),
                const SizedBox(
                  height: 15,
                ),
                const TextFormFieldCustom(
                  labelText: "Enter your password",
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/forgot-password');
                  },
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                ConfirmButton(
                  onPressed: _signIn,
                  text: 'Sign In',
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 20,
                ),
                const OrDivider(),
                const SizedBox(
                  height: 10,
                ),
                const SocialButtons(),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "If you don't have an account?",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: const Text(
                        " Sign Up",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}