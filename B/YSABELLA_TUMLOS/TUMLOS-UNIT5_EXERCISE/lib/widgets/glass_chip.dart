import 'dart:ui';

import 'package:flutter/material.dart';

class GlassChip extends StatelessWidget {
  const GlassChip({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                scheme.surface.withValues(alpha: 0.75),
                scheme.surface.withValues(alpha: 0.35),
              ],
            ),
            border: Border.all(
              color: scheme.surface.withValues(alpha: 0.9),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: scheme.primary),
              const SizedBox(width: 8),
              Flexible(child: Text(label, style: theme.textTheme.bodyMedium)),
            ],
          ),
        ),
      ),
    );
  }
}
