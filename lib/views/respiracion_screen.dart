import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/sound_service.dart';
import '../models/sound_item.dart';

class RespiracionScreen extends StatefulWidget {
  const RespiracionScreen({super.key});

  @override
  State<RespiracionScreen> createState() => _RespiracionScreenState();
}

class _RespiracionScreenState extends State<RespiracionScreen>
    with SingleTickerProviderStateMixin {
  final SoundService _service = SoundService();
  final AudioPlayer _player = AudioPlayer();
  List<SoundItem> _sounds = [];
  bool _loading = true;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _loadSounds();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 100, end: 200).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _loadSounds() async {
    try {
      final results = await _service.fetchSounds('breathing calm ambient');
      setState(() {
        _sounds = results;
        _loading = false;
      });
    } catch (e) {
      print('Error al cargar sonidos: $e');
      setState(() => _loading = false);
    }
  }

  void _playSound(String url) async {
    await _player.play(UrlSource(url));
  }

  @override
  void dispose() {
    _player.dispose();
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBreathingAnimation() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Center(
          child: Container(
            width: _animation.value,
            height: _animation.value,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withOpacity(0.3),
            ),
            child: const Center(
              child: Text(
                'Respira',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ejercicio de Respiración')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Inhala y exhala siguiendo la animación.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildBreathingAnimation()),
            const SizedBox(height: 16),
            const Text(
              'Sonidos para acompañar tu respiración:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _loading
                ? const CircularProgressIndicator()
                : SizedBox(
                    height: 150,
                    child: ListView.builder(
                      itemCount: _sounds.length,
                      itemBuilder: (context, index) {
                        final sound = _sounds[index];
                        return ListTile(
                          title: Text(sound.name),
                          trailing: const Icon(Icons.play_arrow),
                          onTap: () => _playSound(sound.previewUrl),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
