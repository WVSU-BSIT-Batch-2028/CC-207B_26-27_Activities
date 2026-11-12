import 'package:flutter/material.dart';

/// One gallery photo: where the file is and what to call it.
class Photo {
  const Photo({required this.asset, required this.caption});

  final String asset;
  final String caption;
}

const List<Photo> _photos = <Photo>[
  Photo(
    asset: 'assets/images/gallery/photo1.jpg',
    caption: 'Missing these macarons.',
  ),
  Photo(
    asset: 'assets/images/gallery/photo2.jpg',
    caption: 'My first time horseback riding.',
  ),
  Photo(
    asset: 'assets/images/gallery/photo3.jpg',
    caption: 'This jet is sick, at PMA!',
  ),
  Photo(
    asset: 'assets/images/gallery/photo4.jpg',
    caption: 'Can never get enough of this view.',
  ),
  Photo(
    asset: 'assets/images/gallery/photo5.jpg',
    caption: 'Hadn\'t been in the airport for years.',
  ),
  Photo(
    asset: 'assets/images/gallery/photo6.jpg',
    caption: 'Clark airport is insanely huge.',
  ),
];

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  // The file path of the favorite photo. null means no favorite yet.
  String? _favoriteAsset;

  Future<void> _open(Photo photo) async {
    // push<bool> completes with what PhotoScreen pops:
    // true from "Make favorite", false from "Remove favorite",
    // null from the back arrow.
    final bool? answer = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => PhotoScreen(
          photo: photo,
          isFavorite: photo.asset == _favoriteAsset,
        ),
      ),
    );
    // null means the user went back without answering, so nothing changes.
    if (answer == null || !mounted) return;
    // Saving one path replaces the old favorite, so only one star exists.
    // false only arrives from the current favorite, so null clears the star.
    setState(() => _favoriteAsset = answer ? photo.asset : null);
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
          // Collection-for: one tile per photo in the list.
          for (final photo in _photos)
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
                  // Collection-if: the star exists only on the favorite tile.
                  if (photo.asset == _favoriteAsset)
                    const Positioned(
                      top: 6,
                      right: 6,
                      child: Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 28,
                        shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
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

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({super.key, required this.photo, required this.isFavorite});

  final Photo photo;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        // FittedBox with scaleDown shrinks a long caption to fit one line.
        // A short caption keeps its normal size.
        title: FittedBox(fit: BoxFit.scaleDown, child: Text(photo.caption)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                // The color fills the empty space around the photo.
                child: ColoredBox(
                  color: colors.surfaceContainerHighest,
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 5,
                    child: Image.asset(
                      photo.asset,
                      // contain shows the whole photo at its original ratio.
                      fit: BoxFit.contain,
                      semanticLabel: photo.caption,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Scroll or pinch to zoom. Drag to move around.',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                // pop sends the new answer back to the grid, waiting in _open.
                onPressed: () => Navigator.pop(context, !isFavorite),
                icon: Icon(isFavorite ? Icons.star_border : Icons.star),
                label: Text(isFavorite ? 'Remove favorite' : 'Make favorite'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
