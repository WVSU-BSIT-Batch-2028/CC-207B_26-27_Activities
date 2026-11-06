
import 'package:flutter/material.dart';

import '../models/photo.dart';
import 'photo_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final List<Photo> _photos = const [
    Photo(
      asset: 'assets/images/gallery/Aventurine.jpg',
      caption: 'Aventurine',
    ),
    Photo(
      asset: 'assets/images/gallery/Brant.jpg',
      caption: 'Brant',
    ),
    Photo(
      asset: 'assets/images/gallery/Doro.jpeg',
      caption: 'Doro',
    ),
    Photo(
      asset: 'assets/images/gallery/Frover.jpg',
      caption: 'Frover',
    ),
    Photo(
      asset: 'assets/images/gallery/Kiana.jpeg',
      caption: 'Kiana',
    ),
    Photo(
      asset: 'assets/images/gallery/Sunday.jpg',
      caption: 'Sunday',
    ),
  ];

  String? _favoriteAsset;

  Future<void> _open(Photo photo) async {
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => PhotoScreen(photo: photo),
      ),
    );

    if (makeFavorite == true && mounted) {
      setState(() {
        _favoriteAsset = photo.asset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: [
          for (final photo in _photos)
            GestureDetector(
              onTap: () => _open(photo),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      photo.asset,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      semanticLabel: photo.caption,
                    ),
                  ),
                  if (_favoriteAsset == photo.asset)
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 32,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
