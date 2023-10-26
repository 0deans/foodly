import 'package:flutter/material.dart';
import 'package:foodly/pages/accept_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final imagePicker = ImagePicker();
  final Map<String, String> menu = {};

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

  Widget buildButton(String text, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      child: ElevatedButton(
        onPressed: onPressed,
        style: Theme.of(context).elevatedButtonTheme.style,
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    final _appLocal = AppLocalizations.of(context)!;

    return Scaffold(
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
            Text(
              'Foodly',
              style: GoogleFonts.autourOne(fontSize: 25),
            ),
            const SizedBox(height: 40),
            buildButton(_appLocal.camera, () {
              Navigator.pushNamed(context, '/camera');
            }),
            buildButton(_appLocal.gallery, _loadImageGallery),
            buildButton(_appLocal.history, () {
              Navigator.pushNamed(context, '/history');
            }),
            buildButton(_appLocal.settings, () {
              Navigator.pushNamed(context, '/settings');
            }),
          ],
        ),
      ),
    );
  }
}
