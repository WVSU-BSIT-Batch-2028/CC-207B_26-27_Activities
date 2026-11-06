import 'dart:async';

import 'package:flutter/material.dart';

import '../services/api_exception.dart';
import 'message_view.dart';

class SearchTab<T> extends StatefulWidget {
  const SearchTab({
    super.key,
    required this.hint,
    required this.search,
    required this.itemBuilder,
  });

  final String hint;
  final Future<List<T>> Function(String query) search;
  final Widget Function(BuildContext context, T item) itemBuilder;

  @override
  State<SearchTab<T>> createState() => _SearchTabState<T>();
}

class _SearchTabState<T> extends State<SearchTab<T>>
    with AutomaticKeepAliveClientMixin {
  Timer? _debounce;
  Future<List<T>>? _results;

  @override
  bool get wantKeepAlive => true;

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
      setState(() {
        _results = widget.search(query);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Widget _buildResults() {
    final results = _results;

    if (results == null) {
      return const MessageView(
        icon: Icons.search_rounded,
        text: 'Type at least 3 letters to search.',
      );
    }

    return FutureBuilder<List<T>>(
      future: results,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return MessageView(
            icon: Icons.error_outline_rounded,
            text: describeError(snapshot.error!),
          );
        }

        final items = snapshot.data!;
        if (items.isEmpty) {
          return const MessageView(
            icon: Icons.search_off_rounded,
            text: 'Nothing found.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) =>
              widget.itemBuilder(context, items[index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: TextField(
                onChanged: _onChanged,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(28)),
                  ),
                ),
              ),
            ),
            Expanded(child: _buildResults()),
          ],
        ),
      ),
    );
  }
}
