import 'package:flutter/material.dart';

import '../models/photo.dart';
import 'photo_screen.dart';

const List<Photo> galleryPhotos = [
  Photo(asset: 'assets/images/gallery/image1.png', caption: 'Till'),
  Photo(asset: 'assets/images/gallery/image2.jpeg', caption: 'Confident nga baye, Nalipatan ko ngalan :p'),
  Photo(asset: 'assets/images/gallery/image3.jpeg', caption: 'Luka'),
  Photo(asset: 'assets/images/gallery/image4.jpeg', caption: 'Luka with glasses'),
  Photo(asset: 'assets/images/gallery/image5.jpeg', caption: 'Luka sideview'),
  Photo(asset: 'assets/images/gallery/image6.jpeg', caption: 'Bloody Till'),
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

    if (makeFavorite == true && mounted) {
      setState(() {
        _favoriteAsset = photo.asset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Gallery')),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: [
          for (final photo in galleryPhotos)
            GestureDetector(
              onTap: () => _open(photo),
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
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 28,
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
