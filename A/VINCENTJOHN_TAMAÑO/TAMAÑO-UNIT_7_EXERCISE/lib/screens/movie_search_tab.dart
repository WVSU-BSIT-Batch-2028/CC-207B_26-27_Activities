import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/movie.dart';
import '../services/omdb_api.dart';

class MovieSearchTab extends StatefulWidget {
  final OmdbApi? api;

  const MovieSearchTab({super.key, this.api});

  @override
  State<MovieSearchTab> createState() => _MovieSearchTabState();
}

class _MovieSearchTabState extends State<MovieSearchTab> {
  late OmdbApi _api;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _keyInputController = TextEditingController();
  Timer? _debounce;
  Future<List<Movie>>? _results;
  String _customKey = '';

  @override
  void initState() {
    super.initState();
    _api = widget.api ?? OmdbApi();
  }

  bool get _hasKey =>
      _api.hasKey || _customKey.isNotEmpty || omdbKey.isNotEmpty;

  void _performSearch(String text) {
    _debounce?.cancel();
    final query = text.trim();
    if (query.length < 3) {
      setState(() {
        _results = null;
      });
      return;
    }
    final results = _api.search(query);
    setState(() {
      _results = results;
    });
  }

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = text.trim();
      if (query.length < 3) {
        setState(() {
          _results = null;
        });
        return;
      }
      final results = _api.search(query);
      setState(() {
        _results = results;
      });
    });
  }

  void _copyImdbId(String imdbId) {
    Clipboard.setData(ClipboardData(text: imdbId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied $imdbId to clipboard'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _keyInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasKey) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.vpn_key_outlined,
                size: 64,
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              const Text(
                'OMDb API Key Missing',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'To search movies, pass your free OMDb API key when launching the app:',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const SelectableText(
                  'flutter run --dart-define=OMDB_KEY=your_key',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Or enter a temporary key below:'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _keyInputController,
                      decoration: const InputDecoration(
                        hintText: 'Paste OMDb key here (e.g. 4fbbb3e5)',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      final key = _keyInputController.text.trim();
                      if (key.isNotEmpty) {
                        setState(() {
                          _customKey = key;
                          _api = OmdbApi(apiKey: key);
                        });
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            onChanged: _onChanged,
            onSubmitted: _performSearch,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search movies, e.g. interstellar',
              prefixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _performSearch(_searchController.text),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _performSearch('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        Expanded(
          child: _results == null
              ? const Center(
                  child: Text(
                    'Search for a movie (minimum 3 letters)',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : FutureBuilder<List<Movie>>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Error: ${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    }

                    final movies = snapshot.data ?? [];
                    if (movies.isEmpty) {
                      return const Center(
                        child: Text(
                          'Movie not found!',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: movies.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final movie = movies[index];
                        return ListTile(
                          leading: SizedBox(
                            width: 48,
                            height: 64,
                            child: movie.poster != null
                                ? Image.network(
                                    movie.poster!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (
                                      context,
                                      error,
                                      stackTrace,
                                    ) => const Icon(Icons.movie, size: 36),
                                  )
                                : const Icon(Icons.movie, size: 36),
                          ),
                          title: Text(
                            movie.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(movie.year),
                          trailing: IconButton(
                            icon: const Icon(Icons.copy_outlined),
                            tooltip: 'Copy ID: ${movie.imdbId}',
                            onPressed: () => _copyImdbId(movie.imdbId),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
