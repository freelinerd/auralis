import 'dart:ui';
import 'package:flutter/material.dart';
import 'ansiedad_screen.dart';
import 'dormir_screen.dart';
import 'morning_screen.dart';
import 'respiracion_screen.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  // Funciones de navegación
  void _goToAnsiedad(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AnsiedadScreen()),
    );
  }

  void _goToDormir(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DormirScreen()),
    );
  }

  void _goToManana(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MorningScreen()),
    );
  }

  void _goToRespiracion(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RespiracionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double cardSpacing = 16;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Auralis'),
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
            padding: const EdgeInsets.fromLTRB(20, kToolbarHeight + 40, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Bienvenido a Auralis',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    shadows: [Shadow(color: Colors.white70, blurRadius: 4)],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Selecciona una meditación para comenzar:',
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Tarjetas en Grid (2 columnas)
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: cardSpacing,
                    crossAxisSpacing: cardSpacing,
                    childAspectRatio: 0.9,
                    children: [
                      MeditationCard(
                        title: 'Ansiedad',
                        description: 'Relájate y libera el estrés.',
                        icon: Icons.self_improvement,
                        onTap: () => _goToAnsiedad(context),
                      ),
                      MeditationCard(
                        title: 'Dormir',
                        description: 'Calma tu mente y descansa.',
                        icon: Icons.nightlight_round,
                        onTap: () => _goToDormir(context),
                      ),
                      MeditationCard(
                        title: 'Mañana',
                        description: 'Empieza con energía.',
                        icon: Icons.wb_sunny,
                        onTap: () => _goToManana(context),
                      ),
                      MeditationCard(
                        title: 'Respiración',
                        description: 'Ejercicio consciente.',
                        icon: Icons.air,
                        onTap: () => _goToRespiracion(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MeditationCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const MeditationCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 48, color: Colors.deepPurpleAccent),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
