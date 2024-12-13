import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodly/classes/scan_history.dart';
import 'package:foodly/providers/auth_provider.dart';
import 'package:foodly/utils/snackbar_util.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class HistoryProvider with ChangeNotifier {
  String? _token;

  Future<void> fetchHistory(BuildContext context,
      PagingController<int, ScanHistory> pagingController) async {
    if (_token == null) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      _token = authProvider.getToken();
    }

    try {
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:3000/scans?page=${pagingController.nextPageKey ?? 1}&limit=5'),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final data = ScanHistoryResponse.fromJson(json.decode(response.body));
        final isLastPage =
            data.pagination.currentPage >= data.pagination.totalPages;
        if (isLastPage) {
          pagingController.appendLastPage(data.data);
        } else {
          final nextPageKey = data.pagination.currentPage + 1;
          pagingController.appendPage(data.data, nextPageKey);
        }
      } else {
        throw Exception('Failed to fetch history.');
      }
    } catch (e) {
      pagingController.error = e;
      debugPrint(e.toString());
    }
  }

  Future<void> addScan(BuildContext context, File image) async {
    if (_token == null) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      _token = authProvider.getToken();
    }

    try {
      final request =
          http.MultipartRequest('POST', Uri.parse("http://10.0.2.2:3000/scans"))
            ..headers['Authorization'] = 'Bearer $_token'
            ..files.add(await http.MultipartFile.fromPath(
              'image',
              image.path,
              filename: path.basename(image.path),
            ));

      await request.send();
    } catch (e) {
      debugPrint(e.toString());

      if (context.mounted) {
        showSnackBar(context, e.toString(), Colors.red);
      }
    }
  }
}
