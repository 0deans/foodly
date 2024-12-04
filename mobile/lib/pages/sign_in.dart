import 'package:flutter/material.dart';
import 'package:foodly/providers/auth_provider.dart';
import 'package:foodly/services/app_exception.dart';
import 'package:foodly/widgets/confirm_button.dart';
import 'package:foodly/widgets/or_divider.dart';
import 'package:foodly/widgets/social_buttons.dart';
import 'package:foodly/widgets/text_form_field_custom.dart';
import 'package:provider/provider.dart';
import 'package:foodly/validators/form_validators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late AuthProvider _authProvider;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
        await _authProvider.signIn(
            context, _emailController.text, _passwordController.text);
      } on AppException catch (error) {
        setState(() {
          _error = error.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context)!;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  appLocale.signInTitle,
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormFieldCustom(
                  labelText: appLocale.formEmailPlaceholder,
                  controller: _emailController,
                  validator: (value) => emailValidator(value, appLocale.emailEmptyError, appLocale.emailInvalidError),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormFieldCustom(
                  labelText: appLocale.formPasswordPlaceholder,
                  controller: _passwordController,
                  validator: (value) => passwordValidator(value, appLocale.passwordEmptyError, appLocale.passwordLengthError),
                  type: 'password',
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/forgot_password');
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      appLocale.forgotPassword,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                ConfirmButton(
                  onPressed: _handleForm,
                  text: appLocale.signIn,
                ),
                if (_error != "")
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
                    Text(
                      appLocale.noAccount,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/signup');
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Text(
                        " ${appLocale.signUp}",
                        style: const TextStyle(
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
