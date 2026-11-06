import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

typedef JsonMap = Map<String, dynamic>;

// --- MODELS ---
class Book {
  final String workId;
  final String title;
  final List<String> authors;
  final int? year;
  final int? coverId;

  Book({
    required this.workId,
    required this.title,
    required this.authors,
    this.year,
    this.coverId,
  });

  factory Book.fromJson(JsonMap json) {
    final rawAuthors = json['author_name'] as List<dynamic>?;
    final authorList = rawAuthors != null ? rawAuthors.cast<String>() : <String>[];

    return Book(
      workId: (json['key'] as String).split('/').last,
      title: json['title'] as String,
      authors: authorList,
      year: json['first_publish_year'] as int?,
      coverId: json['cover_i'] as int?,
    );
  }

  String? get coverUrl => coverId != null
      ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
      : null;
}

class Movie {
  final String imdbId;
  final String title;
  final String year;
  final String? poster;

  Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    this.poster,
  });

  factory Movie.fromJson(JsonMap json) => Movie(
        imdbId: json['imdbID'] as String,
        title: json['Title'] as String,
        year: json['Year'] as String,
        poster: (json['Poster'] != null && json['Poster'] != 'N/A')
            ? json['Poster'] as String
            : null,
      );
}

class Pick {
  final String id;
  final String title;
  final String kind;
  final String externalId;
  final String note;

  Pick({
    required this.id,
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  factory Pick.fromContentful(JsonMap json) {
    final fields = json['fields'] as JsonMap;
    return Pick(
      id: json['sys']['id'] as String,
      title: fields['title'] as String? ?? '',
      kind: fields['kind'] as String? ?? 'book',
      externalId: fields['externalId'] as String? ?? '',
      note: fields['note'] as String? ?? '',
    );
  }
}

// --- API SERVICES ---
class OpenLibraryApi {
  static Future<List<Book>> search(String query) async {
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'q': query,
      'fields': 'key,title,author_name,first_publish_year,cover_i',
      'limit': '20',
    });
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as JsonMap;
      final docs = json['docs'] as List<dynamic>? ?? [];
      return docs.map((d) => Book.fromJson(d as JsonMap)).toList();
    }
    throw Exception('Failed to search books');
  }

  static Future<JsonMap> fetchDetails(String workId) async {
    final uri = Uri.https('openlibrary.org', '/works/$workId.json');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as JsonMap;
      final description = switch (json['description']) {
        final String text => text,
        {'value': final String text} => text,
        _ => 'No description yet.',
      };
      return {
        'title': json['title'] as String? ?? 'Unknown Title',
        'description': description,
      };
    }
    throw Exception('Failed to load book details');
  }
}

class OmdbApi {
  static Future<List<Movie>> search(String query) async {
    if (AppConfig.omdbKey.isEmpty) {
      throw Exception('OMDb API Key missing. Pass --dart-define=OMDB_KEY=yourkey');
    }
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': AppConfig.omdbKey,
      's': query,
      'type': 'movie',
    });
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as JsonMap;
      if (json['Response'] == 'False') {
        final error = json['Error'] as String? ?? 'Movie not found!';
        if (error == 'Movie not found!') return [];
        throw Exception(error);
      }
      final search = json['Search'] as List<dynamic>? ?? [];
      return search.map((m) => Movie.fromJson(m as JsonMap)).toList();
    }
    throw Exception('Failed to search movies');
  }

  static Future<JsonMap> fetchDetails(String imdbId) async {
    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': AppConfig.omdbKey,
      'i': imdbId,
      'plot': 'short',
    });
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as JsonMap;
      return {
        'title': json['Title'] as String? ?? 'Unknown Title',
        'year': json['Year'] as String? ?? '',
        'poster': (json['Poster'] != null && json['Poster'] != 'N/A')
            ? json['Poster'] as String
            : null,
        'description': json['Plot'] as String? ?? 'No plot available.',
      };
    }
    throw Exception('Failed to load movie details');
  }
}

class ContentfulPickSource {
  static Future<List<Pick>> fetchPicks() async {
    final uri = Uri.https(
      'cdn.contentful.com',
      '/spaces/${AppConfig.contentfulSpaceId}/environments/master/entries',
      {'content_type': 'pick'},
    );
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer ${AppConfig.contentfulToken}'},
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as JsonMap;
      final items = json['items'] as List<dynamic>? ?? [];
      return items.map((i) => Pick.fromContentful(i as JsonMap)).toList();
    }
    throw Exception('Failed to fetch picks from Contentful');
  }
}