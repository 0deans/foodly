import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text, Color color,
    {int seconds = 8}) {
  final snackBar = SnackBar(
    content: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
      ),
    ),
    duration: Duration(seconds: seconds),
    backgroundColor: color,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
