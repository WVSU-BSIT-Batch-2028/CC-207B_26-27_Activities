import 'package:flutter/material.dart';

import 'profile_info.dart';

/// A reusable row for one [ProfileInfo] entry.
class InfoTile extends StatelessWidget {
  const InfoTile({super.key, required this.info});

  final ProfileInfo info;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Semantics(
      label: '${info.label}. ${info.value}',
      child: ExcludeSemantics(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: scheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: Icon(info.icon, color: scheme.onSecondaryContainer),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        info.label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(info.value, style: theme.textTheme.bodyLarge),
                    ],
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
