import 'package:flutter/material.dart';

import '../models/photo.dart';
import 'photo_screen.dart';

// Change these to match YOUR file names in assets/images/gallery/
const List<Photo> photos = [
  Photo(asset: 'assets/images/gallery/photo1.jpg', caption: 'favorite moon view'),
  Photo(asset: 'assets/images/gallery/photo2.jpg', caption: 'coffee with a view'),
  Photo(asset: 'assets/images/gallery/photo3.jpg', caption: 'sacred smoke'),
  Photo(asset: 'assets/images/gallery/photo4.jpg', caption: 'lunar magic'),
  Photo(asset: 'assets/images/gallery/photo5.jpg', caption: 'pure bliss'),
  Photo(asset: 'assets/images/gallery/photo6.jpg', caption: 'mindful energy'),
];

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

  Widget _buildTile(Photo photo) {
    final bool isFavorite = photo.asset == _favoriteAsset;
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            photo.asset,
            fit: BoxFit.cover,
            semanticLabel: photo.caption,
          ),
        ),
        if (isFavorite)
          const Positioned(
            top: 6,
            right: 6,
            child: Icon(Icons.star, color: Colors.amber, size: 28),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: [
          for (final photo in photos)
            GestureDetector(
              onTap: () => _open(photo),
              child: _buildTile(photo),
            ),
        ],
      ),
    );
  }
}
