import 'dart:async';

/// Waits until typing pauses, then stores one search [Future].
///
/// The screen reads [results] from a [FutureBuilder]. This class never calls
/// [search] from a widget `build` method. Changing or clearing the text drops
/// the previous future so an older response cannot reappear.
class SearchSession<T> {
  SearchSession({
    required this.search,
    this.delay = const Duration(milliseconds: 500),
    this.minimumLength = 3,
  });

  final Future<List<T>> Function(String query) search;
  final Duration delay;
  final int minimumLength;

  Timer? _timer;
  bool _disposed = false;

  /// True during the pause before a request is started.
  bool waiting = false;

  /// The request for the current query, or null when there is nothing to show.
  Future<List<T>>? results;

  /// The query [results] belongs to.
  String? activeQuery;

  void onChanged(String text, void Function() notify) {
    _timer?.cancel();
    final String query = text.trim();
    results = null;
    activeQuery = null;
    if (query.length < minimumLength) {
      waiting = false;
      if (!_disposed) notify();
      return;
    }
    waiting = true;
    if (!_disposed) notify();
    _timer = Timer(delay, () {
      if (_disposed) return;
      waiting = false;
      activeQuery = query;
      results = search(query);
      notify();
    });
  }

  void retry(void Function() notify) {
    final String? query = activeQuery;
    if (query == null || _disposed) return;
    waiting = false;
    results = search(query);
    notify();
  }

  void dispose() {
    _disposed = true;
    _timer?.cancel();
  }
}
