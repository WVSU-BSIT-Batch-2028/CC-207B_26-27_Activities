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

  final List<Photo> _photos = const [
    Photo(
      asset: 'assets/images/gallery/photo_1.jpg',
      caption: 'CICT 2025 Basketball Team',
    ),
    Photo(asset: 'assets/images/gallery/photo_2.jpg', caption: 'Free Throw'),
    Photo(
      asset: 'assets/images/gallery/photo_3.jpg',
      caption: 'Post-Game Jumpshot Celly',
    ),
    Photo(
      asset: 'assets/images/gallery/photo_4.jpg',
      caption: 'Drive to the Basket',
    ),
    Photo(asset: 'assets/images/gallery/photo_5.jpg', caption: 'Transition'),
    Photo(asset: 'assets/images/gallery/photo_6.jpg', caption: 'Tight Layup'),
  ];

  Future<void> _open(Photo photo) async {
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => PhotoScreen(photo: photo)),
    );
    if (makeFavorite == true) {
      setState(() => _favoriteAsset = photo.asset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Gallery'), centerTitle: true),
      body: GridView.extent(
        maxCrossAxisExtent: 160.0,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        padding: const EdgeInsets.all(8.0),
        children: [
          for (final photo in _photos)
            GestureDetector(
              onTap: () => _open(photo),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      photo.asset,
                      fit: BoxFit.cover,
                      semanticLabel: photo.caption,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Icon(Icons.photo, color: Colors.grey),
                      ),
                    ),
                  ),
                  if (_favoriteAsset == photo.asset)
                    Positioned(
                      top: 6.0,
                      right: 6.0,
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 22.0,
                        ),
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
