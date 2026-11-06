import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

Future<Map<String, dynamic>> getJson(
  http.Client client,
  Uri uri, {
  Map<String, String> headers = const {},
  required String service,
}) async {
  final http.Response response;
  try {
    response = await client
        .get(uri, headers: headers)
        .timeout(const Duration(seconds: 15));
  } on TimeoutException {
    throw ApiException('$service took too long to answer. Try again.');
  } on http.ClientException {
    throw ApiException('Could not connect to $service. Check your connection.');
  }

  if (response.statusCode == 401 || response.statusCode == 403) {
    if (service == 'OMDb') {
      throw const ApiException(
        'OMDb rejected the API key. Check that the key is correct and activated, then restart the app with your OMDB_KEY.',
      );
    }
    final guidance = service == 'Strapi'
        ? ' Check the Public find permission or use a read-only token.'
        : '';
    throw ApiException(
      '$service refused the request (${response.statusCode}).$guidance',
    );
  }
  if (response.statusCode == 404) {
    throw ApiException(
      '$service could not find the requested resource (404). Check the URL and ID.',
    );
  }
  if (response.statusCode != 200) {
    throw ApiException(
      '$service returned an error (${response.statusCode}). Try again later.',
    );
  }

  try {
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) return decoded;
  } on FormatException {
    throw ApiException('$service returned an invalid response.');
  }
  throw ApiException('$service returned an unexpected response.');
}
