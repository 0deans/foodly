import 'package:flutter/material.dart';
import 'package:foodly/providers/auth_provider.dart';
import 'package:foodly/services/app_exception.dart';
import 'package:foodly/widgets/confirm_button.dart';
import 'package:foodly/widgets/or_divider.dart';
import 'package:foodly/widgets/social_buttons.dart';
import 'package:foodly/widgets/text_form_field_custom.dart';
import 'package:provider/provider.dart';
import 'package:foodly/validators/form_validators.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late AuthProvider _authProvider;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailContriller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _error = "";

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  void _handleForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authProvider.signUp(context, _nameController.text,
            _emailContriller.text, _passwordController.text);
      } on AppException catch (error) {
        setState(() {
          _error = error.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormFieldCustom(
                    labelText: "Enter display name",
                    controller: _nameController,
                    validator: (value) => nameValidator(value),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormFieldCustom(
                    labelText: "Enter your email",
                    controller: _emailContriller,
                    validator: (value) => emailValidator(value),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormFieldCustom(
                    labelText: "Enter password",
                    controller: _passwordController,
                    validator: (value) => passwordValidator(value),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormFieldCustom(
                    labelText: "Confirm password",
                    controller: _confirmPasswordController,
                    validator: (value) => confirmPasswordValidator(
                        value, _passwordController.text),
                  ),
                  ConfirmButton(
                    text: "Sign Up",
                    onPressed: _handleForm,
                  ),
                  if (_error != "")
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      width: double.infinity,
                      child: Text(
                        _error,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
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
                        "Do you have an account?",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/signin');
                        },
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: const Text(
                          " Sign In",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
