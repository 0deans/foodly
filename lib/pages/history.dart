import 'package:flutter/material.dart';
import 'package:foodly/models/scan_history.dart';
import 'package:foodly/utils/database_service.dart';
import 'package:intl/intl.dart';

import 'meal_details.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late bool _isLoading;
  late List<ScanHistory> _scanHistories;

  _initialize() async {
    final db = await DatabaseService().database;

    final List<Map<String, dynamic>> maps = await db.query(
      'scan_history',
      orderBy: 'createdAt DESC',
      limit: 10,
    );

    _scanHistories = List.generate(
      maps.length,
      (index) => ScanHistory.fromMap(maps[index]),
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('History'),
        backgroundColor: Colors.black12,
        centerTitle: true,
      ),
      body: SizedBox(
        width: w,
        height: h,
        child: ListView(
          children: [
            ..._scanHistories.map((history) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MealDetails(
                        imageBytes: history.image,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 40,
                    bottom: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.memory(
                            history.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(
                        DateFormat.yMMMMEEEEd()
                            .add_Hm()
                            .format(history.createdAt),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
