class Movie {
  final String imdbId;
  final String title;
  final String year;
  final String poster;

  const Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    required this.poster,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      imdbId: json['imdbID'] ?? '',
      title: json['Title'] ?? 'Untitled',
      year: json['Year'] ?? 'Unknown year',
      poster: json['Poster'] ?? '',
    );
  }
}
