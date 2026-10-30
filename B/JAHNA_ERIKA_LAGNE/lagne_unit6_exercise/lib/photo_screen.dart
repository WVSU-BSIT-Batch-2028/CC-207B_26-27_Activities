import 'package:flutter/material.dart';
import 'photo.dart';

class PhotoScreen extends StatelessWidget {
  final Photo photo;
  const PhotoScreen({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 202, 233),
        title: Text(photo.caption),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  photo.asset,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  semanticLabel: photo.caption,
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.star),
              label: const Text("Make favorite"),
            ),
          ],
        ),
      ),
    );
  }
}