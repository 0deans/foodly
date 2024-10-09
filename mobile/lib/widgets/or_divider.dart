import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 2,
            color: Colors.black45,
            indent: 20,
            endIndent: 20,
          ),
        ),
        Text(
          "or continue with",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black45,
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 2,
            color: Colors.black45,
            indent: 20,
            endIndent: 20,
          ),
        ),
      ],
    );
  }
}
