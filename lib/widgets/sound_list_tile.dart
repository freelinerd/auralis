import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/sound_item.dart';

class SoundListTile extends StatefulWidget {
  final SoundItem sound;
  const SoundListTile({super.key, required this.sound});

  @override
  State<SoundListTile> createState() => _SoundListTileState();
}

class _SoundListTileState extends State<SoundListTile> {
  final AudioPlayer _player = AudioPlayer();
  bool _playing = false;

  void _toggle() async {
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
    return ListTile(
      leading: Icon(
        _playing ? Icons.pause_circle_filled : Icons.play_circle_filled,
        size: 36,
        color: Colors.deepPurple,
      ),
      title: Text(widget.sound.name),
      onTap: _toggle,
    );
  }
}
