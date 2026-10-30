import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  int _counter = 0;
  bool _liked = false;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    setState(() {
      _isPlaying = true;
      _counter++;
    });
    await _player.play(AssetSource('sounds/pet_sound.mp3'));
  }

  // Part D: ask first, reset only when the answer is true
  Future<void> _confirmReset() async {
    final bool? answer = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Reset the count?"),
        content: Text(
            "My pet has made sound $_counter times. Start again from zero?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text("Reset"),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (answer == true) {
      setState(() => _counter = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 202, 233),
        title: const Text("Chichi and Chacha"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  setState(() => _liked = !_liked);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/pet.jpg',
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                        semanticLabel: "Photo of my pet",
                      ),
                    ),
                    if (_liked)
                      const Icon(Icons.favorite, color: Colors.red, size: 50),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _isPlaying ? null : _playSound,
                icon: const Icon(Icons.volume_up),
                label: Text(_isPlaying ? "Playing..." : "Play Sound"),
              ),
              const SizedBox(height: 20),
              Text("My pet has made sound $_counter times."),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _counter == 0 ? null : _confirmReset,
                child: const Text("Reset count"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}