import 'package:flutter/material.dart';

import '../models/pick.dart';
import '../services/strapi_api.dart';
import 'pick_detail_screen.dart';

class MyPicksTab extends StatefulWidget {
  const MyPicksTab({super.key});

  @override
  State<MyPicksTab> createState() => _MyPicksTabState();
}

class _MyPicksTabState extends State<MyPicksTab> {
  final StrapiApi _api = StrapiApi();

  List<Pick> _picks = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPicks();
  }

  Future<void> _loadPicks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await _api.getPicks();

      if (!mounted) return;

      setState(() {
        _picks = results;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage =
            'Unable to load recommendations. Please try again.';
      });
    }
  }

  Widget _buildPickCard(Pick pick) {
    final bool isBook = pick.isBook;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 7,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.pink.shade50,
          child: Icon(
            isBook ? Icons.menu_book : Icons.movie,
            color: Colors.pink.shade400,
            size: 28,
          ),
        ),
        title: Text(
          pick.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(pick.note),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
        Navigator.push(
        context,
         MaterialPageRoute(
        builder: (context) => PickDetailScreen(pick: pick),
         ),
        );
       },
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 45,
              color: Colors.pink,
            ),
            const SizedBox(height: 10),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loadPicks,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (_picks.isEmpty) {
      return const Center(
        child: Text('No recommendations available yet.'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPicks,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: _picks.length,
        itemBuilder: (context, index) {
          return _buildPickCard(_picks[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }
}