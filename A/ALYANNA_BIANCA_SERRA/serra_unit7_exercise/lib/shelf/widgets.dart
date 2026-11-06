import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Cover extends StatelessWidget {
  const Cover({
    super.key,
    required this.url,
    this.width = 48,
    this.height = 64,
    this.icon = Icons.image_not_supported,
  });

  final String? url;
  final double width;
  final double height;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final placeholder = Container(
      width: width,
      height: height,
      color: colors.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(icon, color: colors.onSurfaceVariant),
    );

    final imageUrl = url;
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: imageUrl == null
          ? placeholder
          : Image.network(
              imageUrl,
              width: width,
              height: height,
              fit: BoxFit.cover,
              // On Chrome, some image servers do not allow direct downloads.
              // This falls back to a normal <img> tag. If the analyzer says
              // this name is undefined, delete this one line.
              webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
              errorBuilder: (context, error, stackTrace) => placeholder,
            ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({super.key, required this.label, required this.onChanged});

  final String label;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

Future<void> copyId(BuildContext context, String id) async {
  await Clipboard.setData(ClipboardData(text: id));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text('Copied $id')));
}

class AsyncListView<T> extends StatelessWidget {
  const AsyncListView({
    super.key,
    required this.future,
    required this.emptyText,
    required this.itemBuilder,
    this.idleText = '',
    this.onRefresh,
  });

  final Future<List<T>>? future;
  final String idleText;
  final String emptyText;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final currentFuture = future;
    if (currentFuture == null) {
      return _Message(icon: Icons.search, text: idleText);
    }

    return FutureBuilder<List<T>>(
      future: currentFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final Widget body;
        if (snapshot.hasError) {
          body = _Message(icon: Icons.error_outline, text: '${snapshot.error}');
        } else {
          final items = snapshot.data ?? <T>[];
          if (items.isEmpty) {
            body = _Message(icon: Icons.search_off, text: emptyText);
          } else {
            body = ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) =>
                  itemBuilder(context, items[index]),
            );
          }
        }

        final refresh = onRefresh;
        return refresh == null
            ? body
            : RefreshIndicator(onRefresh: refresh, child: body);
      },
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(32),
      children: [
        const SizedBox(height: 48),
        Icon(icon, size: 48, color: Theme.of(context).colorScheme.outline),
        const SizedBox(height: 12),
        Text(text, textAlign: TextAlign.center),
      ],
    );
  }
}
