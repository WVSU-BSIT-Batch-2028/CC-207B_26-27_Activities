import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'api_exception.dart';
import 'message_view.dart';

/// One row of a search list, the same for books and movies.
class SearchResult {
  const SearchResult({
    required this.id,
    required this.title,
    required this.fallbackIcon,
    this.subtitle,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final IconData fallbackIcon;
}

/// A search box (debounced) and a FutureBuilder list. Books and Movies both
/// use it, each with its own [search] function.
class SearchTab extends StatefulWidget {
  const SearchTab({super.key, required this.hint, required this.search});

  final String hint;
  final Future<List<SearchResult>> Function(String query) search;

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab>
    with AutomaticKeepAliveClientMixin {
  Timer? _debounce;
  Future<List<SearchResult>>? _results;
  String _lastQuery = '';

  // Keep the text and the results when the user switches tabs.
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String text) {
    _debounce?.cancel(); // the user typed again: forget the old timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = text.trim();
      if (query.isEmpty) {
        setState(() {
          _results = null;
        });
        return;
      }
      if (query.length < 3) return;
      _runSearch(query);
    });
  }

  void _runSearch(String query) {
    // A block body: setState must not return the Future.
    setState(() {
      _lastQuery = query;
      _results = widget.search(query); // a new Future for the FutureBuilder
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // needed by AutomaticKeepAliveClientMixin
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            onChanged: _onChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: widget.hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    final results = _results;
    if (results == null) {
      return const MessageView(
        icon: Icons.search,
        message: 'Type at least 3 letters to search.',
      );
    }

    return FutureBuilder<List<SearchResult>>(
      future: results,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return MessageView(
            icon: Icons.error_outline,
            message: errorText(snapshot.error),
            actionLabel: 'Try again',
            onAction: () => _runSearch(_lastQuery),
          );
        }
        final items = snapshot.data!;
        if (items.isEmpty) {
          return const MessageView(
            icon: Icons.search_off,
            message: 'Nothing found.',
          );
        }
        return ListView.separated(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: items.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) => ResultTile(result: items[index]),
        );
      },
    );
  }
}

class ResultTile extends StatelessWidget {
  const ResultTile({super.key, required this.result});

  final SearchResult result;

  Future<void> _copyId(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: result.id));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied ${result.id}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final icon = Icon(result.fallbackIcon, size: 32);
    final imageUrl = result.imageUrl;

    return ListTile(
      leading: SizedBox(
        width: 48,
        height: 64,
        child: imageUrl == null
            ? Center(child: icon)
            : ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Center(child: icon),
                ),
              ),
      ),
      title: Text(result.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: result.subtitle == null ? null : Text(result.subtitle!),
      trailing: IconButton(
        icon: const Icon(Icons.copy),
        tooltip: 'Copy ID',
        onPressed: () => _copyId(context),
      ),
    );
  }
}
