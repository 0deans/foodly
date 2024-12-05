import 'package:flutter/material.dart';
import 'package:foodly/providers/auth_provider.dart';
import 'package:foodly/widgets/change_information_input.dart';
import 'package:foodly/widgets/confirm_button.dart';
import 'package:provider/provider.dart';
import 'package:foodly/validators/form_validators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late AuthProvider authPrivder;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authPrivder = Provider.of<AuthProvider>(context);
    authPrivder.getUser(context);

    _nameController.text = authPrivder.user!['name'].toString();
    _emailController.text = authPrivder.user!['email'].toString();
  }

  void _handleForm() async {
    if (_formKey.currentState!.validate()) {
      print("Edit ok");
    } else {
      print("Edit not ok");
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          appLocale.editProfilePage,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.20,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/avatar.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: 155,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.yellow.shade600,
                      ),
                      child: Text(
                        appLocale.changePhoto,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ChangeInfomationInput(
                title: appLocale.name,
                labelText: appLocale.formNamePlaceholder,
                controller: _nameController,
                validator: (value) => nameValidator(
                    value, appLocale.nameEmptyError, appLocale.nameLengthError),
              ),
              const SizedBox(height: 20),
              ChangeInfomationInput(
                title: appLocale.email,
                labelText: appLocale.formEmailPlaceholder,
                controller: _emailController,
                validator: (value) => emailValidator(value,
                    appLocale.emailEmptyError, appLocale.emailInvalidError),
              ),
              const SizedBox(height: 20),
              ConfirmButton(
                onPressed: _handleForm,
                text: appLocale.update,
              )
            ],
          ),
        ),
      ),
    );
  }
}
