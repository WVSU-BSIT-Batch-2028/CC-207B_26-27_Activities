class Movie {
  const Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    required this.posterUrl,
    this.summary = '',
  });

  final String imdbId;
  final String title;
  final String year;
  final String? posterUrl;
  final String summary;

  factory Movie.fromJson(Map<String, dynamic> json) {
    final poster = json['Poster'] as String?;
    return Movie(
      imdbId: json['imdbID'] as String,
      title: json['Title'] as String? ?? 'Untitled',
      year: json['Year'] as String? ?? '',
      posterUrl: poster == null || poster == 'N/A' ? null : poster,
      summary: json['Plot'] as String? ?? '',
    );
  }
}
