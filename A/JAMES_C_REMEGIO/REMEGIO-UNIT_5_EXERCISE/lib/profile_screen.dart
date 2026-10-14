import 'package:flutter/material.dart';

import 'info_tile.dart';
import 'profile_content.dart';
import 'profile_info.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('${ProfileContent.displayName}.')),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const _ProfileHeader(),
                  const SizedBox(height: 24),
                  Text(
                    'Details',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final ProfileInfo info
                      in ProfileContent.details) ...<Widget>[
                    InfoTile(info: info),
                    const SizedBox(height: 8),
                  ],
                  const SizedBox(height: 16),
                  const _BiographyCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double avatarSize = constraints.maxWidth < 340 ? 72 : 104;
            return Row(
              children: <Widget>[
                _AvatarFrame(
                  size: avatarSize,
                  child: Image.asset(
                    ProfileContent.photoAsset,
                    width: avatarSize,
                    height: avatarSize,
                    fit: BoxFit.cover,
                    semanticLabel: 'Photo of ${ProfileContent.displayName}',
                    errorBuilder: (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                    ) {
                      return Semantics(
                        image: true,
                        label:
                            'Initials for ${ProfileContent.displayName}. Add a photo at ${ProfileContent.photoAsset}',
                        child: _InitialsAvatar(theme: theme, scheme: scheme),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        ProfileContent.course,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: scheme.secondary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ProfileContent.displayName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        ProfileContent.tagline,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AvatarFrame extends StatelessWidget {
  const _AvatarFrame({required this.size, required this.child});

  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: scheme.secondary, width: 2),
      ),
      child: ClipOval(
        child: SizedBox(width: size, height: size, child: child),
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.theme, required this.scheme});

  final ThemeData theme;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: scheme.primary,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: FittedBox(
            child: Text(
              _initials(ProfileContent.displayName),
              style: theme.textTheme.headlineSmall?.copyWith(
                color: scheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BiographyCard extends StatelessWidget {
  const _BiographyCard();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Card(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ColoredBox(color: scheme.tertiary, child: const SizedBox(width: 4)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.auto_stories_outlined,
                          color: scheme.tertiary,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'My Biography',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      ProfileContent.biography,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _initials(String name) {
  final List<String> parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((String part) => part.isNotEmpty)
      .toList();
  if (parts.isEmpty) {
    return '?';
  }
  if (parts.length == 1) {
    return parts.first[0].toUpperCase();
  }
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}
