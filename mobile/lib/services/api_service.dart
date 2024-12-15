import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:foodly/services/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

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

      switch (method) {
        case 'GET':
          response = await http
              .get(
                uri,
                headers: headers,
              )
              .timeout(Duration(seconds: timeoutSeconds));
          break;
        case 'POST':
          response = await http
              .post(
                uri,
                headers: headers,
                body: body,
              )
              .timeout(Duration(seconds: timeoutSeconds));
          break;
        case 'PUT':
          response = await http
              .put(
                uri,
                headers: headers,
                body: body,
              )
              .timeout(Duration(seconds: timeoutSeconds));
          break;
        case 'DELETE':
          response = await http
              .delete(
                uri,
                headers: headers,
              )
              .timeout(Duration(seconds: timeoutSeconds));
          break;
        default:
          throw AppException('Invalid method');
      }

      return _handleResponse(response, context);
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

  Future<dynamic> httpReqWithFile({
    required String url,
    required String method,
    required Map<String, String> headers,
    required File file,
    required String field,
    int timeoutSeconds = 10,
    BuildContext? context,
  }) async {
    try {
      final uri = Uri.parse("http://10.0.2.2:3000$url");

      final request = http.MultipartRequest(method, uri)
        ..headers.addAll(headers)
        ..files.add(
          await http.MultipartFile.fromPath(
            field,
            file.path,
            filename: path.basename(file.path),
          ),
        );

      final streamedResponse =
          await request.send().timeout(Duration(seconds: timeoutSeconds));
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response, context);
    } catch (error) {
      throw AppException(error.toString());
    }
  }

  dynamic _handleResponse(http.Response response, BuildContext? context) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response.body;
      case 400:
        final data = jsonDecode(response.body);
        throw AppException(data['error']);
      case 401:
        if (context != null) {
          Navigator.pushReplacementNamed(context, '/signin');
        }
        throw AppException("Unauthorized");
      case 403:
        throw AppException("Forbidden");
      case 404:
        throw AppException("Not Found");
      case 500:
        throw AppException("Internal Server Error");
      default:
        throw AppException("Failed to load data: ${response.statusCode}");
    }
  }
}
