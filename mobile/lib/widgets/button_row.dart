import 'package:flutter/material.dart';

class ButtonRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;
  final Color? textColor;
  final bool? visibleIconLeft;

  const ButtonRow({
    super.key,
    required this.icon,
    required this.title,
    required this.onPressed,
    this.textColor,
    this.visibleIconLeft = true,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: MediaQuery.of(context).size.width * 0.75,
        child: InkWell(
          onTap: onPressed,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 15),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.blue.shade800),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor ?? Theme.of(context).textTheme.labelMedium!.color,
                    ),
                  ),
                ],
              ),
              if (visibleIconLeft!)
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
