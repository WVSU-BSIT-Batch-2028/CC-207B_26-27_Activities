import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  // Created once here, so one player serves every tap.
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _liked = false;
  int _playCount = 0;

  @override
  void initState() {
    super.initState();
    // Runs when the sound finishes. Turns the button back on.
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _player.dispose(); // release what this screen created
    super.dispose();
  }

  Future<void> _playSound() async {
    setState(() {
      _isPlaying = true;
      _playCount++;
    });
    try {
      // AssetSource looks inside the assets/ folder.
      await _player.play(AssetSource('sounds/pet_sound.mp3'));
    } catch (_) {
      // If the sound fails to load, turn the button back on.
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  Future<void> _confirmReset() async {
    final bool? shouldReset = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset the count?'),
        content: Text(
          'Stormy has barked $_playCount '
          '${_playCount == 1 ? 'time' : 'times'}. Start again from zero?',
        ),
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
    // Reset only on an explicit true. Tapping outside the dialog returns null.
    if (shouldReset == true && mounted) {
      setState(() => _playCount = 0);
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
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onDoubleTap: () => setState(() => _liked = !_liked),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.asset(
                            'assets/images/pet.jpg',
                            fit: BoxFit.cover,
                            semanticLabel: 'Photo of Stormy, my Samoyed puppy',
                          ),
                        ),
                      ),
                      // Collection-if: the heart exists only when liked.
                      if (_liked)
                        Icon(Icons.favorite, size: 96, color: colors.error),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text('Stormy', style: textTheme.headlineSmall),
                Text(
                  'My 4-month-old Samoyed. Affectionate, playful, and a '
                  'little stubborn. Double-tap the photo to give him a heart.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'Stormy has barked $_playCount '
                  '${_playCount == 1 ? 'time' : 'times'}.',
                  style: textTheme.titleMedium,
                ),

                const SizedBox(height: 8),
                OutlinedButton(
                  // null disables the button while the count is 0.
                  onPressed: _playCount == 0 ? null : _confirmReset,
                  child: const Text('Reset count'),
                ),

                const SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  child: FilledButton.icon(
                    // null disables the button while the sound plays.
                    onPressed: _isPlaying ? null : _playSound,
                    icon: Icon(_isPlaying ? Icons.volume_up : Icons.play_arrow),
                    label: Text(_isPlaying ? 'Playing...' : 'Hear Stormy bark'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
