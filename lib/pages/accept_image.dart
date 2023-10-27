import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:foodly/pages/meal_details.dart';
import 'package:foodly/widgets/icon_circle_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class AcceptImage extends StatefulWidget {
  final XFile selectedImage;

  const AcceptImage({Key? key, required this.selectedImage}) : super(key: key);

  @override
  State<AcceptImage> createState() => _AcceptImageState();
}

class _AcceptImageState extends State<AcceptImage> {

  Future<String> saveImage(List<int> imageData) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    Directory imageDir = Directory("${appDocDir.path}/images");
    if (!imageDir.existsSync()) {
      imageDir.createSync(recursive: true);
    }

    Uuid uuid = const Uuid();
    String uniqueFileName = uuid.v4();

    String imagePath = "${imageDir.path}/$uniqueFileName.png";

    File imageFile = File(imagePath);
    await imageFile.writeAsBytes(imageData);

    return imagePath;
  }

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
                  File(widget.selectedImage.path),
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
                        final bytes = File(widget.selectedImage.path).readAsBytesSync();
                        saveImage(bytes).then((path) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MealDetails(
                                imagePath: path,
                                saveToHistory: true,
                              ),
                            ),
                          );
                        });
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
