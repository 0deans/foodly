import 'package:flutter/material.dart';

class TextFormFieldCustom extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  final FormFieldValidator validator;
  final String? type;

  const TextFormFieldCustom({
    super.key,
    this.controller,
    required this.labelText,
    required this.validator,
    this.type = 'text',
  });

  @override
  State<TextFormFieldCustom> createState() => _TextFormFieldCustomState();
}

class _TextFormFieldCustomState extends State<TextFormFieldCustom> {
  bool _visiblePassword = true;

  void _togglePassword() {
    setState(() {
      _visiblePassword = !_visiblePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == 'text') {
      return TextFormField(
        cursorColor: Colors.black,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: const TextStyle(
            color: Colors.black54,
          ),
          errorStyle: const TextStyle(
            color: Colors.red,
            fontSize: 14,
          ),
          errorMaxLines: 2,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 2,
              color: Colors.red,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 2,
              color: Colors.red,
            ),
          ),
          floatingLabelStyle: const TextStyle(
            color: Colors.black,
          ),
        ),
        controller: widget.controller,
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUnfocus,
      );
    }

    return TextFormField(
      cursorColor: Colors.black,
      obscureText: _visiblePassword,
      decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: const TextStyle(
            color: Colors.black54,
          ),
          errorStyle: const TextStyle(
            color: Colors.red,
            fontSize: 14,
          ),
          errorMaxLines: 2,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 2,
              color: Colors.red,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 2,
              color: Colors.red,
            ),
          ),
          floatingLabelStyle: const TextStyle(
            color: Colors.black,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _visiblePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.black,
            ),
            onPressed: _togglePassword,
          )),
      controller: widget.controller,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUnfocus,
    );
  }
}
