
class MovieDetails {
  final String title;
  final String plot;
  final String director;
  final String actors;
  final String genre;
  final String rated;
  final String runtime;
  final String released;
  final String poster;
  final String imdbRating;

  const MovieDetails({
    required this.title,
    required this.plot,
    required this.director,
    required this.actors,
    required this.genre,
    required this.rated,
    required this.runtime,
    required this.released,
    required this.poster,
    required this.imdbRating,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      title: json['Title'] ?? 'Unknown title',
      plot: json['Plot'] ?? 'No plot available.',
      director: json['Director'] ?? 'Unknown',
      actors: json['Actors'] ?? 'Unknown',
      genre: json['Genre'] ?? 'Unknown',
      rated: json['Rated'] ?? 'N/A',
      runtime: json['Runtime'] ?? 'Unknown',
      released: json['Released'] ?? 'Unknown',
      poster: json['Poster'] ?? '',
      imdbRating: json['imdbRating'] ?? 'N/A',
    );
  }
}
