import 'package:flutter/material.dart';
import 'package:foodly/providers/auth_provider.dart';
import 'package:foodly/widgets/confirm_button.dart';
import 'package:foodly/widgets/or_divider.dart';
import 'package:foodly/widgets/social_buttons.dart';
import 'package:foodly/widgets/text_form_field_custom.dart';
import 'package:provider/provider.dart';
import 'package:foodly/validators/form_validators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailContriller.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  void _handleForm() async {
    if (_formKey.currentState!.validate()) {
      await _authProvider.signUp(context, _nameController.text,
          _emailContriller.text, _passwordController.text);
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    appLocal.signUpTitle,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormFieldCustom(
                    labelText: appLocal.formNamePlaceholder,
                    controller: _nameController,
                    validator: (value) => nameValidator(value,
                        appLocal.nameEmptyError, appLocal.nameLengthError),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormFieldCustom(
                    labelText: appLocal.formEmailPlaceholder,
                    controller: _emailContriller,
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
                  TextFormFieldCustom(
                    labelText: appLocal.formComfirmPasswordPlaceholder,
                    controller: _confirmPasswordController,
                    validator: (value) => confirmPasswordValidator(value,
                        _passwordController.text, appLocal.passwordMatchError),
                    type: 'password',
                  ),
                  ConfirmButton(
                    text: appLocal.signUp,
                    onPressed: _handleForm,
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
                        appLocal.haveAccount,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/signin');
                        },
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: Text(
                          "  ${appLocal.signIn}",
                          style: const TextStyle(
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
