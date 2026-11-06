class Movie {
  const Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    this.posterUrl,
  });

  final String imdbId;
  final String title;
  final String year;
  final String? posterUrl;

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    imdbId: json['imdbID'] as String,
    title: json['Title'] as String? ?? 'Untitled movie',
    year: json['Year'] as String? ?? 'Unknown year',
    posterUrl: posterUrlFromJson(json['Poster']),
  );
}

String? posterUrlFromJson(dynamic value) {
  if (value is! String || value.isEmpty || value == 'N/A') return null;
  final uri = Uri.tryParse(value);
  return uri != null &&
          uri.host.isNotEmpty &&
          (uri.scheme == 'https' || uri.scheme == 'http')
      ? value
      : null;
}
