import 'package:flutter/material.dart';

/// Shared layout for instructions, loading, empty, and error states.
class StateMessage extends StatelessWidget {
  const StateMessage({
    super.key,
    required this.icon,
    required this.text,
    this.action,
    this.showSpinner = false,
  });

  final IconData icon;
  final String text;
  final Widget? action;
  final bool showSpinner;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (showSpinner)
              const CircularProgressIndicator()
            else
              Icon(icon, size: 48, color: colors.primary),
            const SizedBox(height: 16),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    height: 1.4,
                    color: colors.onSurface,
                  ),
            ),
            if (action != null) ...<Widget>[
              const SizedBox(height: 16),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// A scroll view that can still be pulled when its message is short.
class ScrollFill extends StatelessWidget {
  const ScrollFill({super.key, required this.child, this.onRefresh});

  final Widget child;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final Widget view = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(child: child),
            ),
          ],
        );
      },
    );
    if (onRefresh == null) return view;
    return RefreshIndicator(onRefresh: onRefresh!, child: view);
  }
}
