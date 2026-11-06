/// One OMDb search hit.
class Movie {
  const Movie({
    required this.imdbId,
    required this.title,
    required this.year,
    required this.posterUrl,
  });

  final String imdbId;
  final String title;
  final String? year;

  /// Null when OMDb omits the poster or sends `N/A`.
  final String? posterUrl;

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      imdbId: json['imdbID'] as String,
      title: json['Title'] as String,
      year: movieYear(json['Year']),
      posterUrl: posterUrlOrNull(json['Poster']),
    );
  }

  String get yearLabel => year ?? 'Year unknown';
}

/// A poster URL, or null when the artwork is missing.
String? posterUrlOrNull(Object? poster) {
  if (poster is! String) return null;
  final String trimmed = poster.trim();
  if (trimmed.isEmpty || trimmed == 'N/A') return null;
  return trimmed;
}

/// OMDb years are strings. `N/A` and blanks count as missing.
String? movieYear(Object? year) {
  if (year is! String) return null;
  final String trimmed = year.trim();
  if (trimmed.isEmpty || trimmed == 'N/A') return null;
  return trimmed;
}
