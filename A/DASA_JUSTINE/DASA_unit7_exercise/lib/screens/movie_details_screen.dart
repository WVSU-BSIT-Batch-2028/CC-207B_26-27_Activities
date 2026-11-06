
import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../models/movie_details.dart';
import '../services/omdb_api.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailsScreen> createState() =>
      _MovieDetailsScreenState();
}

class _MovieDetailsScreenState
    extends State<MovieDetailsScreen> {
  final OmdbApi _api = OmdbApi();

  late Future<MovieDetails> _details;

  @override
  void initState() {
    super.initState();
    _details = _api.getMovieDetails(widget.movie.imdbId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
      ),
      body: FutureBuilder<MovieDetails>(
        future: _details,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Error loading movie details: ${snapshot.error}',
                ),
              ),
            );
          }

          final details = snapshot.data!;

          final genres = details.genre == 'N/A' ||
                  details.genre.isEmpty
              ? <String>[]
              : details.genre
                  .split(',')
                  .map((genre) => genre.trim())
                  .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (details.poster.isNotEmpty &&
                    details.poster != 'N/A')
                  Center(
                    child: Image.network(
                      details.poster,
                      height: 280,
                      errorBuilder: (_, _, _) =>
                          const Icon(
                        Icons.movie,
                        size: 100,
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                Text(
                  details.title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall,
                ),

                const SizedBox(height: 8),
                Text('Released: ${details.released}'),
                Text('Rated: ${details.rated}'),
                Text('Runtime: ${details.runtime}'),
                Text('IMDb Rating: ${details.imdbRating}'),

                const Divider(height: 32),

                const Text(
                  'Genre',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                if (genres.isEmpty)
                  const Text('No genres available.')
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: genres
                        .map(
                          (genre) => Chip(
                            label: Text(genre),
                          ),
                        )
                        .toList(),
                  ),

                const Divider(height: 32),

                const Text(
                  'Plot',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),
                Text(details.plot),

                const Divider(height: 32),

                const Text(
                  'Movie Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),
                Text('Director: ${details.director}'),
                const SizedBox(height: 6),
                Text('Actors: ${details.actors}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
