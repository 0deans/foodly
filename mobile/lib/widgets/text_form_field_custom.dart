import 'package:flutter/material.dart';

class TextFormFieldCustom extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  final FormFieldValidator validator;

  const TextFormFieldCustom({
    super.key,
    this.controller,
    required this.labelText,
    required this.validator,
  });

  @override
  State<TextFormFieldCustom> createState() => _TextFormFieldCustomState();
}

class _TextFormFieldCustomState extends State<TextFormFieldCustom> {
  @override
  Widget build(BuildContext context) {
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
}
