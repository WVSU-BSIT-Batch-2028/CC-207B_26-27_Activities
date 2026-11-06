class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class Book {
  const Book({
    required this.workId,
    required this.title,
    required this.authors,
    this.year,
    this.coverId,
  });

  final String workId;
  final String title;
  final List<String> authors;
  final int? year;
  final int? coverId;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    workId: (json['key'] as String).split('/').last,
    title: json['title'] as String,
    // author_name is missing for some books, and it is a list.
    authors: [...?(json['author_name'] as List<dynamic>?)?.cast<String>()],
    year: json['first_publish_year'] as int?,
    coverId: json['cover_i'] as int?,
  );

  String? get coverUrl => coverId == null
      ? null
      : 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
}

class Movie {
  const Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    this.poster,
  });

  final String imdbId;
  final String title;
  final String year;
  final String? poster;

  factory Movie.fromJson(Map<String, dynamic> json) {
    final poster = json['Poster'] as String?;
    return Movie(
      imdbId: json['imdbID'] as String,
      title: json['Title'] as String,
      year: json['Year'] as String? ?? '',
      poster: (poster == null || poster == 'N/A') ? null : poster,
    );
  }
}

class Pick {
  const Pick({
    required this.id,
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  final String id;
  final String title;

  final String kind;

  final String externalId;
  final String note;

  bool get isBook => kind == 'book';
}

class PickDetails {
  const PickDetails({required this.summary, this.imageUrl, this.year});

  final String summary;
  final String? imageUrl;
  final String? year;
}
