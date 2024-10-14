import 'package:flutter/material.dart';
import 'package:foodly/pages/accept_image.dart';
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
            builder: (context) => AcceptImage(selectedImage: image),
          ),
        );
      }
    });
  }

  Widget buildButton(String text, VoidCallback onPressed) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
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
    final appLocal = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            icon: const Icon(Icons.account_circle,),
            tooltip: 'Profile',
          ),
        ],
      ),
      body: Wrap(
        children: [
          buildButton(appLocal.camera, () {
            Navigator.pushNamed(context, '/camera');
          }),
          buildButton(appLocal.gallery, _loadImageGallery),
          buildButton(appLocal.history, () {
            Navigator.pushNamed(context, '/history');
          }),
          buildButton(appLocal.settings, () {
            Navigator.pushNamed(context, '/settings');
          }),
        ],
      ),
    );
  }
}
