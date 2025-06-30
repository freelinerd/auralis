import 'package:flutter/material.dart';

import 'home_view.dart';
import 'sound_categories_view.dart';
import 'meditation_view.dart';
import 'frases_view.dart';
import 'profile_view.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _controller;

  final List<Widget> _pages = [
    const HomeView(key: ValueKey('home')),
    SoundCategoriesView(key: const ValueKey('sounds')),
    const MeditationView(key: ValueKey('meditation')),
    const FrasesView(key: ValueKey('frases')),
    const ProfileView(key: ValueKey('profile')),
  ];

  void _onItemTapped(int index) {
    if (index == 2) return; // El botón central tiene su propia lógica
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: List.generate(_pages.length, (index) {
          final isVisible = _selectedIndex == index;
          return IgnorePointer(
            ignoring: !isVisible,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isVisible ? 1.0 : 0.0,
              child: _pages[index],
            ),
          );
        }),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home, 'Inicio', 0),
              _navItem(Icons.music_note, 'Sonidos', 1),
              const SizedBox(width: 40),
              _navItem(Icons.format_quote, 'Frases', 3),
              _navItem(Icons.person, 'Perfil', 4),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SizedBox(
            width: 70 + _controller.value * 10,
            height: 70 + _controller.value * 10,
            child: FloatingActionButton(
              onPressed: () => setState(() => _selectedIndex = 2),
              shape: const CircleBorder(),
              backgroundColor: Colors.deepPurple,
              elevation: 8,
              child: const Icon(
                Icons.self_improvement,
                size: 48,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Icon(icon, color: isSelected ? Colors.deepPurple : Colors.grey[600]),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.deepPurple : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
