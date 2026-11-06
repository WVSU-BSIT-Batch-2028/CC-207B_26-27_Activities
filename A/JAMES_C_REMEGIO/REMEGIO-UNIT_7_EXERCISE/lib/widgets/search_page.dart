import 'package:flutter/material.dart';

import '../api/api_exception.dart';
import '../search/search_session.dart';
import 'state_message.dart';

/// Search field plus the five result states. The request lives on [SearchSession].
class SearchPage<T> extends StatefulWidget {
  const SearchPage({
    super.key,
    required this.hint,
    required this.instructions,
    required this.search,
    required this.itemBuilder,
    this.emptyMessage = 'Nothing found',
  });

  final String hint;
  final String instructions;
  final Future<List<T>> Function(String query) search;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final String emptyMessage;

  @override
  State<SearchPage<T>> createState() => _SearchPageState<T>();
}

class _SearchPageState<T> extends State<SearchPage<T>> {
  late final SearchSession<T> _session =
      SearchSession<T>(search: widget.search);
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _session.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _notify() {
    if (!mounted) return;
    setState(() {});
  }

  void _onChanged(String text) => _session.onChanged(text, _notify);

  void _retry() => _session.retry(_notify);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: TextField(
                controller: _controller,
                onChanged: _onChanged,
                textInputAction: TextInputAction.search,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
        ),
        Expanded(child: _body()),
      ],
    );
  }

  Widget _body() {
    final Future<List<T>>? future = _session.results;
    if (future == null) {
      return _message(
        icon: Icons.search,
        text: _session.waiting ? 'Searching…' : widget.instructions,
        showSpinner: _session.waiting,
      );
    }
    return FutureBuilder<List<T>>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<List<T>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.none) {
          return _message(
            icon: Icons.search,
            text: 'Searching…',
            showSpinner: true,
          );
        }
        if (snapshot.hasError) {
          return _message(
            icon: Icons.cloud_off,
            text: messageOf(snapshot.error!),
            action: FilledButton(
              onPressed: _retry,
              child: const Text('Try again'),
            ),
          );
        }
        final List<T> items = snapshot.data ?? <T>[];
        if (items.isEmpty) {
          return _message(icon: Icons.search_off, text: widget.emptyMessage);
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          itemCount: items.length,
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 12),
          itemBuilder: (BuildContext context, int index) {
            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: widget.itemBuilder(context, items[index]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _message({
    required IconData icon,
    required String text,
    Widget? action,
    bool showSpinner = false,
  }) {
    return Center(
      child: StateMessage(
        icon: icon,
        text: text,
        action: action,
        showSpinner: showSpinner,
      ),
    );
  }
}
