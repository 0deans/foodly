import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? color;

  const ConfirmButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: color ?? Colors.green.shade600,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
