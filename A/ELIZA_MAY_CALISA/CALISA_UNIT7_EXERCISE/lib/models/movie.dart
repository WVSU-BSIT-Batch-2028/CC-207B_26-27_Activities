class Movie {
  const Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    this.poster,
  });

  final String imdbId;
  final String title;
  final String year;
  final String? poster;

  factory Movie.fromJson(Map<String, dynamic> json) {
    final poster = json['Poster'] as String?;
    return Movie(
      imdbId: json['imdbID'] as String,
      title: json['Title'] as String? ?? 'Untitled',
      year: json['Year'] as String? ?? '',
      // OMDb says "N/A" when there is no poster.
      poster: (poster == null || poster == 'N/A') ? null : poster,
    );
  }
}
