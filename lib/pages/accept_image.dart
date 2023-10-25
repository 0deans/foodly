import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodly/pages/meal_details.dart';

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
                    InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 80, 80, 80),
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(
                            Icons.close,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.cyan,
                      borderRadius: BorderRadius.circular(25),
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
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 80, 80, 80),
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Icon(
                            Icons.done,
                            size: 30,
                          ),
                        ),
                      ),
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
