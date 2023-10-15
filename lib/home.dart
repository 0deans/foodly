import 'package:flutter/material.dart';
import 'package:foodly/accept_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final imagePicker = ImagePicker();

  _loadImageGallery() async {
    await imagePicker.pickImage(source: ImageSource.gallery).then((image) {
      if (image != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AcceptImage(selectedImage: image.path),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Foodly',
          style: GoogleFonts.autourOne(fontSize: 25),
        ),
      ),
      body: SizedBox(
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
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/camera');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Camera',
                  style: GoogleFonts.roboto(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 80,
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              child: ElevatedButton(
                onPressed: _loadImageGallery,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Gallery',
                  style: GoogleFonts.roboto(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 80,
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'History',
                  style: GoogleFonts.roboto(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 80,
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Settings',
                  style: GoogleFonts.roboto(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
