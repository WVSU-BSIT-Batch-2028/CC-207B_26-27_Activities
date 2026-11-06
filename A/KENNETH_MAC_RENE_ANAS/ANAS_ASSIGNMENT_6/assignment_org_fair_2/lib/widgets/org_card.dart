import 'package:flutter/material.dart';

import '../data/orgs.dart';

// EXPLAIN E6: The star on this card changes when the user taps it,
// yet OrgCard is a StatelessWidget. Where does the star's state live, and
// how does a new value reach this widget?
class OrgCard extends StatelessWidget {
  const OrgCard({
    super.key,
    required this.org,
    required this.isFavorite,
    required this.isMember,
    this.isGrid = false,
    required this.onTap,
    required this.onFavorite,
  });

  final Org org;
  final bool isFavorite;
  final bool isMember;
  final bool isGrid;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: isGrid ? 4 : 12, vertical: 4),
      clipBehavior: Clip.antiAlias,
      child: isGrid
          ? InkWell(
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ColoredBox(
                          color: colors.primaryContainer,
                          child: Icon(
                            Icons.groups,
                            color: colors.onPrimaryContainer,
                            size: 44,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: _FavoriteButton(
                            isFavorite: isFavorite,
                            onPressed: onFavorite,
                            compact: true,
                          ),
                        ),
                        if (isMember)
                          const Positioned(
                            left: 8,
                            bottom: 8,
                            child: Chip(label: Text('Joined')),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          org.acronym,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          org.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : ListTile(
              leading: CircleAvatar(
                backgroundColor: colors.primaryContainer,
                child: Text(org.acronym.characters.first),
              ),
              title: Text(org.name),
              subtitle: Text('${org.category.label} · ${org.members} members'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isMember) const Chip(label: Text('Joined')),
                  _FavoriteButton(
                    isFavorite: isFavorite,
                    onPressed: onFavorite,
                  ),
                ],
              ),
              onTap: onTap,
            ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({
    required this.isFavorite,
    required this.onPressed,
    this.compact = false,
  });

  final bool isFavorite;
  final VoidCallback onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      tooltip: isFavorite ? 'Remove favorite' : 'Add favorite',
      onPressed: onPressed,
      constraints: compact
          ? const BoxConstraints.tightFor(width: 36, height: 36)
          : null,
      padding: compact ? EdgeInsets.zero : null,
      color: compact ? Theme.of(context).colorScheme.surface : null,
      iconSize: compact ? 20 : null,
      icon: Icon(
        isFavorite ? Icons.star : Icons.star_border,
        semanticLabel: isFavorite ? 'Favorite' : 'Not favorite',
      ),
    );
    if (!compact) return button;
    return Material(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      shape: const CircleBorder(),
      child: button,
    );
  }
}
