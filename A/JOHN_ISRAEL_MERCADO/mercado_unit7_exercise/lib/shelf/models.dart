class Book {
  final String workId;
  final String title;
  final List<String> authors;
  final int? year;
  final int? coverId;

  const Book({
    required this.workId,
    required this.title,
    required this.authors,
    this.year,
    this.coverId,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    workId: (json['key'] as String).split('/').last,
    title: json['title'] as String,
    authors: [...?(json['author_name'] as List<dynamic>?)?.cast<String>()],
    year: json['first_publish_year'] as int?,
    coverId: json['cover_i'] as int?,
  );
}

class Movie {
  final String imdbId;
  final String title;
  final String year;
  final String? poster;

  const Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    this.poster,
  });

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
  final String title;
  final String kind;
  final String externalId;
  final String note;

  const Pick({
    required this.title,
    required this.kind,
    required this.externalId,
    required this.note,
  });

  factory Pick.fromJson(Map<String, dynamic> json) {
    final fields = (json['fields'] as Map<String, dynamic>?) ?? {};
    return Pick(
      title: fields['title'] as String? ?? 'Untitled',
      kind: fields['kind'] as String? ?? 'book',
      externalId: fields['externalId'] as String? ?? '',
      note: fields['note'] as String? ?? '',
    );
  }
}

class ItemDetails {
  final String title;
  final String? imageUrl;
  final String summary;

  const ItemDetails({
    required this.title,
    this.imageUrl,
    required this.summary,
  });
}
