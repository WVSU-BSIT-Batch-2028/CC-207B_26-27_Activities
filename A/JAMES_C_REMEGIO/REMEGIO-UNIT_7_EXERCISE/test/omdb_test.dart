import 'dart:convert';

import 'package:cc207b_unit5/api/api_exception.dart';
import 'package:cc207b_unit5/api/omdb_api.dart';
import 'package:cc207b_unit5/models/movie.dart';
import 'package:cc207b_unit5/models/movie_details.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('Poster N/A and a missing poster are both missing artwork', () {
    expect(posterUrlOrNull('N/A'), isNull);
    expect(posterUrlOrNull(null), isNull);
    expect(posterUrlOrNull('  '), isNull);
    expect(
      posterUrlOrNull('https://example.test/poster.jpg'),
      'https://example.test/poster.jpg',
    );
    expect(movieYear('N/A'), isNull);
    expect(movieYear('2014'), '2014');

    final Movie movie = Movie.fromJson(<String, dynamic>{
      'Title': 'Interstellar',
      'Year': '2014',
      'imdbID': 'tt0816692',
      'Poster': 'N/A',
    });
    expect(movie.posterUrl, isNull);
    expect(movie.yearLabel, '2014');

    final MovieDetails details = MovieDetails.fromJson(<String, dynamic>{
      'Title': 'Interstellar',
      'Year': 'N/A',
      'Plot': 'N/A',
      'Poster': 'N/A',
      'Response': 'True',
    });
    expect(details.posterUrl, isNull);
    expect(details.year, isNull);
    expect(details.summary, 'No description yet.');
  });

  test('Movie not found is an empty list, and an invalid key is an error',
      () async {
    http.Request? sent;
    final http.Client client = MockClient((http.Request request) async {
      sent = request;
      final String query = request.url.queryParameters['s'] ?? '';
      if (query == 'missing-movie') {
        return http.Response(
          jsonEncode(<String, String>{
            'Response': 'False',
            'Error': 'Movie not found!',
          }),
          200,
        );
      }
      return http.Response(
        jsonEncode(<String, String>{
          'Response': 'False',
          'Error': 'Invalid API key!',
        }),
        200,
      );
    });
    final OmdbApi api = OmdbApi(apiKey: 'test-key', client: client);

    final List<Movie> empty = await api.search('missing-movie');
    expect(empty, isEmpty);
    expect(sent?.url.host, 'www.omdbapi.com');
    expect(sent?.url.queryParameters['apikey'], 'test-key');
    expect(sent?.url.queryParameters['s'], 'missing-movie');
    expect(sent?.url.queryParameters['type'], 'movie');

    await expectLater(
      api.search('interstellar'),
      throwsA(
        isA<ApiException>().having(
          (ApiException error) => error.message,
          'message',
          'Invalid API key!',
        ),
      ),
    );
    api.close();
  });

  test('a title lookup asks for a short plot and keeps a real poster',
      () async {
    late http.Request sent;
    final http.Client client = MockClient((http.Request request) async {
      sent = request;
      return http.Response(
        jsonEncode(<String, String>{
          'Title': 'Interstellar',
          'Year': '2014',
          'Plot': 'A voyage through a wormhole.',
          'Poster': 'https://example.test/interstellar.jpg',
          'Response': 'True',
        }),
        200,
      );
    });
    final OmdbApi api = OmdbApi(apiKey: 'test-key', client: client);
    final details = await api.fetchById('tt0816692');

    expect(sent.url.queryParameters['i'], 'tt0816692');
    expect(sent.url.queryParameters['plot'], 'short');
    expect(sent.url.queryParameters['apikey'], 'test-key');
    expect(details.title, 'Interstellar');
    expect(details.year, '2014');
    expect(details.summary, 'A voyage through a wormhole.');
    expect(details.posterUrl, 'https://example.test/interstellar.jpg');
    api.close();
  });

  test('an empty key does not call OMDb', () async {
    final http.Client client = MockClient((http.Request request) async {
      fail('OMDb was called without a key');
    });
    final OmdbApi api = OmdbApi(apiKey: '', client: client);
    await expectLater(
        api.search('interstellar'), throwsA(isA<MissingOmdbKey>()));
    api.close();
  });

  test('HTTP 401 invalid key uses the OMDb error text', () async {
    final http.Client client = MockClient((http.Request request) async {
      return http.Response(
        jsonEncode(<String, String>{
          'Response': 'False',
          'Error': 'Invalid API key!',
        }),
        401,
      );
    });
    final OmdbApi api = OmdbApi(apiKey: 'invalid', client: client);
    await expectLater(
      api.search('interstellar'),
      throwsA(
        isA<ApiException>().having(
          (ApiException error) => error.message,
          'message',
          'Invalid API key!',
        ),
      ),
    );
    api.close();
  });
}
