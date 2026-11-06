import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyIdButton extends StatelessWidget {
  const CopyIdButton({super.key, required this.id});

  final String id;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: id));
    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Copied ID $id')));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Copy ID',
      onPressed: () => _copy(context),
      icon: const Icon(Icons.copy_rounded),
    );
  }
}
