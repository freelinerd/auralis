import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/sound_service.dart';
import '../models/sound_item.dart';

class AnsiedadScreen extends StatefulWidget {
  const AnsiedadScreen({super.key});

  @override
  State<AnsiedadScreen> createState() => _AnsiedadScreenState();
}

class _AnsiedadScreenState extends State<AnsiedadScreen> {
  final SoundService _service = SoundService();
  final AudioPlayer _player = AudioPlayer();
  List<SoundItem> _sounds = [];
  bool _loading = true;
  int _selectedDuration = 5; // minutos
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadSounds();
  }

  Future<void> _loadSounds() async {
    try {
      final results = await _service.fetchSounds('calm stress');
      setState(() {
        _sounds = results;
        _loading = false;
      });
    } catch (e) {
      print('Error al cargar sonidos: $e');
      setState(() => _loading = false);
    }
  }

  void _startTimerAndPlay(String url) async {
    await _player.play(UrlSource(url));

    _timer?.cancel();
    _timer = Timer(Duration(minutes: _selectedDuration), () {
      _player.stop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tiempo de meditación finalizado')),
      );
    });
  }

  @override
  void dispose() {
    _player.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meditación para Ansiedad')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Selecciona un sonido y duración para tu meditación:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text("Duración: "),
                DropdownButton<int>(
                  value: _selectedDuration,
                  items: [1, 3, 5, 10, 15]
                      .map((min) => DropdownMenuItem(
                          value: min, child: Text('$min min')))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedDuration = value);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _sounds.length,
                      itemBuilder: (context, index) {
                        final sound = _sounds[index];
                        return ListTile(
                          title: Text(sound.name),
                          subtitle: const Text("Toca para reproducir"),
                          trailing: const Icon(Icons.play_arrow),
                          onTap: () => _startTimerAndPlay(sound.previewUrl),
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
