class Movie {
  final String id;
  final String title;
  final String year;
  final String poster;

  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.poster,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['imdbID']?.toString() ?? '',
      title: json['Title']?.toString() ?? 'Untitled',
      year: json['Year']?.toString() ?? 'Unknown',
      poster: json['Poster']?.toString() ?? 'N/A',
    );
  }

  bool get hasPoster => poster != 'N/A' && poster.isNotEmpty;
}