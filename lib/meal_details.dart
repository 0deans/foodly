import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MealDetails extends StatefulWidget {
  final String imagePath;

  const MealDetails({super.key, required this.imagePath});

  @override
  State<MealDetails> createState() => _MealDetailsState();
}

class _MealDetailsState extends State<MealDetails> {
  late bool _isLoading;
  late Map<String, double> probabilities = {};

  _x() async {
    final labelsData = await rootBundle.loadString('assets/labels.txt');
    final labels = labelsData.split('\n');

    for (var label in labels) {
      probabilities[label] = 0.5;
    }
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;

    Future.delayed(const Duration(seconds: 2)).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
    _x();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.file(
                  File(widget.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white10,
            ),
            child: Column(
              children: [
                ...probabilities.keys.toList().map((className) {
                  final probability = probabilities[className];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(className.capitalize()),
                      const SizedBox(height: 25),
                      Text('${(probability! * 100).toStringAsFixed(2)}%'),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension Capitalize on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
