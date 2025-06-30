import 'dart:ui';
import 'package:flutter/material.dart';
import 'sound_list_view.dart';

class SoundCategoriesView extends StatelessWidget {
  SoundCategoriesView({super.key});

  final List<Map<String, dynamic>> categories = [
    {'name': 'Lluvia', 'query': 'rain', 'icon': Icons.umbrella},
    {'name': 'Bosque', 'query': 'forest', 'icon': Icons.park},
    {'name': 'Viento', 'query': 'wind', 'icon': Icons.air},
    {'name': 'Fuego', 'query': 'fire', 'icon': Icons.local_fire_department},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Sonidos Relajantes'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Imagen de fondo con opacidad
          Image.asset(
            'assets/background_landscape.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(color: Colors.white.withOpacity(0.2)),

          // Contenido principal
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.builder(
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SoundListView(
                            categoryName: cat['name'],
                            query: cat['query'],
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.3),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                cat['icon'],
                                size: 48,
                                color: Colors.deepPurpleAccent,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                cat['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 3,
                                      color: Colors.black45,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
