class Movie {
  final String imdbId;
  final String title;
  final String year;
  final String? posterUrl;

  const Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    this.posterUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        imdbId: json['imdbID'] as String? ?? '',
        title: json['Title'] as String? ?? 'Untitled',
        year: json['Year'] as String? ?? 'Year unavailable',
        posterUrl: _posterFrom(json['Poster']),
      );

  static String? _posterFrom(dynamic value) {
    if (value is! String || value == 'N/A' || value.trim().isEmpty) {
      return null;
    }
    return value;
  }
}

class MovieDetails {
  final String title;
  final String year;
  final String plot;
  final String? posterUrl;

  const MovieDetails({
    required this.title,
    required this.year,
    required this.plot,
    this.posterUrl,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) => MovieDetails(
        title: json['Title'] as String? ?? 'Untitled',
        year: json['Year'] as String? ?? 'Year unavailable',
        plot: json['Plot'] as String? ?? 'No summary available.',
        posterUrl: Movie._posterFrom(json['Poster']),
      );
}
