class Movie {
  final String imdbId;
  final String title;
  final String year;
  final String poster;

  Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    required this.poster,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      imdbId: json['imdbID'] as String,
      title: json['Title'] as String,
      year: json['Year'] as String? ?? 'Unknown year',
      poster: json['Poster'] as String? ?? 'N/A',
    );
  }
}
