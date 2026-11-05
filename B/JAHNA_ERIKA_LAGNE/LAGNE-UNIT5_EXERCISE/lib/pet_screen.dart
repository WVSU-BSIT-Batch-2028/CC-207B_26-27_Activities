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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 202, 233),
        title: const Text("My Pet")),
      body: Center(
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
                      width: 500,
                      height: 500,
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
          ],
        ),
      ),
    );
  }
}
