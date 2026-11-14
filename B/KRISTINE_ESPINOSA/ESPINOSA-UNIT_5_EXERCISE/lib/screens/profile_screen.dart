import 'package:flutter/material.dart';

import '../data/my_info.dart';
import '../widgets/info_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colors = theme.colorScheme;

    return Scaffold(
   appBar: AppBar(title: const Text(fullName)),
        body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                
                Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        profilePhoto,
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                        semanticLabel: 'Photo of $fullName',
                        errorBuilder: (context, error, stack) => SizedBox(
                          width: 96,
                          height: 96,
                          child: ColoredBox(
                            color: colors.primaryContainer,
                            child: Icon(
                              Icons.person,
                              color: colors.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                   
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(fullName, style: textTheme.headlineSmall),
                          const SizedBox(height: 4),
                          Text(
                            tagline,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Text('About Me', style: textTheme.titleLarge),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: [for (final info in infos) InfoTile(info: info)],
                  ),
                ),
                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('My Biography', style: textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(biography, style: textTheme.bodyMedium),
                      ],
                    ),
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
