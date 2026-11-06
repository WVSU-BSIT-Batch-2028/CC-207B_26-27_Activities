import 'dart:async';

import 'package:flutter/material.dart';

import '../data/api_exception.dart';

class CatalogSearchTab<T> extends StatefulWidget {
  const CatalogSearchTab({
    super.key,
    required this.hint,
    required this.search,
    required this.resultTile,
    this.disabledMessage,
  });

  final String hint;
  final Future<List<T>> Function(String query) search;
  final Widget Function(BuildContext context, T item) resultTile;
  final String? disabledMessage;

  @override
  State<CatalogSearchTab<T>> createState() => _CatalogSearchTabState<T>();
}

class _CatalogSearchTabState<T> extends State<CatalogSearchTab<T>> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  Future<List<T>>? _results;
  String _query = '';
  bool _waitingForDebounce = false;

  void _onChanged(String text) {
    _debounce?.cancel();
    final query = text.trim();
    setState(() {
      _query = query;
      _results = null;
      _waitingForDebounce = query.length >= 3;
    });

    if (query.length < 3) return;
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _waitingForDebounce = false;
        _results = widget.search(query);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.disabledMessage case final message?) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.key_off_rounded, size: 44),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _controller,
            onChanged: _onChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: widget.hint,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _controller.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      onPressed: () {
                        _controller.clear();
                        _onChanged('');
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        Expanded(child: _buildResults()),
      ],
    );
  }

  Widget _buildResults() {
    if (_query.length < 3) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Enter at least 3 letters to search.'),
        ),
      );
    }
    if (_waitingForDebounce) {
      return const Center(child: CircularProgressIndicator());
    }

    return FutureBuilder<List<T>>(
      future: _results,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          final error = snapshot.error;
          final message = error is ApiException
              ? error.message
              : 'Something went wrong while searching. Please try again.';
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(message, textAlign: TextAlign.center),
            ),
          );
        }
        final results = snapshot.data ?? const [];
        if (results.isEmpty) {
          return const Center(
            child: Text('Nothing found. Try another search.'),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 20),
          itemCount: results.length,
          separatorBuilder: (_, _) => const SizedBox(height: 4),
          itemBuilder: (context, index) =>
              widget.resultTile(context, results[index]),
        );
      },
    );
  }
}

class CatalogCover extends StatelessWidget {
  const CatalogCover({
    super.key,
    required this.icon,
    this.imageUrl,
    this.width = 52,
    this.height = 72,
  });

  final IconData icon;
  final String? imageUrl;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final placeholder = ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(icon, size: width * 0.55),
    );
    if (imageUrl == null || imageUrl!.isEmpty) return placeholder;
    return Image.network(
      imageUrl!,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => placeholder,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return SizedBox(
          width: width,
          height: height,
          child: Center(
            child: CircularProgressIndicator(
              value: progress.expectedTotalBytes == null
                  ? null
                  : progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!,
            ),
          ),
        );
      },
    );
  }
}
