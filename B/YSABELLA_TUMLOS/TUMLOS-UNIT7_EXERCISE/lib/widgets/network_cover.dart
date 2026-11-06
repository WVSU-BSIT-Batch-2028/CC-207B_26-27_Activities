import 'package:flutter/material.dart';

class NetworkCover extends StatelessWidget {
  const NetworkCover({
    super.key,
    required this.width,
    required this.height,
    required this.icon,
    this.url,
  });

  final String? url;
  final double width;
  final double height;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final borderRadius = BorderRadius.circular(10);

    final placeholder = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: scheme.primaryContainer.withValues(alpha: 0.6),
      ),
      child: Icon(icon, color: scheme.primary, size: width * 0.5),
    );

    if (url == null) return placeholder;

    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.network(
        url!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
        errorBuilder: (context, error, stackTrace) => placeholder,
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : placeholder,
      ),
    );
  }
}
