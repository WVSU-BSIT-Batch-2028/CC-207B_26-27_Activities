import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyIdButton extends StatelessWidget {
  const CopyIdButton({super.key, required this.id, required this.label});

  final String id;
  final String label;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: id));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$label ID copied: $id')));
  }

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: 'Copy $label ID',
    onPressed: () => _copy(context),
    icon: const Icon(Icons.copy),
  );
}
