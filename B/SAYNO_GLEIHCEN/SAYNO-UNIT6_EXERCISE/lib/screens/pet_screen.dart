import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _liked = false;
  int _barkCount = 0;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _player.dispose(); // release what you created
    super.dispose();
  }

  Future<void> _playSound() async {
    setState(() {
      _isPlaying = true;
      _barkCount++;
    });
    // AssetSource looks inside the assets/ folder
    await _player.play(AssetSource('sounds/dog_bark.mp3'));
  }

    Future<void> _confirmReset() async {
    // showDialog<bool> completes with true (Reset), false (Cancel),
    // or null if the dialog is dismissed by tapping outside.
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset bark count?'),
        content: Text('Sreit has barked $_barkCount times.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      setState(() => _barkCount = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('My Pet')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onDoubleTap: () => setState(() => _liked = !_liked),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/SREIT.jpg',
                      height: 320,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      semanticLabel: 'Photo of Sreit, my dog',
                    ),
                  ),
                  if (_liked)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Icon(Icons.favorite, size: 48, color: colors.error),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Sreit', style: textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              'Sreit has barked $_barkCount times.',
              style: textTheme.bodyLarge,
            ),
                        const SizedBox(height: 8),
            OutlinedButton(
              // disabled (null) while the count is 0
              onPressed: _barkCount == 0 ? null : _confirmReset,
              child: const Text('Reset count'),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _isPlaying ? null : _playSound,
              icon: const Icon(Icons.volume_up),
              label: Text(_isPlaying ? 'Playing...' : 'Play bark'),
            ),
          ],
        ),
      ),
    );
  }
}