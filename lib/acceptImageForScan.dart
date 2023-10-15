import 'dart:io';

import 'package:flutter/material.dart';

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
              child: Container(
                width: w,
                padding: const EdgeInsets.only(top: 25),
                child: Image.file(
                  File(widget.selectedImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {
                          Navigator.pushNamed(context, '/');
                        },
                        child: const DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 80, 80, 80),
                            shape: BoxShape.circle
                          ),
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(
                              Icons.close,
                              size: 30,
                            ),
                          ),
                        )
                      ),
                      InkWell(
                        splashColor: Colors.cyan,
                          borderRadius: BorderRadius.circular(25),
                          onTap: () {
                          },
                          child: const DecoratedBox(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 80, 80, 80),
                                shape: BoxShape.circle
                            ),
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: Icon(
                                Icons.done,
                                size: 30,
                              ),
                            ),
                          )
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
