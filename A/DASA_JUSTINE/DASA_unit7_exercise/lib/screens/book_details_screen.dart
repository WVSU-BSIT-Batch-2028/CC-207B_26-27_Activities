import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/book_details.dart';
import '../services/open_library_api.dart';

class BookDetailsScreen extends StatefulWidget {
  final Book book;

  const BookDetailsScreen({
    super.key,
    required this.book,
  });

  @override
  State<BookDetailsScreen> createState() =>
      _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  final OpenLibraryApi _api = OpenLibraryApi();

  late Future<BookDetails> _details;

  @override
  void initState() {
    super.initState();

    _details = _api.getBookDetails(
      '/works/${widget.book.workId}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
      ),
      body: FutureBuilder<BookDetails>(
        future: _details,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading book details: ${snapshot.error}',
              ),
            );
          }

          final details = snapshot.data!;

          final coverId = details.covers.isNotEmpty
              ? details.covers.first
              : widget.book.coverId;

          final authors = details.authors.isNotEmpty
              ? details.authors.join(', ')
              : widget.book.authors.isNotEmpty
                  ? widget.book.authors.join(', ')
                  : 'Unknown author';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (coverId != null)
                  Center(
                    child: Image.network(
                      'https://covers.openlibrary.org/b/id/$coverId-L.jpg',
                      height: 220,
                      errorBuilder: (_, _, _) =>
                          const Icon(Icons.menu_book, size: 100),
                    ),
                  ),

                const SizedBox(height: 20),

                Text(
                  details.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 12),

                Text('Author: $authors'),

                const SizedBox(height: 16),

                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  details.description.isNotEmpty
                      ? details.description
                      : 'No description available.',
                ),

                const SizedBox(height: 20),

                const Text(
                  'Subjects',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                if (details.subjects.isEmpty)
                  const Text('No subjects available.')
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: details.subjects
                        .map((subject) => Chip(
                              label: Text(subject),
                            ))
                        .toList(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}