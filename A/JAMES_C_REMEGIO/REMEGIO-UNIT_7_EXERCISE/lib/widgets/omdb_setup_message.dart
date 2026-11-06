import 'package:flutter/material.dart';

/// Shown instead of an OMDb request when `OMDB_KEY` was empty at startup.
class OmdbSetupMessage extends StatelessWidget {
  const OmdbSetupMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.key_outlined, color: colors.primary, size: 36),
                    const SizedBox(height: 12),
                    Text(
                      'OMDb needs an API key',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Movie search stays off until a key is compiled into the app. '
                      'Nothing is requested while this message is showing.',
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                    ),
                    const SizedBox(height: 16),
                    const _Step(
                      number: '1',
                      text:
                          'Request a free key at omdbapi.com/apikey.aspx. It is emailed to you. The free key allows 1,000 requests a day.',
                    ),
                    const _Step(
                      number: '2',
                      text:
                          'Copy cms.example.json to cms.json if you have not already. Set OMDB_KEY to that key. Leave the Contentful values in place.',
                    ),
                    const _Step(
                      number: '3',
                      text:
                          'Stop the app and start it again with flutter run --dart-define-from-file=cms.json. Hot reload does not pick up a new key.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.text});

  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 14,
            backgroundColor: theme.colorScheme.secondaryContainer,
            foregroundColor: theme.colorScheme.onSecondaryContainer,
            child: Text(
              number,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
