class Movie {
  const Movie({
    required this.imdbId,
    required this.title,
    this.year,
    this.posterUrl,
  });

  final String imdbId;
  final String title;
  final String? year;
  final String? posterUrl;

  factory Movie.fromJson(Map<String, dynamic> json) {
    final poster = json['Poster'] as String?;
    return Movie(
      imdbId: json['imdbID'] as String,
      title: json['Title'] as String,
      year: json['Year'] as String?,
      // OMDb sends the text "N/A" when a movie has no poster.
      posterUrl: (poster == null || poster == 'N/A') ? null : poster,
    );
  }
}