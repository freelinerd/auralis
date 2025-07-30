import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeditationView extends StatefulWidget {
  const MeditationView({super.key});

  @override
  State<MeditationView> createState() => _MeditationViewState();
}

class _MeditationViewState extends State<MeditationView> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool isPlaying = false;
  bool isCompleted = false;
  double selectedMinutes = 10;
  String finalPhrase = '';

  final List<String> _phrases = [
    'Respira profundo, lo estás haciendo bien.',
    'Cada momento de paz es un regalo para tu alma.',
    'Tu bienestar comienza con un respiro.',
    'Estás presente, estás en calma, estás en paz.',
  ];

  @override
  void initState() {
    super.initState();
    _loadMeditationLogs();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() => isPlaying = state == PlayerState.playing);
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() => _duration = newDuration);
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() => _position = newPosition);
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isCompleted = true;
        isPlaying = false;
        _position = _duration;
        finalPhrase = (_phrases..shuffle()).first;
      });
      _saveMeditationLog(selectedMinutes);
    });
  }

  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      setState(() {
        isCompleted = false;
        finalPhrase = '';
      });
      await _audioPlayer.play(
        UrlSource(
          "https://www.chosic.com/wp-content/uploads/2022/05/sb_aurora(chosic.com).mp3",
        ),
      );
    }
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  Future<void> _saveMeditationLog(double minutes) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().toIso8601String();
    final log = '$now - $minutes min';
    final logs = prefs.getStringList('meditation_logs') ?? [];
    logs.add(log);
    await prefs.setStringList('meditation_logs', logs);
  }

  Future<void> _loadMeditationLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final logs = prefs.getStringList('meditation_logs') ?? [];
    debugPrint('Logs: $logs');
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double progress = _duration.inSeconds > 0
        ? _position.inSeconds / _duration.inSeconds
        : 0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Meditación guiada',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  child: IconButton(
                    iconSize: 100,
                    icon: Icon(
                      isCompleted
                          ? Icons.check_circle
                          : isPlaying
                              ? Icons.pause_circle
                              : Icons.play_circle,
                      color: Colors.white,
                    ),
                    onPressed: togglePlayPause,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '${formatTime(_position)} / ${formatTime(_duration)}',
                  style: const TextStyle(color: Colors.white),
                ),
                Slider(
                  value: _position.inSeconds.toDouble(),
                  min: 0,
                  max: _duration.inSeconds.toDouble(),
                  onChanged: (value) async {
                    final position = Duration(seconds: value.toInt());
                    await _audioPlayer.seek(position);
                  },
                  activeColor: Colors.white,
                  inactiveColor: Colors.white30,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [5, 10, 15]
                      .map(
                        (m) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ChoiceChip(
                            label: Text('$m min'),
                            selected: selectedMinutes == m,
                            onSelected: (_) =>
                                setState(() => selectedMinutes = m.toDouble()),
                            selectedColor: Colors.white,
                            backgroundColor: const Color.fromARGB(186, 134, 158, 159),
                            labelStyle: TextStyle(
                              color: selectedMinutes == m
                                  ? Colors.black
                                  : Colors.white70,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                if (isCompleted) ...[
                  const SizedBox(height: 30),
                  const Text(
                    '¡Sesión completada!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    finalPhrase,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
