import 'package:flutter/material.dart';

import '../models/photo.dart';

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({
    super.key,
    required this.photo,
  });

  final Photo photo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(photo.caption)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  photo.asset,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  semanticLabel: photo.caption,
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Make favorite'),
            ),
          ],
        ),
      ),
    );
  }
}
