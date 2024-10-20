import 'package:flutter/material.dart';
import 'package:foodly/providers/auth_provider.dart';
import 'package:foodly/services/app_exception.dart';
import 'package:foodly/validators/form_validators.dart';
import 'package:foodly/widgets/confirm_button.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late AuthProvider _authProvider;
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;
  String _error = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authProvider = Provider.of<AuthProvider>(context);
  }

  void _sendRecoveryLinkEmail() async {
    final email = _emailController.text;
    if (emailValidator(email) == null) {
      try {
        await _authProvider.sendRecoveryLinkEmail(email);
      } on AppException catch (error) {
        setState(() {
          _error = error.message;
        });
      }
    } else {
      setState(() {
        _emailError = emailValidator(email);
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
              const Text(
                "Forgot password?",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: const Text(
                  "No worries, we'll send you a link to reset your password.",
                  style: TextStyle(
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
                    _emailError = emailValidator(value);
                  });
                },
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Enter your email',
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
                text: "Send link",
                color:
                    _emailError == null ? Colors.green.shade600 : Colors.grey,
                onPressed: _sendRecoveryLinkEmail,
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
              const SizedBox(height: 25),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back, color: Colors.black54),
                    SizedBox(width: 5),
                    Text(
                      "Back to sign in",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
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
