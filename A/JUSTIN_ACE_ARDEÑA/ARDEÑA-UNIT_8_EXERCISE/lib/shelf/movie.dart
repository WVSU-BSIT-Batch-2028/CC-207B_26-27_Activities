/// One movie from an OMDb search.
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

  /// null when OMDb has no poster.
  final String? poster;

  factory Movie.fromJson(Map<String, dynamic> json) {
    final poster = json['Poster'] as String?;
    return Movie(
      imdbId: json['imdbID'] as String,
      title: json['Title'] as String? ?? '',
      year: json['Year'] as String? ?? '',
      // OMDb writes "N/A" instead of leaving the field out.
      poster: (poster == null || poster == 'N/A') ? null : poster,
    );
  }
}

