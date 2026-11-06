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

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    imdbId: json['imdbID'] as String,
    title: json['Title'] as String,
    year: json['Year'] as String,
    poster: posterOrNull(json['Poster']),
  );
}

/// OMDb writes "N/A" when there is no poster.
String? posterOrNull(Object? value) {
  if (value is String && value.isNotEmpty && value != 'N/A') return value;
  return null;
}
