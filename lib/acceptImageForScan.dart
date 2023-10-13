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
                padding: const EdgeInsets.only(top: 50),
                child: Image.file(
                  File(widget.selectedImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey,
                        child: Image.asset('assets/images/iconCancel.png'),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey,
                        child: Image.asset('assets/images/iconAllow.png'),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
