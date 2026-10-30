import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/photo.dart';
import '../widgets/glass_bar_background.dart';
import '../widgets/glass_title.dart';
import 'photo_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? _favoriteAsset;

  Future<void> _open(Photo photo) async {
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => PhotoScreen(photo: photo)),
    );

    if (makeFavorite == true) {
      setState(() => _favoriteAsset = photo.asset);
    }
  }

  Widget _buildImage(Photo photo) {
    return Image.asset(
      photo.thumbnail ?? photo.asset,
      fit: BoxFit.cover,
      alignment: photo.alignment,
      semanticLabel: photo.caption,
    );
  }

  Widget _buildTile(Photo photo) {
    final scheme = Theme.of(context).colorScheme;
    final bool isFavorite = photo.asset == _favoriteAsset;

    return GestureDetector(
      onTap: () => _open(photo),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildImage(photo),
          ),
          if (isFavorite)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.surface.withValues(alpha: 0.85),
                ),
                child: const Icon(
                  Icons.star_rounded,
                  size: 22,
                  color: Colors.amber,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const GlassTitle('Gallery'),
        flexibleSpace: const GlassBarBackground(),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          const int columns = 3;
          const double spacing = 4;
          const double padding = 4;
          const double maxGridWidth = 1120;
          const double minGridWidth = 360;

          final int rows = (photos.length / columns).ceil();
          final double tileFromHeight =
              (constraints.maxHeight - 1 - padding * 2 - spacing * (rows - 1)) /
                  rows;
          final double widthFromHeight =
              tileFromHeight * columns + spacing * (columns - 1) + padding * 2;

          final double gridWidth = math.min(
            constraints.maxWidth,
            math.min(maxGridWidth, math.max(minGridWidth, widthFromHeight)),
          );
          final double usable = gridWidth - padding * 2;
          final double maxExtent =
              (usable + spacing) / columns - spacing + 0.5;

          return Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: gridWidth,
              child: GridView.extent(
                maxCrossAxisExtent: maxExtent,
                mainAxisSpacing: spacing,
                crossAxisSpacing: spacing,
                padding: const EdgeInsets.all(padding),
                children: [for (final photo in photos) _buildTile(photo)],
              ),
            ),
          );
        },
      ),
    );
  }
}
