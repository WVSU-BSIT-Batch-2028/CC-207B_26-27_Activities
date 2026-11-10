class Movie {
  final String imdbId;
  final String title;
  final String? year;
  final String? poster;

  const Movie({
    required this.imdbId,
    required this.title,
    this.year,
    this.poster,
  });

  String? get posterUrl => (poster != null && poster != 'N/A') ? poster : null;

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    imdbId: json['imdbID'] as String? ?? '',
    title: json['Title'] as String? ?? 'Untitled',
    year: json['Year'] as String?,
    poster: json['Poster'] as String?,
  );
}

