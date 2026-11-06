
class Movie {
  final String imdbId;
  final String title;
  final String year;
  final String? poster;

  const Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    this.poster,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final posterValue = json['Poster'] as String?;

    return Movie(
      imdbId: json['imdbID'] as String? ?? '',
      title: json['Title'] as String? ?? 'Untitled',
      year: json['Year'] as String? ?? 'Unknown year',
      poster: posterValue != null && posterValue != 'N/A'
          ? posterValue
          : null,
    );
  }
}
