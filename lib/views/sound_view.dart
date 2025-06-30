import 'package:flutter/material.dart';
import '../models/sound_item.dart';
import '../services/sound_service.dart';
import '../widgets/sound_tile.dart';

class SoundView extends StatefulWidget {
  const SoundView({super.key});

  @override
  State<SoundView> createState() => _SoundViewState();
}

class _SoundViewState extends State<SoundView> {
  final SoundService _service = SoundService();
  final List<String> _categories = ['rain', 'forest', 'wind', 'fire'];
  String _selectedCategory = 'rain';
  List<SoundItem> _sounds = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadSounds(_selectedCategory);
  }

  Future<void> _loadSounds(String query) async {
    setState(() => _loading = true);
    try {
      final sounds = await _service.fetchSounds(query);
      setState(() {
        _sounds = sounds;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error al cargar sonidos')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF7F0),
      appBar: AppBar(
        title: const Text('Sonidos de Relajación'),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Categorías como chips
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _categories.map((category) {
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    selectedColor: Colors.deepOrange,
                    onSelected: (_) {
                      setState(() => _selectedCategory = category);
                      _loadSounds(category);
                    },
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: Colors.grey[300],
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: _sounds.length,
                    itemBuilder: (context, index) {
                      return SoundTile(sound: _sounds[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
