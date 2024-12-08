import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foodly/providers/auth_provider.dart';
import 'package:foodly/widgets/confirm_button.dart';
import 'package:foodly/widgets/text_form_field_custom.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:foodly/validators/form_validators.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  late AuthProvider _authPrivder;
  final String _comfirmCode = "${1000 + Random().nextInt(10000 - 1000)}";
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authPrivder = Provider.of<AuthProvider>(context);
  }

  void _handleForm() async {
    if (_formKey.currentState!.validate()) {
      _authPrivder.deleteAnAccount(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          appLocal.deleteTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                appLocal.deleteInfo + _comfirmCode,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: TextFormFieldCustom(
                  labelText: appLocal.enterCode,
                  validator: (value) => validateCode(
                    _comfirmCode,
                    value,
                    appLocal.verifiCodeEmptyError,
                    appLocal.verifiCodeIncorrectError,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              ConfirmButton(
                onPressed: _handleForm,
                text: appLocal.deleteAccountBtn,
                color: Colors.red,
              )
            ],
          ),
        ),
      ),
    );
  }
}
