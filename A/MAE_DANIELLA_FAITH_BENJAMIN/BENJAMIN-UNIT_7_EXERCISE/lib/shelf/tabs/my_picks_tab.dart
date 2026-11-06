import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../data/contentful_pick_source.dart';
import '../data/pick_source.dart';
import '../models/pick.dart';
import '../pick_detail_screen.dart';

class MyPicksTab extends StatefulWidget {
  const MyPicksTab({super.key});

  @override
  State<MyPicksTab> createState() => _MyPicksTabState();
}

class _MyPicksTabState extends State<MyPicksTab> {
  late final http.Client _client;
  late final PickSource _source;
  late Future<List<Pick>> _future;

  @override
  void initState() {
    super.initState();
    _client = http.Client();
    _source = ContentfulPickSource(
      _client,
      spaceId: contentfulSpace,
      token: contentfulToken,
    );
    _future = _source.fetchPicks();
  }

  Future<void> _refresh() async {
    late Future<List<Pick>> next;
    setState(() {
      next = _source.fetchPicks();
      _future = next;
    });
    try {
      await next;
    } on Exception {
      return;
    }
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<Pick>>(
    future: _future,
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        );
      }
      if (snapshot.hasError) {
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 80),
              const Icon(Icons.cloud_off, size: 42),
              const SizedBox(height: 12),
              Text('${snapshot.error}', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Center(
                child: FilledButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try again'),
                ),
              ),
              const SizedBox(height: 160),
            ],
          ),
        );
      }
      final picks = snapshot.data ?? const <Pick>[];
      if (picks.isEmpty) {
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(height: 220),
              Center(child: Text('No picks yet.')),
            ],
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: picks.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final pick = picks[index];
            return ListTile(
              leading: Icon(
                pick.kind == PickKind.book ? Icons.menu_book : Icons.movie,
              ),
              title: Text(pick.title),
              subtitle: Text(pick.note),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  builder: (context) => PickDetailScreen(pick: pick),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
