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
      id: json['imdbID'] ?? '',
      title: json['Title'] ?? 'Untitled',
      year: json['Year'] ?? 'Unknown year',
      poster: json['Poster'] ?? 'N/A',
    );
  }
}
