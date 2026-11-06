import 'package:flutter/material.dart';

import '../models/photo.dart';
import '../widgets/aurora_background.dart';
import '../widgets/glass_bar_background.dart';
import '../widgets/glass_title.dart';

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({super.key, required this.photo});

  final Photo photo;

  @override
  Widget build(BuildContext context) {
    return AuroraBackground(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: GlassTitle(photo.caption),
          flexibleSpace: const GlassBarBackground(),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      photo.asset,
                      fit: BoxFit.contain,
                      semanticLabel: photo.caption,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  photo.caption,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => Navigator.pop(context, true),
                  icon: const Icon(Icons.star_rounded),
                  label: const Text('Make favorite'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const StadiumBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
