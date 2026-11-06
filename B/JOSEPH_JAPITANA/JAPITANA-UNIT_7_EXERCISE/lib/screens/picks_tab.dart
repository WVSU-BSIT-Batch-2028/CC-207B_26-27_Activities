import 'package:flutter/material.dart';

import '../data/api_exception.dart';
import '../data/contentful_pick_source.dart';
import '../data/pick_source.dart';
import '../models/pick.dart';
import 'pick_detail_screen.dart';

class PicksTab extends StatefulWidget {
  const PicksTab({super.key});

  @override
  State<PicksTab> createState() => _PicksTabState();
}

class _PicksTabState extends State<PicksTab>
    with AutomaticKeepAliveClientMixin {
  final PickSource _source = ContentfulPickSource();

  List<Pick>? _picks;
  String? _error;
  bool _loading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _load(); // the request starts here, not in build
  }

  Future<void> _load() async {
    try {
      final picks = await _source.fetchPicks();
      if (!mounted) return;
      setState(() {
        _picks = picks;
        _error = null;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Something went wrong. Pull down to retry.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // RefreshIndicator needs a scrollable child, even for the message states.
    return RefreshIndicator(
      onRefresh: _load,
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return _message(_error!);
    }
    final picks = _picks ?? const [];
    if (picks.isEmpty) {
      return _message('No picks yet.');
    }
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: picks.length,
      itemBuilder: (context, i) => _buildTile(picks[i]),
    );
  }

  Widget _message(String text) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 80),
        Text(text, textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildTile(Pick pick) {
    return ListTile(
      leading: Icon(pick.isBook ? Icons.menu_book : Icons.movie),
      title: Text(pick.title),
      subtitle: pick.note.isEmpty
          ? null
          : Text(pick.note, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PickDetailScreen(pick: pick)),
        );
      },
    );
  }
}