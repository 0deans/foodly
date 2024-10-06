import 'package:flutter/material.dart';

class IconCircleButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData iconData;
  final double? size;
  final double? iconSize;

  const IconCircleButton({
    super.key,
    required this.onTap,
    required this.iconData,
    this.size,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          shape: BoxShape.circle,
        ),
        child: Icon(
          iconData,
          size: iconSize ?? 40,
          color: Colors.white,
        ),
      ),
    );
  }
}
