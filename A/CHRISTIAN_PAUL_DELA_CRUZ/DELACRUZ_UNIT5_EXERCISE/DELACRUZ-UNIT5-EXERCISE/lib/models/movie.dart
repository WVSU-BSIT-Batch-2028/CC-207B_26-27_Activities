class Movie {
  const Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    required this.plot,
    this.posterUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final imdbId = json['imdbID'];
    final title = json['Title'];
    if (imdbId is! String || title is! String) {
      throw const FormatException('OMDb returned an invalid movie.');
    }
    final poster = json['Poster'] as String?;
    return Movie(
      imdbId: imdbId,
      title: title,
      year: json['Year'] as String? ?? 'Year unavailable',
      plot: json['Plot'] as String? ?? 'No plot available.',
      posterUrl: poster == null || poster == 'N/A' ? null : poster,
    );
  }

  final String imdbId;
  final String title;
  final String year;
  final String plot;
  final String? posterUrl;
}
