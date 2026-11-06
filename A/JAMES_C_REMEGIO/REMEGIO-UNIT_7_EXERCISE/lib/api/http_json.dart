import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exception.dart';

/// Sends one GET and decodes the body, or throws an [ApiException].
Future<Object?> getJson(
  http.Client client,
  Uri uri, {
  required String service,
  Map<String, String> headers = const {},
  Duration timeout = const Duration(seconds: 10),
}) async {
  final http.Response response;
  try {
    response = await client.get(uri, headers: headers).timeout(timeout);
  } on TimeoutException {
    throw ApiException('$service took too long to answer. Try again.');
  } on http.ClientException {
    throw const ApiException(
      'No connection. Check your internet and try again.',
    );
  }
  return decodeBody(response, service);
}

/// Decodes a 200 response. Other status codes become a short message.
Object? decodeBody(http.Response response, String service) {
  final int code = response.statusCode;
  if (code == 200) {
    try {
      return jsonDecode(response.body);
    } on FormatException {
      throw ApiException(
        '$service sent a response that is not valid JSON. Check the URL.',
      );
    }
  }
  if (code == 400 && response.body.contains('unknownContentType')) {
    throw const ApiException(
      'Contentful has no content type with the id pick. '
      'Create the Pick content type, publish it, then try again.',
    );
  }
  switch (code) {
    case 401 || 403:
      throw ApiException(
        '$service refused the request ($code). '
        'Check the token and the read permission.',
      );
    case 404:
      throw ApiException(
        '$service could not find that page (404). '
        'Check the URL and the id.',
      );
    case >= 500:
      throw ApiException(
        '$service is having problems ($code). Try again later.',
      );
    default:
      throw ApiException('$service answered $code.');
  }
}

/// A JSON object, or an [ApiException] when the body is something else.
Future<Map<String, dynamic>> getJsonMap(
  http.Client client,
  Uri uri, {
  required String service,
  Map<String, String> headers = const {},
}) async {
  final Object? decoded = await getJson(
    client,
    uri,
    service: service,
    headers: headers,
  );
  if (decoded is Map<String, dynamic>) return decoded;
  if (decoded is Map) return Map<String, dynamic>.from(decoded);
  throw ApiException('$service sent a response that is not a JSON object.');
}
