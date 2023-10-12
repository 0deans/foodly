import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 80,
              padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 15),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: Text('Camera', style: GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.w500)),
              ),
            ),
            Container(
              width: double.infinity,
              height: 100,
              padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 15),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: Text('Gallery', style: GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.w500)),
              ),
            ),
            Container(
              width: double.infinity,
              height: 100,
              padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 15),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: Text('History', style: GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.w500)),
              ),
            ),
            Container(
              width: double.infinity,
              height: 100,
              padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 15),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                child: Text('Settings', style: GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.w500)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
