import 'package:flutter/material.dart';

class GlassIcon extends StatelessWidget {
  const GlassIcon({
    super.key,
    required this.icon,
    this.size = 44,
    this.iconSize = 22,
  });

  final IconData icon;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.32),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.surface.withValues(alpha: 0.95),
            scheme.primary.withValues(alpha: 0.12),
          ],
        ),
        border: Border.all(
          color: scheme.surface.withValues(alpha: 0.95),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.14),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, size: iconSize, color: scheme.primary),
    );
  }
}
