import 'package:flutter/material.dart';
import 'package:foodly/providers/auth_provider.dart';
import 'package:foodly/validators/form_validators.dart';
import 'package:foodly/widgets/confirm_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late AuthProvider _authProvider;
  late AppLocalizations appLocal;
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authProvider = Provider.of<AuthProvider>(context);
    appLocal = AppLocalizations.of(context)!;
  }

  @override
  void dispose() {
    _emailController.dispose();

    super.dispose();
  }

  void _sendRecoveryLinkEmail() async {
    final email = _emailController.text;
    final isEmailValid = emailValidator(
        email, appLocal.emailEmptyError, appLocal.emailInvalidError);

    if (isEmailValid == null) {
      await _authProvider.sendRecoveryLinkEmail(context, email);
    } else {
      setState(() {
        _emailError = isEmailValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                appLocal.forgotPassword,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  appLocal.forgotPasswordInfo,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                cursorColor: Colors.black,
                onChanged: (value) {
                  setState(() {
                    _emailError = emailValidator(value,
                        appLocal.emailEmptyError, appLocal.emailInvalidError);
                  });
                },
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: appLocal.formEmailPlaceholder,
                  errorText: _emailError,
                  labelStyle: const TextStyle(color: Colors.black54),
                  errorStyle: const TextStyle(color: Colors.red, fontSize: 14),
                  errorMaxLines: 2,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(width: 2, color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(width: 2, color: Colors.red),
                  ),
                  floatingLabelStyle: const TextStyle(color: Colors.black),
                ),
              ),
              ConfirmButton(
                text: appLocal.sendLink,
                color:
                    _emailError == null ? Colors.green.shade600 : Colors.grey,
                onPressed: _sendRecoveryLinkEmail,
              ),
              const SizedBox(height: 25),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.arrow_back,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      appLocal.backToSignIn,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
