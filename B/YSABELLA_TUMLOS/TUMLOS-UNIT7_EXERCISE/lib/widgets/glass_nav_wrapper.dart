import 'package:flutter/material.dart';

import 'glass_card.dart';

class GlassNavWrapper extends StatelessWidget {
  const GlassNavWrapper({super.key, required this.child});

  final Widget child;

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
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
