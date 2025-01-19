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

  Future<void> _loadImageGallery() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AcceptImage(selectedImage: image),
        ),
      );
    }
  }

  Widget buildButton(String text, VoidCallback onPressed) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appLocal.homePage,
          style: const TextStyle(
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
            icon: const Icon(
              Icons.account_circle,
            ),
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
        ],
      ),
    );
  }
}
