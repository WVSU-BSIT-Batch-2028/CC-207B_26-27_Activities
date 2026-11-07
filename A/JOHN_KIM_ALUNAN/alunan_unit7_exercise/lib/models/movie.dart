class Movie {
  const Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    this.poster,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    imdbId: json['imdbID'] as String,
    title: json['Title'] as String,
    year: json['Year'] as String,
    poster: json['Poster'] == 'N/A' ? null : json['Poster'] as String?,
  );

  final String imdbId;
  final String title;
  final String year;
  final String? poster;
}

class MovieDetails {
  const MovieDetails({
    required this.title,
    required this.year,
    required this.plot,
    this.poster,
  });

  final String title;
  final String year;
  final String plot;
  final String? poster;
}
