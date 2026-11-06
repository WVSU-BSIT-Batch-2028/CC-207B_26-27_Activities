class Movie {
  final String imdbId;
  final String title;
  final String year;
  final String poster;
  final String type;

  const Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    required this.poster,
    required this.type,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      imdbId: json['imdbID']?.toString() ?? '',
      title: json['Title']?.toString() ?? 'Unknown Title',
      year: json['Year']?.toString() ?? 'N/A',
      poster: json['Poster']?.toString() ?? '',
      type: json['Type']?.toString() ?? 'movie',
    );
  }
}