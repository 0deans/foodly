import 'package:flutter/material.dart';

class TextFormFieldCustom extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  final FormFieldValidator validator;
  final String? type;
  final TextInputType? keyboardType;

  const TextFormFieldCustom({
    super.key,
    this.controller,
    required this.labelText,
    required this.validator,
    this.type = 'text',
    this.keyboardType = TextInputType.text,
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
    final inputDecorationTheme = Theme.of(context).inputDecorationTheme;

    if (widget.type == 'text') {
      return TextFormField(
        cursorColor: Colors.black,
        decoration: InputDecoration(
          labelText: widget.labelText,
          enabledBorder: inputDecorationTheme.enabledBorder,
          focusedBorder: inputDecorationTheme.focusedBorder,
          errorBorder: inputDecorationTheme.errorBorder,
          focusedErrorBorder: inputDecorationTheme.focusedErrorBorder,
          labelStyle: inputDecorationTheme.labelStyle,
          errorStyle: inputDecorationTheme.errorStyle,
          errorMaxLines: inputDecorationTheme.errorMaxLines,
          floatingLabelStyle: inputDecorationTheme.floatingLabelStyle,
        ),
        controller: widget.controller,
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUnfocus,
        keyboardType: widget.keyboardType,
      );
    }

    return TextFormField(
      cursorColor: Colors.black,
      obscureText: _visiblePassword,
      decoration: InputDecoration(
          labelText: widget.labelText,
          enabledBorder: inputDecorationTheme.enabledBorder,
          focusedBorder: inputDecorationTheme.focusedBorder,
          errorBorder: inputDecorationTheme.errorBorder,
          focusedErrorBorder: inputDecorationTheme.focusedErrorBorder,
          labelStyle: inputDecorationTheme.labelStyle,
          errorStyle: inputDecorationTheme.errorStyle,
          errorMaxLines: inputDecorationTheme.errorMaxLines,
          floatingLabelStyle: inputDecorationTheme.floatingLabelStyle,
          suffixIcon: IconButton(
            icon: Icon(
              _visiblePassword ? Icons.visibility_off : Icons.visibility,
              color: inputDecorationTheme.suffixIconColor,
            ),
            onPressed: _togglePassword,
          )),
      controller: widget.controller,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUnfocus,
      keyboardType: widget.keyboardType,
    );
  }
}
