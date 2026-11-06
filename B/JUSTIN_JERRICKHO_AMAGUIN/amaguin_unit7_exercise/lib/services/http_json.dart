import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exception.dart';

Future<Map<String, dynamic>> getJson(
  http.Client client,
  Uri uri, {
  Map<String, String>? headers,
}) async {
  try {
    final response = await client
        .get(uri, headers: headers)
        .timeout(const Duration(seconds: 20));
    switch (response.statusCode) {
      case 200:
        break;
      case 401 || 403:
        throw const ApiException(
          'Access denied. Check your API key or Contentful delivery token.',
        );
      case 404:
        throw const ApiException(
          'Not found. Check the ID, Contentful space, and environment.',
        );
      case 429:
        throw const ApiException(
          'Request limit reached. Please try again later.',
        );
      case >= 500:
        throw const ApiException(
          'The service is unavailable. Please try again later.',
        );
      default:
        throw ApiException(
          'Request failed (${response.statusCode}). Check your Contentful content type and settings.',
        );
    }
    final json = jsonDecode(response.body);
    if (json is! Map<String, dynamic>) throw const FormatException();
    return json;
  } on TimeoutException {
    throw const ApiException('The request timed out. Please try again.');
  } on http.ClientException {
    throw const ApiException(
      'Could not connect. Check your internet connection and try again.',
    );
  } on FormatException {
    throw const ApiException(
      'The service returned an unexpected response. Please try again.',
    );
  }
}
