import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/fair_event.dart';

abstract interface class EventSource {
  String get name;

  Future<List<FairEvent>> fetchEvents();
}

class CmsException implements Exception {
  const CmsException(this.message);

  final String message;

  @override
  String toString() => message;
}

Future<Object?> getJson(
  http.Client client,
  Uri uri, {
  required String cms,
  Map<String, String> headers = const {},
}) async {
  final http.Response response;
  try {
    response = await client
        .get(uri, headers: headers)
        .timeout(const Duration(seconds: 10));
  } on TimeoutException {
    throw CmsException('$cms took too long to answer. Try again.');
  } on http.ClientException {
    throw const CmsException(
      'No connection. Check your internet and try again.',
    );
  }
  return decodeOrThrow(response, cms);
}

Object? decodeOrThrow(http.Response response, String cms) {
  final code = response.statusCode;
  switch (code) {
    case 200:
      return jsonDecode(response.body);
    case 401 || 403:
      throw CmsException(
        '$cms refused the request ($code). Check your token and the read permission.',
      );
    case 404:
      throw CmsException(
        '$cms could not find the events (404). Check the URL and the content type name.',
      );
    case >= 500:
      throw CmsException('$cms is having problems ($code). Try again later.');
    default:
      throw CmsException('$cms answered $code.');
  }
}
