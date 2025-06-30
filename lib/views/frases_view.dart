import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

class FrasesView extends StatefulWidget {
  const FrasesView({super.key});

  @override
  State<FrasesView> createState() => _FrasesViewState();
}

class _FrasesViewState extends State<FrasesView>
    with SingleTickerProviderStateMixin {
  final List<String> _frases = [
    'La vida es 10% lo que nos sucede y 90% cómo reaccionamos a ello.',
    'No esperes. El tiempo nunca será justo.',
    'El éxito es la suma de pequeños esfuerzos repetidos día tras día.',
    'Cree en ti y todo será posible.',
    'Cada día es una nueva oportunidad para cambiar tu vida.',
  ];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);

    _animationController.forward();

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 15), (_) {
      _nextFrase();
    });
  }

  Future<void> _nextFrase() async {
    await _animationController.reverse();
    setState(() {
      _currentIndex = (_currentIndex + 1) % _frases.length;
    });
    await _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentFrase = _frases[_currentIndex];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Frases Motivadoras'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(Icons.navigate_next, size: 28, color: Colors.white),
        onPressed: () {
          _nextFrase();
          _startTimer(); // Reinicia el temporizador si se hace clic
        },
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo con imagen
          Image.asset('assets/background_landscape.jpg', fit: BoxFit.cover),

          // Capa difusa blanca
          Container(color: Colors.white.withOpacity(0.2)),

          // Centro con frase
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        currentFrase,
                        style: const TextStyle(
                          fontSize: 24,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          shadows: [
                            Shadow(
                              color: Colors.white,
                              blurRadius: 4,
                              offset: Offset(1, 2),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
