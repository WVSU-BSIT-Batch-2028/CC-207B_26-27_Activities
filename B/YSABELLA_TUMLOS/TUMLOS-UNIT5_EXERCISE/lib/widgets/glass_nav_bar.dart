import 'package:flutter/material.dart';

import 'glass_card.dart';

class GlassNavBar extends StatelessWidget {
  const GlassNavBar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: GlassCard(
              padding: EdgeInsets.zero,
              radius: 28,
              child: MediaQuery.removePadding(
                context: context,
                removeBottom: true,
                child: NavigationBar(
                  height: 68,
                  selectedIndex: selectedIndex,
                  onDestinationSelected: onSelected,
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.person_outline_rounded),
                      selectedIcon: Icon(Icons.person_rounded),
                      label: 'Profile',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.pets_outlined),
                      selectedIcon: Icon(Icons.pets),
                      label: 'My Pet',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
