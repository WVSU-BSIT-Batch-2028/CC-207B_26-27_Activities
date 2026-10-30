import 'package:flutter/material.dart';
import 'photo.dart';
import 'photo_screen.dart';

const List<Photo> photos = [
  Photo(asset: 'assets/images/gallery/photo1.jpg', caption: 'Candid Pic!'),
  Photo(asset: 'assets/images/gallery/photo2.jpg', caption: 'SHS Grad Pic'),
  Photo(asset: 'assets/images/gallery/photo3.jpg', caption: 'OA Pic'),
  Photo(asset: 'assets/images/gallery/photo4.jpg', caption: 'Me n Girls'),
  Photo(asset: 'assets/images/gallery/photo5.jpg', caption: 'Bonjing Guys'),
  Photo(asset: 'assets/images/gallery/photo6.jpg', caption: 'Friends'),
];

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String? _favoriteAsset; // only one photo can be the favorite

  Future<void> _open(Photo photo) async {
    // true from "Make favorite", null from the back arrow.
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => PhotoScreen(photo: photo)),
    );
    if (!mounted) return;
    if (makeFavorite == true) {
      setState(() => _favoriteAsset = photo.asset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 202, 233),
        title: const Text("My Gallery"),
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.all(8),
        children: [
          for (final photo in photos)
            GestureDetector(
              onTap: () => _open(photo),
              child: Stack(
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
                  if (photo.asset == _favoriteAsset)
                    const Positioned(
                      top: 6,
                      right: 6,
                      child: Icon(Icons.star, color: Colors.amber, size: 28),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}