
import 'package:flutter/material.dart';
import 'photo_screen.dart';

class Photo {
  final String asset;
  final String caption;

  const Photo({
    required this.asset,
    required this.caption,
  });
}

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {

  String? favoriteAsset;

  final List<Photo> photos = const [
    Photo(
      asset: 'assets/images/gallery/bron.png',
      caption: 'LeBron James',
    ),
    Photo(
      asset: 'assets/images/gallery/kd.png',
      caption: 'Kevin Durant',
    ),
    Photo(
      asset: 'assets/images/gallery/pg.png',
      caption: 'Paul George',
    ),
    Photo(
      asset: 'assets/images/gallery/shaq washed.png',
      caption: 'Shaquille O\'Neal',
    ),
    Photo(
      asset: 'assets/images/gallery/smith.png',
      caption: 'Stephen A. Smith',
    ),
    Photo(
      asset: 'assets/images/gallery/zion.png',
      caption: 'Zion Williamson',
    ),
  ];

  Future<void> _open(Photo photo) async {
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => PhotoScreen(photo: photo),
      ),
    );

    if (!mounted) return;

    if (makeFavorite == true) {
      setState(() {
        favoriteAsset = photo.asset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Gallery'),
        centerTitle: true,
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

                  if (favoriteAsset == photo.asset)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 24,
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
