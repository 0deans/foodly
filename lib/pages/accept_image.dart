import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodly/pages/meal_details.dart';
import 'package:foodly/widgets/icon_circle_button.dart';

class AcceptImage extends StatefulWidget {
  final String selectedImage;

  const AcceptImage({Key? key, required this.selectedImage}) : super(key: key);

  @override
  State<AcceptImage> createState() => _AcceptImageState();
}

class _AcceptImageState extends State<AcceptImage> {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SizedBox(
        height: h,
        width: w,
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: w,
                child: Image.file(
                  File(widget.selectedImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconCircleButton(
                      size: 50,
                      iconSize: 30,
                      iconData: Icons.close,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    IconCircleButton(
                      size: 50,
                      iconSize: 30,
                      iconData: Icons.done,
                      onTap: () {
                        final image = File(widget.selectedImage).readAsBytesSync();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MealDetails(
                              imageBytes: image,
                              saveToHistory: true,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
