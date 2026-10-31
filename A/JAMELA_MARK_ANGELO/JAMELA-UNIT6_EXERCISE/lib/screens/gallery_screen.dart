import 'package:flutter/material.dart';

import '../models/photo.dart';

const List<Photo> photos = [
  Photo(asset: 'assets/images/gallery/Image1.jpeg', caption: 'Photo 1'),
  Photo(asset: 'assets/images/gallery/Image2.jpg', caption: 'Photo 2'),
  Photo(asset: 'assets/images/gallery/Image3.jpg', caption: 'Photo 3'),
  Photo(asset: 'assets/images/gallery/Image4.png', caption: 'Photo 4'),
  Photo(asset: 'assets/images/gallery/Image5.jpeg', caption: 'Photo 5'),
  Photo(asset: 'assets/images/gallery/Image6.jpeg', caption: 'Photo 6'),
];

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? _favoriteAsset;

  Future<void> _openPhoto(Photo photo) async {
    final makeFavorite = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => PhotoScreen(photo: photo),
      ),
    );

    if (mounted && makeFavorite == true) {
      setState(() => _favoriteAsset = photo.asset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Gallery')),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: [
          for (final photo in photos)
            InkWell(
              onTap: () => _openPhoto(photo),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      photo.asset,
                      fit: BoxFit.cover,
                      semanticLabel: photo.caption,
                    ),
                    if (_favoriteAsset == photo.asset)
                      const Positioned(
                        top: 8,
                        right: 8,
                        child: Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 30,
                        ),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PhotoScreen extends StatelessWidget {
  final Photo photo;

  const PhotoScreen({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(photo.caption)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  photo.asset,
                  fit: BoxFit.contain,
                  semanticLabel: photo.caption,
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.star),
              label: const Text('Make favorite'),
            ),
          ],
        ),
      ),
    );
  }
}
