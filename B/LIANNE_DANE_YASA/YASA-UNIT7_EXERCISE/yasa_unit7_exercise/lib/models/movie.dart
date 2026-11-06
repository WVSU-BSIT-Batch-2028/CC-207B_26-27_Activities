class Movie {
  final String title;
  final String year;
  final String imdbId;
  final String poster;

  const Movie({
    required this.title,
    required this.year,
    required this.imdbId,
    required this.poster,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'] as String? ?? 'Unknown title',
      year: json['Year'] as String? ?? 'Unknown year',
      imdbId: json['imdbID'] as String? ?? '',
      poster: json['Poster'] as String? ?? 'N/A',
    );
  }

  bool get hasPoster {
    return poster.isNotEmpty && poster != 'N/A';
  }
}
