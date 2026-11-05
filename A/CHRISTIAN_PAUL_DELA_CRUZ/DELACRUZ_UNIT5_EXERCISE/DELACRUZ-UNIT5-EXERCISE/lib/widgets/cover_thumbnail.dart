import 'package:flutter/material.dart';

class CoverThumbnail extends StatelessWidget {
  const CoverThumbnail({
    required this.url,
    required this.fallbackIcon,
    this.width = 64,
    this.height = 88,
    super.key,
  });

  final String? url;
  final IconData fallbackIcon;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final placeholder = ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(fallbackIcon),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: width,
        height: height,
        child: url == null
            ? placeholder
            : Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => placeholder,
                loadingBuilder: (context, child, progress) =>
                    progress == null ? child : placeholder,
              ),
      ),
    );
  }
}
