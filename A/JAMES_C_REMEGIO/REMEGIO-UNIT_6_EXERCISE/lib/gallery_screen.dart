import 'package:flutter/material.dart';

import 'photo.dart';
import 'photo_screen.dart';

/// The six gallery pictures, in the order they appear in the grid.
///
/// Paths match the filenames in `assets/images/gallery/`, including spaces.
const List<Photo> galleryPhotos = <Photo>[
  Photo(
    asset: 'assets/images/gallery/cict logo.png',
    caption: 'CICT Logo',
  ),
  Photo(
    asset: 'assets/images/gallery/wvsu logo.png',
    caption: 'WVSU Logo',
  ),
  Photo(
    asset: 'assets/images/gallery/favorite number.jpeg',
    caption: 'My Favorite Number',
  ),
  Photo(
    asset: 'assets/images/gallery/quezon hall.jpeg',
    caption: 'Quezon Hall',
  ),
  Photo(
    asset: 'assets/images/gallery/favorite food.jpg',
    caption: 'My Favorite Food: Adobo',
  ),
  Photo(
    asset: 'assets/images/gallery/vacation.jpg',
    caption: 'Vacation',
  ),
];

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  /// Index of the single favorite, or null when nothing is chosen yet.
  int? _favoriteIndex;

  Future<void> _openPhoto(int index) async {
    final Photo photo = galleryPhotos[index];
    final bool? madeFavorite = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (BuildContext context) => PhotoScreen(photo: photo),
      ),
    );
    if (!mounted || madeFavorite != true) {
      return;
    }
    setState(() => _favoriteIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Gallery')),
      body: galleryPhotos.isEmpty
          ? const _GalleryEmpty()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const _GalleryIntro(),
                Expanded(
                  child: GridView.extent(
                    maxCrossAxisExtent: 160,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    padding: const EdgeInsets.all(8),
                    children: <Widget>[
                      for (var index = 0; index < galleryPhotos.length; index++)
                        _GalleryTile(
                          photo: galleryPhotos[index],
                          isFavorite: index == _favoriteIndex,
                          onTap: () => _openPhoto(index),
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _GalleryTile extends StatelessWidget {
  const _GalleryTile({
    required this.photo,
    required this.isFavorite,
    required this.onTap,
  });

  final Photo photo;
  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Semantics(
      button: true,
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: scheme.outlineVariant),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: scheme.primary.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            color: scheme.surface,
            child: InkWell(
              onTap: onTap,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  ColoredBox(
                    color: scheme.surface,
                    child: Image.asset(
                      photo.asset,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      semanticLabel: photo.caption,
                      filterQuality: FilterQuality.medium,
                      gaplessPlayback: true,
                      frameBuilder: (
                        BuildContext context,
                        Widget child,
                        int? frame,
                        bool wasSynchronouslyLoaded,
                      ) {
                        if (wasSynchronouslyLoaded || frame != null) {
                          return child;
                        }
                        return Center(
                          child: Icon(
                            Icons.downloading_rounded,
                            color: scheme.secondary,
                          ),
                        );
                      },
                      errorBuilder: (
                        BuildContext context,
                        Object error,
                        StackTrace? stackTrace,
                      ) {
                        return _TileFallback(caption: photo.caption);
                      },
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ExcludeSemantics(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              scheme.primary.withValues(alpha: 0),
                              scheme.primary.withValues(alpha: 0.88),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 18, 8, 8),
                          child: Text(
                            photo.caption,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: scheme.onPrimary,
                              fontWeight: FontWeight.w700,
                              height: 1.25,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isFavorite)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: scheme.secondary,
                          shape: BoxShape.circle,
                          border: Border.all(color: scheme.surface, width: 2),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.star_rounded,
                            size: 18,
                            color: scheme.onSecondary,
                            semanticLabel: 'Favorite',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TileFallback extends StatelessWidget {
  const _TileFallback({required this.caption});

  final String caption;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Semantics(
      image: true,
      label: caption,
      child: ColoredBox(
        color: scheme.surfaceContainerHighest,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.broken_image_outlined, color: scheme.primary),
                const SizedBox(height: 6),
                Text(
                  caption,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GalleryIntro extends StatelessWidget {
  const _GalleryIntro();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        'School logos, favorites, and a vacation. Tap a picture to open it.',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
          height: 1.35,
        ),
      ),
    );
  }
}

class _GalleryEmpty extends StatelessWidget {
  const _GalleryEmpty();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.photo_outlined,
              size: 48,
              color: scheme.secondary,
            ),
            const SizedBox(height: 12),
            Text(
              'No photos yet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Add pictures to the gallery list to fill this grid.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
