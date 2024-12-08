import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(
    content: Text(text),
    // duration: const Duration(seconds: 4), // default is 4s
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
