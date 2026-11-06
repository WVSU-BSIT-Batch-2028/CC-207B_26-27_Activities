
import 'package:flutter/material.dart';

import '../models/pick.dart';
import '../models/book_details.dart';
import '../models/movie_details.dart';
import '../services/open_library_api.dart';
import '../services/omdb_api.dart';

class PickDetailScreen extends StatefulWidget {
  final Pick pick;

  const PickDetailScreen({
    super.key,
    required this.pick,
  });

  @override
  State<PickDetailScreen> createState() => _PickDetailScreenState();
}

class _PickDetailScreenState extends State<PickDetailScreen> {
  final OpenLibraryApi _bookApi = OpenLibraryApi();
  final OmdbApi _movieApi = OmdbApi();

  late final Future<BookDetails>? _bookDetails;
  late final Future<MovieDetails>? _movieDetails;

  bool get _isBook =>
      widget.pick.kind.trim().toLowerCase() == 'book';

  @override
  void initState() {
    super.initState();

    final externalId =
        widget.pick.externalId.trim().split('/').last;

    if (_isBook) {
      _bookDetails = _bookApi.getBookDetails(
        '/works/$externalId',
      );
      _movieDetails = null;
    } else {
      _movieDetails = _movieApi.getMovieDetails(externalId);
      _bookDetails = null;
    }
  }

  Widget _buildImage(String url, {bool isBook = false}) {
    if (url.isEmpty || url == 'N/A') {
      return Icon(
        isBook ? Icons.menu_book : Icons.movie,
        size: 100,
        color: Colors.grey,
      );
    }

    return Image.network(
      url,
      height: 230,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => Icon(
        isBook ? Icons.menu_book : Icons.movie,
        size: 100,
        color: Colors.grey,
      ),
    );
  }

  
Widget _buildContent({
  required String title,
  required String summary,
  required Widget image,
  String? extraInfo,
  String? categoryLabel,
  List<String> categories = const [],
}) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: image),

        const SizedBox(height: 24),

        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),

        if (extraInfo != null && extraInfo.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(extraInfo),
        ],

        const SizedBox(height: 24),

        Text(
          'Why I Recommend It',
          style: Theme.of(context).textTheme.titleLarge,
        ),

        const SizedBox(height: 8),

        Text(
          widget.pick.note.isNotEmpty
              ? widget.pick.note
              : 'No recommendation note available.',
        ),

        if (categoryLabel != null) ...[
          const SizedBox(height: 24),
          Text(
            categoryLabel,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          if (categories.isEmpty)
            const Text('No categories available.')
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories
                  .map((category) => Chip(
                        label: Text(category),
                      ))
                  .toList(),
            ),
        ],

        const SizedBox(height: 24),

        Text(
          _isBook ? 'Description' : 'Plot',
          style: Theme.of(context).textTheme.titleLarge,
        ),

        const SizedBox(height: 8),

        Text(
          summary.isNotEmpty
              ? summary
              : 'No summary available.',
        ),
      ],
    ),
  );
}


  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'Unable to load details:\n$error',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendation Details'),
      ),
      body: _isBook
          ? FutureBuilder<BookDetails>(
              future: _bookDetails,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return _buildLoading();
                }

                if (snapshot.hasError) {
                  return _buildError(snapshot.error!);
                }

                final details = snapshot.data!;

                final coverUrl = details.covers.isNotEmpty
                    ? 'https://covers.openlibrary.org/b/id/${details.covers.first}-L.jpg'
                    : '';

                return _buildContent(
                  title: details.title,
                  summary: details.description,
                  image: _buildImage(coverUrl, isBook: true),
                  extraInfo: details.authors.isNotEmpty
                      ? 'Author: ${details.authors.join(', ')}'
                      : null,
                  categoryLabel: 'Subjects',
                  categories: details.subjects,
                );
              },
            )
          : FutureBuilder<MovieDetails>(
              future: _movieDetails,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return _buildLoading();
                }

                if (snapshot.hasError) {
                  return _buildError(snapshot.error!);
                }

                final details = snapshot.data!;

               return _buildContent(
                  title: details.title,
                  summary: details.plot,
                  image: _buildImage(details.poster),
                  extraInfo: 'Director: ${details.director}',
                  categoryLabel: 'Genre',
                  categories: details.genre == 'N/A'
                      ? []
                      : details.genre.split(',').map((genre) => genre.trim()).toList(),
                );
              },
            ),
    );
  }
}
