import 'package:flutter/material.dart';
import 'package:foodly/widgets/confirm_button.dart';
import 'package:foodly/widgets/or_divider.dart';
import 'package:foodly/widgets/social_buttons.dart';
import 'package:foodly/widgets/text_form_field_custom.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  void _signUp() {
    debugPrint('Sign up');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const TextFormFieldCustom(
                  labelText: "Enter display name",
                ),
                const SizedBox(
                  height: 15,
                ),
                const TextFormFieldCustom(
                  labelText: "Enter your email",
                ),
                const SizedBox(
                  height: 15,
                ),
                const TextFormFieldCustom(
                  labelText: "Enter password",
                ),
                const SizedBox(
                  height: 15,
                ),
                const TextFormFieldCustom(
                  labelText: "Confirm password",
                ),
                ConfirmButton(
                  text: "Sign Up",
                  onPressed: _signUp,
                ),
                const SizedBox(
                  height: 20,
                ),
                const OrDivider(),
                const SizedBox(
                  height: 10,
                ),
                const SocialButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}