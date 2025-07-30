import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/sound_service.dart';
import '../models/sound_item.dart';

class MorningScreen extends StatefulWidget {
  const MorningScreen({super.key});

  @override
  State<MorningScreen> createState() => _MorningScreenState();
}

class _MorningScreenState extends State<MorningScreen> {
  final SoundService _soundService = SoundService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<SoundItem> _sounds = [];
  bool _loading = true;
  String _motivationalQuote = '';
  SoundItem? _currentSound;

  final List<String> _quotes = [
    "Cada día es una nueva oportunidad.",
    "Despierta con determinación, acuéstate con satisfacción.",
    "La energía positiva atrae cosas positivas.",
    "Hoy es el primer día del resto de tu vida.",
    "Confía en ti y todo será posible.",
  ];

  @override
  void initState() {
    super.initState();
    _loadSounds();
    _pickRandomQuote();
  }

  void _pickRandomQuote() {
    final random = Random();
    setState(() {
      _motivationalQuote = _quotes[random.nextInt(_quotes.length)];
    });
  }

  Future<void> _loadSounds() async {
    try {
      final sounds = await _soundService.fetchSounds("morning sounds");
      setState(() {
        _sounds = sounds;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _playSound(SoundItem sound) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(UrlSource(sound.previewUrl));
    setState(() {
      _currentSound = sound;
    });
  }

  Future<void> _startRoutine() async {
    if (_sounds.isEmpty) return;
    await _playSound(_sounds.first);
    _pickRandomQuote();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Empieza el día con energía")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              _motivationalQuote,
              style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : _startRoutine,
              child: const Text('Iniciar rutina matutina'),
            ),
            const SizedBox(height: 20),
            const Text("Sonidos disponibles:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _loading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _sounds.length,
                      itemBuilder: (context, index) {
                        final sound = _sounds[index];
                        return ListTile(
                          title: Text(sound.name),
                          trailing: IconButton(
                            icon: Icon(
                              _currentSound == sound ? Icons.stop : Icons.play_arrow,
                            ),
                            onPressed: () {
                              if (_currentSound == sound) {
                                _audioPlayer.stop();
                                setState(() {
                                  _currentSound = null;
                                });
                              } else {
                                _playSound(sound);
                              }
                            },
                          ),
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
