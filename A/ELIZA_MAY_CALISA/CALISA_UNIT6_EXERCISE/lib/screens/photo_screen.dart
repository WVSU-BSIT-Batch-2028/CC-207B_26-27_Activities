import 'package:flutter/material.dart';

import '../models/photo.dart';

class PhotoScreen extends StatelessWidget {
  final Photo photo;
  const PhotoScreen({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(photo.caption)),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Image.asset(photo.asset, fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Make favorite'),
            ),
          ),
        ],
      ),
    );
  }
}
