import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/sound_service.dart';
import '../models/sound_item.dart';

class DormirScreen extends StatefulWidget {
  const DormirScreen({super.key});

  @override
  State<DormirScreen> createState() => _DormirScreenState();
}

class _DormirScreenState extends State<DormirScreen> {
  final SoundService _soundService = SoundService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<SoundItem> _sounds = [];
  bool _loading = true;
  bool _isPlaying = false;
  String? _currentUrl;

  @override
  void initState() {
    super.initState();
    _loadSounds();
  }

  Future<void> _loadSounds() async {
    try {
      final sounds = await _soundService.fetchSounds("sleep aids");
      setState(() {
        _sounds = sounds;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _playSound(String url) async {
    if (_isPlaying && url == _currentUrl) {
      await _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
        _currentUrl = null;
      });
      return;
    }

    await _audioPlayer.stop();
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(UrlSource(url));
    setState(() {
      _isPlaying = true;
      _currentUrl = url;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Vamos a la cama!!")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _sounds.length,
                  itemBuilder: (context, index) {
                    final sound = _sounds[index];
                    final isCurrent = sound.previewUrl == _currentUrl;
                    return ListTile(
                      title: Text(sound.name),
                      trailing: IconButton(
                        icon: Icon(isCurrent && _isPlaying ? Icons.stop : Icons.play_arrow),
                        onPressed: () => _playSound(sound.previewUrl),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
