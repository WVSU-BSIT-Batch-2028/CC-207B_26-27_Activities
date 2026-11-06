import 'package:flutter/material.dart';
import '../services/shelf_api.dart';

class PickDetailScreen extends StatelessWidget {
  final Pick pick;
  const PickDetailScreen({super.key, required this.pick});

  Future<JsonMap> _loadData() async {
    if (pick.kind == 'book') {
      final details = await OpenLibraryApi.fetchDetails(pick.externalId);
      return {
        ...details,
        'subtitle': 'Book · Open Library ${pick.externalId}',
      };
    } else {
      final details = await OmdbApi.fetchDetails(pick.externalId);
      return {
        ...details,
        'subtitle': 'Movie · IMDb ${pick.externalId}',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pick.title)),
      body: FutureBuilder<JsonMap>(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          final poster = data['poster'] as String?;
          final description = data['description'] as String;
          final subtitle = data['subtitle'] as String;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (poster != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(poster, height: 220, fit: BoxFit.cover),
                  ),
                )
              else
                Center(
                  child: Container(
                    height: 180,
                    width: 130,
                    decoration: BoxDecoration(
                      color: Colors.pink.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      pick.kind == 'book' ? Icons.book : Icons.movie,
                      size: 60,
                      color: Colors.pink.shade700,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(pick.title, style: Theme.of(context).textTheme.headlineMedium),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 16),
              Card(
                color: Colors.pink.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Why I recommend it',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.pink.shade900,
                          )),
                      const SizedBox(height: 4),
                      Text('"${pick.note}"',
                          style: const TextStyle(fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(description, style: Theme.of(context).textTheme.bodyMedium),
            ],
          );
        },
      ),
    );
  }
}