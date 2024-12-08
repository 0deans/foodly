import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodly/services/app_exception.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<dynamic> httpReq({
    required String url,
    required String method,
    Map<String, String>? headers,
    String? body,
    int timeoutSeconds = 10,
    BuildContext? context,
  }) async {
    try {
      http.Response response;
      final uri = Uri.parse("http://10.0.2.2:3000$url");

      if (method == "GET") {
        response = await http
            .get(
              uri,
              headers: headers,
            )
            .timeout(Duration(seconds: timeoutSeconds));
      } else if (method == "POST") {
        response = await http
            .post(
              uri,
              headers: headers,
              body: body,
            )
            .timeout(Duration(seconds: timeoutSeconds));
      } else if (method == "PUT") {
        response = await http
            .put(
              uri,
              headers: headers,
              body: body,
            )
            .timeout(Duration(seconds: timeoutSeconds));
      } else if (method == "DELETE") {
        response = await http
            .delete(
              uri,
              headers: headers,
            )
            .timeout(Duration(seconds: timeoutSeconds));
      } else {
        throw AppException("Invalid method");
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.body;
      } else if (response.statusCode == 401) {
        if (context != null && context.mounted) {
          Navigator.pushReplacementNamed(context, '/signin');
        }
      } else if (response.statusCode == 400) {
        final data = await jsonDecode(response.body);

        throw AppException(data['error']);
      } else {
        throw AppException("Failed to load data");
      }
    } on TimeoutException {
      throw AppException("Request timed out. Please try again!");
    } on SocketException {
      throw AppException("No internet connection or server is anavailable.");
    } on FormatException {
      throw AppException("Invalid response from server.");
    } catch (error) {
      throw AppException(error.toString());
    }
  }
}
