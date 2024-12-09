import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodly/providers/auth_provider.dart';
import 'package:foodly/widgets/change_information_input.dart';
import 'package:foodly/widgets/confirm_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:foodly/validators/form_validators.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late AuthProvider _authPrivder;
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  XFile? _image;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authPrivder = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_authPrivder.user != null) {
        _nameController.text = _authPrivder.user!.name;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  void _handleForm() async {
    if (_image != null) {
      await _authPrivder.updateAvatar(context, File(_image!.path));
      setState(() {
        _image = null;
      });
    }

    if (_nameController.text == _authPrivder.user!.name) return;
    if (_formKey.currentState!.validate() && mounted) {
      FocusScope.of(context).unfocus();

      await _authPrivder.updateUser(context, _nameController.text);
    }
  }

  Future<void> _loadImageGallery() async {
    final pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;

    if (_authPrivder.user == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            appLocal.editProfilePage,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Text(
            appLocal.notAuthenticated,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          appLocal.editProfilePage,
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
                  Container(
                    decoration:
                        const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                      ),
                    ]),
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.20,
                      child: ClipOval(
                        child: _image != null
                            ? Image.file(
                                File(_image!.path),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              )
                            : _authPrivder.user?.avatar != null
                                ? Image.network(
                                    _authPrivder.user!.avatar,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  )
                                : Image.asset(
                                    'assets/images/avatar.jpg',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: 155,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _loadImageGallery,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.yellow.shade600,
                      ),
                      child: Text(
                        appLocal.changePhoto,
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
                title: appLocal.name,
                labelText: appLocal.formNamePlaceholder,
                controller: _nameController,
                validator: (value) => nameValidator(
                    value, appLocal.nameEmptyError, appLocal.nameLengthError),
              ),
              const SizedBox(height: 20),
              ConfirmButton(
                onPressed: _handleForm,
                text: appLocal.update,
              )
            ],
          ),
        ),
      ),
    );
  }
}
