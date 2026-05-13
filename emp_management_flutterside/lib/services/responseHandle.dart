import 'dart:convert';
import 'package:http/http.dart' as http;

dynamic handleResponse(http.Response response) {
  try {
    final body = response.body;

    dynamic data;

    // SAFE JSON parsing
    if (body.isNotEmpty) {
      try {
        data = jsonDecode(body);
      } catch (_) {
        data = body; // fallback for plain text responses
      }
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        return data;

      case 204:
        return true;

      case 400:
      case 401:
      case 403:
      case 404:
      case 500:
        final message = (data is Map && data['message'] != null)
            ? data['message']
            : "Server Error (${response.statusCode})";

        throw Exception(message);

      default:
        throw Exception(
          "Unexpected Error: ${response.statusCode}",
        );
    }
  } catch (e) {
    throw Exception("Response Processing Failed: $e");
  }
}