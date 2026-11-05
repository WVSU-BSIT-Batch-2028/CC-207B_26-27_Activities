import 'package:flutter/material.dart';

import '../models/pick.dart';
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

  late Future<Map<String, dynamic>> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  void _loadDetails() {
    if (widget.pick.isBook) {
      _detailsFuture =
          _bookApi.getBookDetails(widget.pick.externalId);
    } else {
      _detailsFuture =
          _movieApi.getMovieDetails(widget.pick.externalId);
    }
  }

  String _getDescription(Map<String, dynamic> data) {
    final description = data['description'];

    if (description is String) {
      return description;
    }

    if (description is Map<String, dynamic>) {
      return description['value']?.toString() ??
          'No description available.';
    }

    return data['Plot']?.toString() ??
        'No description available.';
  }

  String? _getImageUrl(Map<String, dynamic> data) {
    if (widget.pick.isMovie) {
      final poster = data['Poster']?.toString();

      if (poster == null || poster == 'N/A' || poster.isEmpty) {
        return null;
      }

      return poster;
    }

    final covers = data['covers'];

    if (covers is List && covers.isNotEmpty) {
      return 'https://covers.openlibrary.org/b/id/${covers.first}-L.jpg';
    }

    return null;
  }

  Widget _buildImage(String? imageUrl) {
    if (imageUrl == null) {
      return Container(
        height: 250,
        width: double.infinity,
        color: Colors.pink.shade50,
        child: Icon(
          widget.pick.isBook
              ? Icons.menu_book
              : Icons.movie,
          size: 80,
          color: Colors.pink,
        ),
      );
    }

    return Image.network(
      imageUrl,
      height: 250,
      width: double.infinity,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 250,
          color: Colors.pink.shade50,
          child: const Icon(
            Icons.image_not_supported,
            size: 60,
            color: Colors.pink,
          ),
        );
      },
    );
  }

  Widget _buildDetails(Map<String, dynamic> data) {
    final title = widget.pick.isBook
        ? data['title']?.toString() ?? widget.pick.title
        : data['Title']?.toString() ?? widget.pick.title;

    final description = _getDescription(data);
    final imageUrl = _getImageUrl(data);

    final year = widget.pick.isMovie
        ? data['Year']?.toString()
        : data['first_publish_year']?.toString();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildImage(imageUrl),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (year != null && year.isNotEmpty)
            Text(
              'Year: $year',
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
          const SizedBox(height: 20),
          const Text(
            'Why I Picked This',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(widget.pick.note),
          const SizedBox(height: 20),
          const Text(
            'Description / Plot',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(description),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Details'),
        backgroundColor: const Color(0xFFFFCAE9),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 45,
                      color: Colors.pink,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Unable to load details. Please try again.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _loadDetails();
                        });
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('No details available.'),
            );
          }

          return _buildDetails(snapshot.data!);
        },
      ),
    );
  }
}