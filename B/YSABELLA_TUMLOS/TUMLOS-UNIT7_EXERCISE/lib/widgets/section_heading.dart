import 'package:flutter/material.dart';

import 'glass_icon.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading(this.title, {super.key, this.icon});

  final String title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              GlassIcon(icon: icon!, size: 40, iconSize: 20),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(),
      ],
    );
  }
}
