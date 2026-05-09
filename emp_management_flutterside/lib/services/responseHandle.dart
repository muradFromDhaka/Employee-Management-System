import 'dart:convert';

import 'package:http/http.dart' as http;


// =========================
  // COMMON RESPONSE HANDLER
  // =========================
dynamic handleResponse(http.Response response) {
  final statusCode = response.statusCode;

  try {
    final responseData = response.body.isNotEmpty
        ? jsonDecode(response.body)
        : null;

    switch (statusCode) {

      // SUCCESS
      case 200:
      case 201:
        return responseData;

      case 204:
        return true;

      // CLIENT ERROR
      case 400:
        throw Exception(
          responseData?['message'] ?? 'Bad Request',
        );

      case 401:
        throw Exception(
          responseData?['message'] ?? 'Unauthorized Access',
        );

      case 403:
        throw Exception(
          responseData?['message'] ?? 'Access Forbidden',
        );

      case 404:
        throw Exception(
          responseData?['message'] ?? 'Resource Not Found',
        );

      // SERVER ERROR
      case 500:
        throw Exception(
          responseData?['message'] ?? 'Internal Server Error',
        );

      default:
        throw Exception(
          'Something went wrong! Status Code: $statusCode',
        );
    }
  } catch (e) {
    throw Exception('Response Processing Error: $e');
  }
}