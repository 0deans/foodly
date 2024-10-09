import 'package:flutter/material.dart';

class TextFormFieldCustom extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;

  const TextFormFieldCustom({
    super.key,
    this.controller,
    required this.labelText,
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
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
        ),
      ),
      controller: widget.controller,
    );
  }
}
