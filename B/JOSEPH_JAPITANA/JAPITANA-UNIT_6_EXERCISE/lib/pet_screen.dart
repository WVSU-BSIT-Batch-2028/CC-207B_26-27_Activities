import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  static const String _petName = 'Hutch'; 
  static const String _petSound = 'barked'; 

  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _liked = false;
  int _count = 0;

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
      _count++;
    });
    // AssetSource looks inside the assets/ folder
    await _player.play(AssetSource('sounds/pet_sound.mp3'));
  }

  Future<void> _confirmReset() async {
    // showDialog<bool> returns a bool?: null if the user taps outside.
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset count?'),
        content: Text('$_petName\'s count will go back to 0.'),
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
      setState(() => _count = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Pet')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Photo with double-tap heart
                GestureDetector(
                  onDoubleTap: () => setState(() => _liked = !_liked),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/pet.jpg',
                          height: 400,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          alignment: const Alignment(0, -0.6),
                          semanticLabel: 'Photo of my pet, $_petName',
                        ),
                      ),
                      if (_liked)
                        Icon(
                          Icons.favorite,
                          size: 96,
                          color: theme.colorScheme.error,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Sound button
                FilledButton.icon(
                  onPressed: _isPlaying ? null : _playSound,
                  icon: const Icon(Icons.volume_up),
                  label: Text(_isPlaying ? 'Playing...' : 'Play sound'),
                ),
                const SizedBox(height: 16),

                // Counter
                Text(
                  '$_petName has $_petSound $_count times.',
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Reset button: disabled while the count is 0
                OutlinedButton(
                  onPressed: _count == 0 ? null : _confirmReset,
                  child: const Text('Reset count'),
                ),
                const SizedBox(height: 8),

                Text(
                  'Double-tap the photo to give $_petName a heart.',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}