import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodly/classes/scan_history.dart';
import 'package:foodly/providers/history_provider.dart';
import 'package:foodly/utils/snackbar_util.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:popover/popover.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class PopupButton extends StatefulWidget {
  final Function removeCallback;
  final ScanHistory item;

  const PopupButton({
    super.key,
    required this.removeCallback,
    required this.item,
  });

  @override
  State<PopupButton> createState() => _PopupButtonState();
}

class _PopupButtonState extends State<PopupButton> {
  late HistoryProvider _historyProvider;

  Future<void> _saveImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final filePath = path.join(directory.path, 'fooly_image.jpg');
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        await GallerySaver.saveImage(file.path, albumName: 'foodly');

        await file.delete();

        if (mounted) {
          Navigator.pop(context);
          showSnackBar(context, "Image saved to gallery", Colors.green,
              seconds: 4);
        }
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      debugPrint(e.toString());

      if (mounted) {
        showSnackBar(context, "Image save failed", Colors.red);
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _historyProvider = Provider.of<HistoryProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {
        showPopover(
          context: context,
          bodyBuilder: (context) => Column(
            children: [
              GestureDetector(
                onTap: () => _saveImage(widget.item.imageUrl),
                child: Container(
                  height: 50,
                  color: Theme.of(context).colorScheme.primary,
                  child: Center(
                    child: Text(
                      appLocal.saveToGallery,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ),
              const Divider(height: 10),
              GestureDetector(
                onTap: () {
                  _historyProvider.deleteScan(context, widget.item.id);
                  widget.removeCallback();
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  color: Theme.of(context).colorScheme.primary,
                  child: Center(
                    child: Text(
                      appLocal.removeFromHistory,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          ),
          width: 200,
          height: 110,
          backgroundColor: Theme.of(context).colorScheme.primary,
        );
      },
      child: const Icon(Icons.more_vert),
    );
  }
}
