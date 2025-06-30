import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/sound_item.dart';

class SoundTile extends StatefulWidget {
  final SoundItem sound;
  const SoundTile({super.key, required this.sound});

  @override
  State<SoundTile> createState() => _SoundTileState();
}

class _SoundTileState extends State<SoundTile> {
  final AudioPlayer _player = AudioPlayer();
  bool _playing = false;

  void _togglePlay() async {
    if (_playing) {
      await _player.pause();
    } else {
      await _player.play(UrlSource(widget.sound.previewUrl));
    }
    setState(() => _playing = !_playing);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlay,
      onDoubleTap: () async {
        await _player.stop();
        setState(() => _playing = false);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.deepOrange.withOpacity(0.2), blurRadius: 5),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _playing ? Icons.pause_circle : Icons.play_circle,
              size: 48,
              color: Colors.deepOrange,
            ),
            const SizedBox(height: 10),
            Text(
              widget.sound.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
