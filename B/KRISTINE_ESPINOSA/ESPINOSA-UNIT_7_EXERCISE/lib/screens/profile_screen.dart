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
                        Text('My Hobbies', style: textTheme.titleLarge),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final hobby in hobbies) Chip(label: Text(hobby)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('My Class Schedule', style: textTheme.titleLarge),
                        const SizedBox(height: 12),
                        Table(
                          border: TableBorder.all(color: colors.outlineVariant),
                          columnWidths: const {
                            0: FixedColumnWidth(56),
                            1: FixedColumnWidth(112),
                            2: FlexColumnWidth(),
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                color: colors.primaryContainer,
                              ),
                              children: [
                                for (final title in ['Day', 'Time', 'Subject'])
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      title,
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            for (final slot in classSlots)
                              TableRow(
                                children: [
                                  for (final value in [
                                    slot.day,
                                    slot.time,
                                    slot.subject,
                                  ])
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        value,
                                        style: textTheme.bodyMedium,
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
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
