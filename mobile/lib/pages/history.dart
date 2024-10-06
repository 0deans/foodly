import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodly/models/scan_history.dart';
import 'package:foodly/pages/meal_details.dart';
import 'package:foodly/providers/locale_provider.dart';
import 'package:foodly/utils/database_service.dart';
import 'package:foodly/widgets/popup_history.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  static const _pageSize = 3;

  final PagingController<int, ScanHistory> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final db = await DatabaseService().database;

      final List<Map<String, dynamic>> maps = await db.query(
        'scan_history',
        orderBy: 'createdAt DESC',
        limit: _pageSize,
        offset: pageKey,
      );

      final newItems = List.generate(
        maps.length,
        (index) => ScanHistory.fromMap(maps[index]),
      );

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    final appLocal = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(appLocal.history),
        backgroundColor: Colors.black12,
        centerTitle: true,
      ),
      body: SizedBox(
        width: w,
        height: h,
        child: PagedListView<int, ScanHistory>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<ScanHistory>(
            itemBuilder: (context, item, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MealDetails(
                        imagePath: item.imagePath,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 15,
                    bottom: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.file(
                            File(item.imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat.yMMMMEEEEd(
                                localeProvider.locale.languageCode,
                              ).add_Hm().format(item.createdAt),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            SafeArea(
                              child: PopupButton(
                                removeCallback: () {
                                  setState(() {
                                    final oldList = _pagingController.itemList;
                                    final newList = oldList!..removeAt(index);
                                    _pagingController.itemList = newList;
                                  });
                                },
                                item: item,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            noItemsFoundIndicatorBuilder: (context) {
              return Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  appLocal.noItemsFound,
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
