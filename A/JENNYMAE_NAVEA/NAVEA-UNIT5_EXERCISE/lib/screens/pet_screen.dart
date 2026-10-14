import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  static const String _petName = 'Chi-chi';

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
    });
    try {
      await _player.play(AssetSource('sounds/pet_sound.mp3'));
      if (mounted) setState(() => _count++);
    } catch (error) {
      if (!mounted) return;
      setState(() => _isPlaying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not play the pet sound: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Pet')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 32,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Meet $_petName!',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.16,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.12,
                            ),
                            blurRadius: 22,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onDoubleTap: () => setState(() => _liked = !_liked),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 250,
                                maxHeight: 250,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.asset(
                                    'assets/images/pet_photo.jpg',
                                    fit: BoxFit.cover,
                                    semanticLabel: 'Photo of my pet $_petName',
                                  ),
                                ),
                              ),
                            ),
                            AnimatedScale(
                              scale: _liked ? 1 : 0.6,
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeOutBack,
                              child: AnimatedOpacity(
                                opacity: _liked ? 1 : 0,
                                duration: const Duration(milliseconds: 180),
                                child: Icon(
                                  Icons.favorite,
                                  size: 88,
                                  color: theme.colorScheme.error,
                                  shadows: [
                                    Shadow(
                                      color: theme.colorScheme.shadow
                                          .withValues(alpha: 0.26),
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Double-tap the photo to send some love!',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.music_note_rounded,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$_petName has meowed $_count times',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    FilledButton.icon(
                      onPressed: _isPlaying ? null : _playSound,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: const StadiumBorder(),
                      ),
                      icon: Icon(
                        _isPlaying
                            ? Icons.graphic_eq_rounded
                            : Icons.volume_up_rounded,
                      ),
                      label: Text(
                        _isPlaying ? 'Playing...' : 'Play $_petName\'s sound',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
