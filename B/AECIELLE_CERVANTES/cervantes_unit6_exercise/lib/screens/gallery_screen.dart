import 'package:flutter/material.dart';
import '../models/photo.dart';
import 'photo_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? _favoriteAsset;

  Future<void> _openPhoto(Photo photo) async {
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => PhotoScreen(photo: photo)),
    );

    if (makeFavorite == true) {
      setState(() {
        _favoriteAsset = photo.asset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Gallery')),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.0,
        ),
        itemCount: galleryPhotos.length,
        itemBuilder: (context, index) {
          final photo = galleryPhotos[index];
          return GestureDetector(
            onTap: () => _openPhoto(photo),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      photo.asset,
                      fit: BoxFit.cover,
                      semanticLabel: photo.caption,
                    ),
                  ),
                ),
                if (_favoriteAsset == photo.asset)
                  const Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(Icons.star, color: Colors.amber, size: 28),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}