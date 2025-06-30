import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/sound_item.dart';
import '../services/sound_service.dart';
import '../widgets/sound_list_tile.dart';

class SoundListView extends StatefulWidget {
  final String categoryName;
  final String query;

  const SoundListView({
    super.key,
    required this.categoryName,
    required this.query,
  });

  @override
  State<SoundListView> createState() => _SoundListViewState();
}

class _SoundListViewState extends State<SoundListView> {
  final SoundService _service = SoundService();
  List<SoundItem> _sounds = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadSounds();
  }

  Future<void> _loadSounds() async {
    setState(() => _loading = true);
    try {
      final results = await _service.fetchSounds(widget.query);
      setState(() {
        _sounds = results;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo con imagen
          Image.asset('assets/background_landscape.jpg', fit: BoxFit.cover),

          // Capa difusa blanca
          Container(color: Colors.white.withOpacity(0.2)),

          // Contenido principal
          Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight + 30),
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _sounds.length,
                    itemBuilder: (context, index) {
                      final sound = _sounds[index];
                      return GlassSoundCard(sound: sound);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class GlassSoundCard extends StatelessWidget {
  final SoundItem sound;

  const GlassSoundCard({super.key, required this.sound});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SoundListTile(sound: sound),
          ),
        ),
      ),
    );
  }
}
