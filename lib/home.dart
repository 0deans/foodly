import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final bool _loading = true;
  late File _image;
  final imagePicker = ImagePicker();

  _loadImage_gallery() async {
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    if(image == null) {
      return;
    }
    else {
      _image = File(image.path);
    }
  }



  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('Foodly', style: GoogleFonts.autourOne(fontSize: 25))),
      body: Container(
        height: h,
        width: w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 275,
              width: 275,
              padding: const EdgeInsets.only(top: 10),
              child: Image.asset('assets/images/logo.png'),
            ),
            Container(
              width: double.infinity,
              height: 80,
              padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 15),
              child: ElevatedButton(
                onPressed: () {Navigator.pushNamed(context, '/camera');},
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: Text('Camera', style: GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.w500)),
              ),
            ),
            Container(
              width: double.infinity,
              height: 80,
              padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 15),
              child: ElevatedButton(
                onPressed: _loadImage_gallery,
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: Text('Gallery', style: GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.w500)),
              ),
            ),
            Container(
              width: double.infinity,
              height: 80,
              padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 15),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: Text('History', style: GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.w500)),
              ),
            ),
            Container(
              width: double.infinity,
              height: 80,
              padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 15),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: Text('Settings', style: GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.w500)),
              ),
            ),
            _loading == false ? Container(height: 200, width: 200, child: Image.file(_image),) : Container()
          ],
        ),
      ),
    );
  }
}
