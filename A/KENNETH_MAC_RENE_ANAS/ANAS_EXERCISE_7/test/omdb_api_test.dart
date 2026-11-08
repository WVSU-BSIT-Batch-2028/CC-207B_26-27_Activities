import 'dart:convert';

import 'package:anas_unit7_exercise/data/api_exception.dart';
import 'package:anas_unit7_exercise/data/omdb_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('returns an empty result for OMDb movie-not-found response', () async {
    final api = OmdbApi(
      MockClient(
        (_) async => http.Response(
          jsonEncode({'Response': 'False', 'Error': 'Movie not found!'}),
          200,
        ),
      ),
      apiKey: 'key',
    );

    expect(await api.search('no matching title'), isEmpty);
  });

  test('surfaces OMDb API-key errors even when HTTP status is 200', () async {
    final api = OmdbApi(
      MockClient(
        (_) async => http.Response(
          jsonEncode({'Response': 'False', 'Error': 'Invalid API key!'}),
          200,
        ),
      ),
      apiKey: 'bad-key',
    );

    await expectLater(
      api.search('Interstellar'),
      throwsA(
        isA<ApiException>().having(
          (error) => error.message,
          'message',
          'Invalid API key!',
        ),
      ),
    );
  });

  test('shows OMDb API-key errors returned with HTTP 401', () async {
    final api = OmdbApi(
      MockClient(
        (_) async => http.Response(
          jsonEncode({'Response': 'False', 'Error': 'Invalid API key!'}),
          401,
        ),
      ),
      apiKey: 'bad-key',
    );

    await expectLater(
      api.search('Interstellar'),
      throwsA(
        isA<ApiException>().having(
          (error) => error.message,
          'message',
          'Invalid API key!',
        ),
      ),
    );
  });
}
