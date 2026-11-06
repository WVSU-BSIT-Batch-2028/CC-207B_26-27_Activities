import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// An error with a message that is safe to show to the user.
class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// The message to show for any error caught by a FutureBuilder.
String errorText(Object? error) {
  if (error is ApiException) return error.message;
  return 'Something went wrong. Please try again.';
}

/// GET with a timeout. Turns "no internet" and "too slow" into [ApiException].
Future<http.Response> sendGet(
  http.Client client,
  Uri uri, {
  Map<String, String>? headers,
}) async {
  try {
    return await client
        .get(uri, headers: headers)
        .timeout(const Duration(seconds: 10));
  } on TimeoutException {
    throw const ApiException('The server took too long to answer. Try again.');
  } catch (_) {
    throw const ApiException('No connection. Check your internet and try again.');
  }
}

String statusMessage(String who, int code) {
  if (code == 401 || code == 403) {
    return '$who refused the request ($code). Check your key or token.';
  }
  if (code == 404) return '$who could not find that (404).';
  if (code >= 500) return '$who is having problems ($code). Try again later.';
  return '$who answered $code.';
}

/// Decodes a JSON body as UTF-8. (response.body would read it as Latin-1 when
/// the server sends no charset, and titles like "Pokémon" would be garbled.)
Object? decodeJson(http.Response response, String who) {
  try {
    return jsonDecode(utf8.decode(response.bodyBytes));
  } on FormatException {
    throw ApiException('$who sent something the app cannot read.');
  }
}

/// GET a URL and return its JSON when the status is 200.
Future<Object?> getJson(
  http.Client client,
  Uri uri, {
  required String who,
  Map<String, String>? headers,
}) async {
  final response = await sendGet(client, uri, headers: headers);
  if (response.statusCode != 200) {
    throw ApiException(statusMessage(who, response.statusCode));
  }
  return decodeJson(response, who);
}
