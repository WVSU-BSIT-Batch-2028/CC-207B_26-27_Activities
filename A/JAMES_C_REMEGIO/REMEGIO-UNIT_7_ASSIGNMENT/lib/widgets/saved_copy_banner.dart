import 'package:flutter/material.dart';

/// Shown when the CMS could not be reached and the list is the last good load.
/// A later successful refresh does not build this widget, so the banner goes away.
class SavedCopyBanner extends StatelessWidget {
  const SavedCopyBanner({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return MaterialBanner(
      backgroundColor: colors.secondaryContainer,
      leading: Icon(Icons.cloud_off, color: colors.onSecondaryContainer),
      content: Text(
        'No connection. Showing the events saved earlier.',
        style: TextStyle(color: colors.onSecondaryContainer),
      ),
      actions: [TextButton(onPressed: onRetry, child: const Text('Retry'))],
    );
  }
}
