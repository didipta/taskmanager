import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Ui/controllers/auth_controller.dart';
import '../../Ui/screen/sign_in_screen.dart';
import '../../app.dart';
import '../models/network_response.dart';
import 'package:http/http.dart' as http;

class NetworkInterceptor {
  static Future<NetworkResponse> request(
      String url, {
        required String method,
        Map<String, dynamic>? body,
      }) async {
    try {
      debugPrint('Request URL: $url');
      debugPrint('Request Body: $body');

      final uri = Uri.parse(url);
      final headers = {
        'Content-type': 'application/json',
        'token': AuthController.accessToken,
      };

      http.Response response;

      if (method == 'GET') {
        response = await http.get(uri, headers: headers);
      } else if (method == 'POST') {
        response = await http.post(uri, headers: headers, body: jsonEncode(body));
      } else if (method == 'PUT') {
        response = await http.put(uri, headers: headers, body: jsonEncode(body));
      } else if (method == 'DELETE') {
        response = await http.delete(uri, headers: headers);
      } else {
        throw UnsupportedError('Method not supported');
      }

      debugPrint('Response Status: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      return NetworkResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  static NetworkResponse _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final decodedData = jsonDecode(response.body);
      return NetworkResponse(
        statusCode: response.statusCode,
        isSuccess: true,
        responseData: decodedData,
      );
    } else if (response.statusCode == 401) {
      redirectToLogin();
      return NetworkResponse(
        statusCode: response.statusCode,
        isSuccess: false,
      );
    } else {
      return NetworkResponse(
        statusCode: response.statusCode,
        isSuccess: false,
        errorMessage: response.body,
      );
    }
  }

  static Future<void> redirectToLogin() async {
    await AuthController.clearAllData();
    Navigator.pushAndRemoveUntil(
      Taskmanager.navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
          (route) => false,
    );
  }
}