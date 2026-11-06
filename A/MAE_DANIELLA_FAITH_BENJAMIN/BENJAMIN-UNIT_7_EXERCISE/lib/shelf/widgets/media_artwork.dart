import 'package:flutter/material.dart';

class MediaArtwork extends StatelessWidget {
  const MediaArtwork({
    super.key,
    required this.url,
    required this.icon,
    this.width = 56,
    this.height = 76,
    this.fit = BoxFit.cover,
  });

  final String? url;
  final IconData icon;
  final double width;
  final double height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon),
    );
    final imageUrl = url;
    if (imageUrl == null || imageUrl.isEmpty) return fallback;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => fallback,
      ),
    );
  }
}
