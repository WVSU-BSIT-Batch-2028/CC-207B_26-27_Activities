import 'package:flutter/material.dart';
import 'models.dart';
import 'photo_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? _favoriteAsset;

  static const List<Photo> _photos = [
    Photo(asset: 'assets/images/gallery/photo1.jpg', caption: 'What a beach'),
    Photo(asset: 'assets/images/gallery/photo2.jpg', caption: 'Samgyup with Cous'),
    Photo(asset: 'assets/images/gallery/photo3.jpg', caption: 'Movie Night'),
    Photo(asset: 'assets/images/gallery/photo4.jpg', caption: 'Matamis'),
    Photo(asset: 'assets/images/gallery/photo5.jpg', caption: 'B4 Midterms'),
    Photo(asset: 'assets/images/gallery/photo6.jpg', caption: 'Batang Ama'),
    Photo(asset: 'assets/images/gallery/photo7.jpg', caption: 'Baby Snugs'),
    Photo(asset: 'assets/images/gallery/photo8.jpg', caption: 'neigh'),
    Photo(asset: 'assets/images/gallery/photo9.jpg', caption: 'Dinagyang Fest'),
    Photo(asset: 'assets/images/gallery/photo10.jpg', caption: 'Fam Dinner'),
    Photo(asset: 'assets/images/gallery/photo11.jpg', caption: 'THANK YOUUU'),
    Photo(asset: 'assets/images/gallery/photo12.jpg', caption: 'Pamilya Sirado'),
  ];

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
      appBar: AppBar(
        title: const Text('My Gallery'),
        elevation: 2,
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        padding: const EdgeInsets.all(8.0),
        children: [
          for (final photo in _photos)
            GestureDetector(
              onTap: () => _openPhoto(photo),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        photo.asset,
                        fit: BoxFit.cover,
                        semanticLabel: photo.caption,
                      ),
                    ),
                  ),
                  if (_favoriteAsset == photo.asset)
                    const Positioned(
                      top: 8.0,
                      right: 8.0,
                      child: Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 28.0,
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