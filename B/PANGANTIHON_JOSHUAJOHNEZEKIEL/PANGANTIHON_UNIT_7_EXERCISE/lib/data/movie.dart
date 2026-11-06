class Movie {
  const Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    required this.poster,
    this.plot,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    imdbId: json['imdbID'] as String? ?? '',
    title: json['Title'] as String? ?? 'Untitled',
    year: json['Year'] as String? ?? 'Unknown year',
    poster: json['Poster'] as String? ?? 'N/A',
    plot: json['Plot'] as String?,
  );

  final String imdbId;
  final String title;
  final String year;
  final String poster;
  final String? plot;

  bool get hasPoster => poster.isNotEmpty && poster != 'N/A';
}
