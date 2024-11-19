import 'package:flutter/material.dart';

class ChangeInfomationInput extends StatefulWidget {
  final TextEditingController? controller;
  final String title;
  final String labelText;
  final FormFieldValidator? validator;

  const ChangeInfomationInput({
    super.key,
    this.controller,
    required this.title,
    required this.labelText,
    this.validator,
  });

  @override
  State<ChangeInfomationInput> createState() => _ChangeInfomationInputState();
}

class _ChangeInfomationInputState extends State<ChangeInfomationInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 5),
          alignment: Alignment.centerLeft,
          child: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            hintText: widget.labelText,
            hintStyle: const TextStyle(
              color: Colors.black54,
            ),
            labelStyle: const TextStyle(
              color: Colors.black54,
            ),
            errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 14,
            ),
            errorMaxLines: 2,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                width: 2,
                color: Colors.red,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                width: 2,
                color: Colors.red,
              ),
            ),
            floatingLabelStyle: const TextStyle(
              color: Colors.black,
            ),
          ),
          autovalidateMode: AutovalidateMode.onUnfocus,
        )
      ],
    );
  }
}
