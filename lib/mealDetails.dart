import 'dart:io';
import 'package:flutter/material.dart';

class MealDetails extends StatefulWidget {
  final String imagePath;

  const MealDetails({super.key, required this.imagePath});

  @override
  State<MealDetails> createState() => _MealDetailsState();
}

class _MealDetailsState extends State<MealDetails> {
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = true;

    Future.delayed(const Duration(seconds: 2)).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.file(File(widget.imagePath)),
              ),
            )
          ],
        ),
    );
  }
}
