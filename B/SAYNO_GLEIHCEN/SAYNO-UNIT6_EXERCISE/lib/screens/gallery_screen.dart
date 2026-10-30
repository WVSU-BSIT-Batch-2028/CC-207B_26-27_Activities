import 'package:flutter/material.dart';

import '../models/photo.dart';
import 'photo_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  // Only one photo can be the favorite, so we keep just one asset path.
  String? _favoriteAsset;

  Future<void> _open(Photo photo) async {
    // push<bool> completes with what PhotoScreen pops:
    // true from "Make favorite", null from the back arrow.
    final bool? makeFavorite = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => PhotoScreen(photo: photo)),
    );
    // TODO: if makeFavorite is true, save photo.asset with setState
    if (makeFavorite == true) {
      setState(() => _favoriteAsset = photo.asset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: GridView.extent(
        maxCrossAxisExtent: 160,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.82,
        padding: const EdgeInsets.all(12),
        children: [
          for (final photo in photos)
            GestureDetector(
              onTap: () => _open(photo),
              // The polaroid: a white card with a thin frame on the top and
              // sides, and a thick strip at the bottom for the caption.
              child: Container(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFDF8),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(2, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            photo.asset,
                            fit: BoxFit.cover,
                            semanticLabel: photo.caption,
                          ),
                          if (photo.asset == _favoriteAsset)
                            const Positioned(
                              top: 4,
                              right: 4,
                              child: Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 28,
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Center(
                        child: Text(
                          photo.caption,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            color: Colors.brown.shade700,
                          ),
                        ),
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