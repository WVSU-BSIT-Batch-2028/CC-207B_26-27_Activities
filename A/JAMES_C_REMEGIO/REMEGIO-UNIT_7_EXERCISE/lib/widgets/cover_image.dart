import 'package:flutter/material.dart';

/// A cover or poster, with a framed icon when the URL is missing or fails.
class CoverImage extends StatelessWidget {
  const CoverImage({
    super.key,
    required this.url,
    required this.fallbackIcon,
    required this.semanticLabel,
    this.width = 72,
    this.height = 108,
  });

  final String? url;
  final IconData fallbackIcon;
  final String semanticLabel;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final Widget fallback = _frame(
      colors: colors,
      child: Icon(fallbackIcon, color: colors.primary, size: width * 0.42),
    );
    final String? imageUrl = url;
    if (imageUrl == null) {
      return Semantics(image: true, label: semanticLabel, child: fallback);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        semanticLabel: semanticLabel,
        filterQuality: FilterQuality.medium,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          return fallback;
        },
        loadingBuilder:
            (BuildContext context, Widget child, ImageChunkEvent? progress) {
          if (progress == null) return child;
          return _frame(
            colors: colors,
            child: const CircularProgressIndicator(strokeWidth: 2),
          );
        },
      ),
    );
  }

  Widget _frame({required ColorScheme colors, required Widget child}) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
