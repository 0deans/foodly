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
    final inputDecorationTheme = Theme.of(context).inputDecorationTheme;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 5),
          alignment: Alignment.centerLeft,
          child: Text(
            widget.title,
            style: TextStyle(
              color: Theme.of(context).textTheme.labelMedium!.color,
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
            labelStyle: inputDecorationTheme.labelStyle,
            errorStyle: inputDecorationTheme.errorStyle,
            errorMaxLines: inputDecorationTheme.errorMaxLines,
            enabledBorder: inputDecorationTheme.enabledBorder,
            focusedBorder: inputDecorationTheme.focusedBorder,
            errorBorder: inputDecorationTheme.errorBorder,
            focusedErrorBorder: inputDecorationTheme.focusedErrorBorder,
            floatingLabelStyle: inputDecorationTheme.floatingLabelStyle,
          ),
          autovalidateMode: AutovalidateMode.onUnfocus,
          
        )
      ],
    );
  }
}
