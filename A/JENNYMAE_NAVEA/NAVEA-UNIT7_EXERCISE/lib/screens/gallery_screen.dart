import 'package:flutter/material.dart';

class Photo {
  const Photo({required this.asset, required this.caption});

  final String asset;
  final String caption;
}

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  static const List<Photo> photos = [
    Photo(
      asset: 'assets/images/gallery/photo1.jpg',
      caption: 'Photo booth memories',
    ),
    Photo(
      asset: 'assets/images/gallery/photo2.jpg',
      caption: 'A day out together',
    ),
    Photo(
      asset: 'assets/images/gallery/photo3.jpg',
      caption: 'Fun with sunglasses',
    ),
    Photo(
      asset: 'assets/images/gallery/photo4.jpg',
      caption: 'Movie Date',
    ),
    Photo(
      asset: 'assets/images/gallery/photo5.jpg',
      caption: 'A favorite photo strip',
    ),
    Photo(
      asset: 'assets/images/gallery/photo6.jpg',
      caption: 'Beach with friends',
    ),
  ];

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
      setState(() => _favoriteAsset = photo.asset);
    }
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
          for (final photo in GalleryScreen.photos)
            GestureDetector(
              onTap: () => _open(photo),
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
                          semanticLabel: 'Favorite photo',
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
  const PhotoScreen({super.key, required this.photo});

  final Photo photo;

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
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Make favorite'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
