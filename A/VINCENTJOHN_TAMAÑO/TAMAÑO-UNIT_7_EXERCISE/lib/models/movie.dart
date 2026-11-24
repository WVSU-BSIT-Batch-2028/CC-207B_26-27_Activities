class Movie {
  final String title;
  final String year;
  final String imdbId;
  final String? poster;

  const Movie({
    required this.title,
    required this.year,
    required this.imdbId,
    this.poster,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        title: json['Title'] as String? ?? 'Untitled',
        year: json['Year'] as String? ?? '',
        imdbId: json['imdbID'] as String? ?? '',
        poster: (json['Poster'] == null || json['Poster'] == 'N/A')
            ? null
            : json['Poster'] as String?,
      );
}

