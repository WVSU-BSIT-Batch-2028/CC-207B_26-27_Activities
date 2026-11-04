import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Copies [id] to the clipboard and shows a SnackBar.
class CopyIdButton extends StatelessWidget {
  const CopyIdButton({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.copy),
      tooltip: 'Copy ID',
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: id));
        if (!context.mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Copied $id')));
      },
    );
  }
}
