
import 'package:flutter/material.dart';

import '../models/pick.dart';
import '../services/contentful_api.dart';

import 'pick_detail_screen.dart';
import 'package:flutter/gestures.dart';

class MyPicksScreen extends StatefulWidget {
  const MyPicksScreen({super.key});

  @override
  State<MyPicksScreen> createState() => _MyPicksScreenState();
}

class _MyPicksScreenState extends State<MyPicksScreen> {
  final ContentfulApi _api = ContentfulApi();

  late Future<List<Pick>> _picks;

  @override
  void initState() {
    super.initState();
    _picks = _api.fetchPicks();
  }

  Future<void> _refreshPicks() async {
    final newPicks = _api.fetchPicks();

    setState(() {
      _picks = newPicks;
    });

    try {
      await newPicks;
    } catch (_) {
      // FutureBuilder displays the loading error.
    }
  }

  void _openPick(Pick pick) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PickDetailScreen(
        pick: pick,
      ),
    ),
  );
}
  
Widget _buildPicks(List<Pick> picks) {
  return ScrollConfiguration(
    behavior: const MaterialScrollBehavior().copyWith(
      dragDevices: {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      },
    ),
    child: RefreshIndicator(
      onRefresh: _refreshPicks,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.all(12),
        itemCount: picks.isEmpty ? 1 : picks.length,
        itemBuilder: (context, index) {
          if (picks.isEmpty) {
            return const SizedBox(
              height: 300,
              child: Center(
                child: Text('No recommendations available yet.'),
              ),
            );
          }

          final pick = picks[index];
          final isBook = pick.kind.trim().toLowerCase() == 'book';

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                child: Icon(
                  isBook ? Icons.menu_book : Icons.movie,
                ),
              ),
              title: Text(
                pick.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(isBook ? 'Book' : 'Movie'),
                  if (pick.note.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(pick.note),
                  ],
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                if (pick.kind.trim().toLowerCase() == 'book' ||
                    pick.kind.trim().toLowerCase() == 'movie') {
                  _openPick(pick);
                }
              },
            ),
          );
        },
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pick>>(
      future: _picks,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Error loading recommendations:\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return _buildPicks(snapshot.data ?? []);
      },
    );
  }
}

class MouseDragScrollBehavior extends MaterialScrollBehavior {
  const MouseDragScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
      };
}