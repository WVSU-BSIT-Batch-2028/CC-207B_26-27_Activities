class Movie {
  const Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    required this.posterUrl,
  });

  final String imdbId;
  final String title;
  final String year;
  final String? posterUrl;

  factory Movie.fromJson(Map<String, dynamic> json) {
    final poster = json['Poster'] as String?;
    return Movie(
      imdbId: json['imdbID'] as String? ?? '',
      title: json['Title'] as String? ?? '',
      year: json['Year'] as String? ?? '',
      posterUrl: poster == null || poster == 'N/A' ? null : poster,
    );
  }
}

class MovieDetails {
  const MovieDetails({
    required this.title,
    required this.year,
    required this.summary,
    required this.posterUrl,
  });

  final String title;
  final String year;
  final String summary;
  final String? posterUrl;
}
