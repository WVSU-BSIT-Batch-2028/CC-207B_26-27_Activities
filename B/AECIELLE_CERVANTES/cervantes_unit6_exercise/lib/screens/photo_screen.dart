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
            child: Center(
              child: Image.asset(photo.asset, fit: BoxFit.contain),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.star),
                label: const Text('Make favorite'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}