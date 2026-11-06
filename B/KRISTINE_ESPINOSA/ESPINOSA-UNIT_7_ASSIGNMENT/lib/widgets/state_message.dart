import 'package:flutter/material.dart';

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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showSpinner)
              const CircularProgressIndicator()
            else
              Icon(icon, size: 48),
            const SizedBox(height: 16),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (action != null) ...[const SizedBox(height: 16), action!],
          ],
        ),
      ),
    );
  }
}
