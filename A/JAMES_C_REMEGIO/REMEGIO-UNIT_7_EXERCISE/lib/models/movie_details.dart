import '../api/api_exception.dart';
import 'movie.dart';

/// Fields read from an OMDb title lookup (`i` and `plot=short`).
class MovieDetails {
  const MovieDetails({
    required this.title,
    required this.year,
    required this.posterUrl,
    required this.summary,
  });

  final String title;
  final String? year;
  final String? posterUrl;
  final String summary;

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    if (json['Response'] == 'False') {
      final Object? error = json['Error'];
      throw ApiException(error is String ? error : 'OMDb error');
    }
    final Object? title = json['Title'];
    return MovieDetails(
      title: title is String && title.trim().isNotEmpty
          ? title.trim()
          : 'Untitled',
      year: movieYear(json['Year']),
      posterUrl: posterUrlOrNull(json['Poster']),
      summary: movieSummary(json['Plot']),
    );
  }
}

/// Plot text, with OMDb's `N/A` treated as no summary.
String movieSummary(Object? plot) {
  if (plot is! String) return 'No description yet.';
  final String trimmed = plot.trim();
  if (trimmed.isEmpty || trimmed == 'N/A') return 'No description yet.';
  return trimmed;
}
