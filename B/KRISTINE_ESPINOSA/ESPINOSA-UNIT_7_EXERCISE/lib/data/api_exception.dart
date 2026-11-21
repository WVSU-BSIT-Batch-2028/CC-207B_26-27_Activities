import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

Future<Object?> getJson(
  http.Client client,
  Uri uri, {
  required String name,
  Map<String, String> headers = const {},
}) async {
  final http.Response response;
  try {
    response = await client
        .get(uri, headers: headers)
        .timeout(const Duration(seconds: 10));
  } on TimeoutException {
    throw ApiException('$name took too long to answer. Try again.');
  } on http.ClientException {
    throw const ApiException(
      'No connection. Check your internet and try again.',
    );
  }
  switch (response.statusCode) {
    case 200:
      return jsonDecode(response.body);
    case 401 || 403:
      throw ApiException(
        '$name refused the request (${response.statusCode}). Check your key or token.',
      );
    case 404:
      throw ApiException('$name could not find it (404).');
    case >= 500:
      throw ApiException(
        '$name is having problems (${response.statusCode}). Try again later.',
      );
    default:
      throw ApiException('$name answered ${response.statusCode}.');
  }
}
