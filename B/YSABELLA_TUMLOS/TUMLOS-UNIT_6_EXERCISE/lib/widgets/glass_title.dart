import 'package:flutter/material.dart';

class GlassTitle extends StatelessWidget {
  const GlassTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final textColor = scheme.onSurface;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.auto_awesome_rounded, size: 18, color: scheme.primary),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Icon(Icons.auto_awesome_rounded, size: 18, color: scheme.tertiary),
      ],
    );
  }
}
