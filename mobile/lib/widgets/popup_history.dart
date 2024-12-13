import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodly/classes/scan_history.dart';
import 'package:foodly/utils/database_service.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:popover/popover.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                onTap: () {
                  GallerySaver.saveImage(
                    widget.item.imageUrl,
                    albumName: 'foodly',
                  );
                  Navigator.pop(context);
                },
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
                  DatabaseService().database.then((db) {
                    db.delete(
                      'scan_history',
                      where: 'id = ?',
                      whereArgs: [widget.item.id],
                    );

                    final file = File(widget.item.imageUrl);
                    if (file.existsSync()) {
                      file.deleteSync();
                    }

                    widget.removeCallback();
                  });
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
