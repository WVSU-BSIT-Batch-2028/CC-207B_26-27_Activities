
import 'package:flutter/material.dart';

import '../models/photo.dart';

class PhotoScreen extends StatelessWidget {
  final Photo photo;

  const PhotoScreen({
    super.key,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(photo.caption),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    photo.asset,
                    fit: BoxFit.contain,
                    semanticLabel: photo.caption,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Make favorite'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
