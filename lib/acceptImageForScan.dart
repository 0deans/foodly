import 'dart:io';

import 'package:flutter/material.dart';

class AcceptImage extends StatefulWidget {
  final String selectedImage;

  const AcceptImage({Key? key, required this.selectedImage}): super(key: key);

  @override
  State<AcceptImage> createState() => _AcceptImageState();
}

class _AcceptImageState extends State<AcceptImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Image.file(File(widget.selectedImage)),
      ),
    );
  }
}