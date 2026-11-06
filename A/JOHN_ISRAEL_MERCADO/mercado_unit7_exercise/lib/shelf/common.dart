import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageBox extends StatelessWidget {
  final String text;

  const MessageBox(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}

Widget imageOrIcon(String? url, IconData icon) {
  if (url == null) return Icon(Icons.hide_image_outlined);
  return ClipRRect(
    borderRadius: BorderRadius.circular(6),
    child: Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Icon(Icons.hide_image_outlined),
    ),
  );
}

class ResultTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final String id;

  const ResultTile({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.id,
  });

  Future<void> _copyId(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: id));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Copied $id')));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(width: 48, height: 72, child: leading),
      title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle),
      trailing: IconButton(
        tooltip: 'Copy ID',
        icon: const Icon(Icons.copy),
        onPressed: () => _copyId(context),
      ),
    );
  }
}
