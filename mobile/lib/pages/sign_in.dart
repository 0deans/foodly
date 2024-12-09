import 'package:flutter/material.dart';
import 'package:foodly/providers/auth_provider.dart';
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

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void _handleForm() async {
    if (_formKey.currentState!.validate()) {
      await _authProvider.signIn(
          context, _emailController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;

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
                  appLocal.signInTitle,
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormFieldCustom(
                  labelText: appLocal.formEmailPlaceholder,
                  controller: _emailController,
                  validator: (value) => emailValidator(value,
                      appLocal.emailEmptyError, appLocal.emailInvalidError),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormFieldCustom(
                  labelText: appLocal.formPasswordPlaceholder,
                  controller: _passwordController,
                  validator: (value) => passwordValidator(
                      value,
                      appLocal.passwordEmptyError,
                      appLocal.passwordLengthError),
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
                      appLocal.forgotPassword,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.labelMedium!.color,
                      ),
                    ),
                  ),
                ),
                ConfirmButton(
                  onPressed: _handleForm,
                  text: appLocal.signIn,
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
                      appLocal.noAccount,
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
                        " ${appLocal.signUp}",
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
