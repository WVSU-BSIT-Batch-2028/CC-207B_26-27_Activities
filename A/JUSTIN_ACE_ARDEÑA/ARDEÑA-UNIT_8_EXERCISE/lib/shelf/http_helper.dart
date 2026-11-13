import 'dart:async';

import 'package:http/http.dart' as http;

import 'api_exception.dart';

/// Sends a GET request and gives back the body text when the status is 200.
/// Any other status, a timeout or no internet becomes an [ApiException]
/// with a message the user can read.
Future<String> fetchBody(
  http.Client client,
  Uri uri, {
  required String name,
  Map<String, String> headers = const {},
}) async {
  final http.Response response;
  try {
    response =
        await client.get(uri, headers: headers).timeout(const Duration(seconds: 10));
  } on TimeoutException {
    throw ApiException('$name took too long. Try again.');
  } on http.ClientException {
    throw const ApiException('No connection. Check your internet.');
  }
  final code = response.statusCode;
  switch (code) {
    case 200:
      return response.body;
    case 401 || 403:
      throw ApiException('$name refused the request ($code). Check the key or token.');
    case 404:
      throw ApiException('$name could not find that (404).');
    case >= 500:
      throw ApiException('$name is having problems ($code). Try again later.');
    default:
      throw ApiException('$name answered $code.');
  }
}

