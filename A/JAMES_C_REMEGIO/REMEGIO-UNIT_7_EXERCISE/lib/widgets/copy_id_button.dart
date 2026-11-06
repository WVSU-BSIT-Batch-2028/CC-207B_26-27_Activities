import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Copies [id] and confirms it in a floating snack bar.
class CopyIdButton extends StatelessWidget {
  const CopyIdButton({super.key, required this.id, required this.tooltip});

  final String id;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: () => copyId(context, id),
      icon: const Icon(Icons.copy_outlined),
    );
  }
}

Future<void> copyId(BuildContext context, String id) async {
  final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
  var copied = false;
  try {
    await Clipboard.setData(
      ClipboardData(text: id),
    ).timeout(const Duration(seconds: 2));
    copied = true;
  } on Object {
    copied = false;
  }
  if (!context.mounted) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(copied ? 'Copied $id' : 'Could not copy $id'),
      ),
    );
}
