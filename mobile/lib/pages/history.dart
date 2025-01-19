import 'package:flutter/material.dart';
import 'package:foodly/classes/scan_history.dart';
import 'package:foodly/pages/meal_details.dart';
import 'package:foodly/providers/history_provider.dart';
import 'package:foodly/providers/locale_provider.dart';
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
  final PagingController<int, ScanHistory> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      final historyProvider =
          Provider.of<HistoryProvider>(context, listen: false);
      historyProvider.fetchHistory(context, _pagingController);
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final appLocal = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          appLocal.history,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
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
                        imageUrl: item.imageUrl,
                        saveImageToHistory: false,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                          child: Image.network(
                            item.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image),
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
                                      localeProvider.locale.languageCode)
                                  .add_Hm()
                                  .format(item.scannedAt),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            SafeArea(
                              child: PopupButton(
                                removeCallback: () {
                                  setState(() {
                                    _pagingController.itemList?.removeAt(index);
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
