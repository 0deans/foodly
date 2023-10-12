import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  final Map<String, double>? probabilities;

  const TestPage({
    Key? key,
    required this.probabilities,
  }) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  Map<String, double>? probabilities;

  @override
  void initState() {
    super.initState();

    final sum = widget.probabilities!.values.reduce((a, b) => a + b);
    probabilities = widget.probabilities!.map((key, value) =>
        MapEntry(key, (value / sum) * 100));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Turn back'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: probabilities?.entries.map((entry) {
          return ListTile(
            title: Text(entry.key),
            subtitle: Text('${(entry.value).toStringAsFixed(2)}%'),
          );
        }).toList() ?? [],
      ),
    );
  }
}
