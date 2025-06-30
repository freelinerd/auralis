import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckAuthView extends StatelessWidget {
  const CheckAuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Esperando respuesta
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Si hay sesión iniciada, ir a Home
        if (snapshot.hasData) {
          Future.microtask(
            () => Navigator.pushReplacementNamed(context, '/home'),
          );
        } else {
          Future.microtask(
            () => Navigator.pushReplacementNamed(context, '/login'),
          );
        }

        return const SizedBox.shrink(); // Vacío mientras redirige
      },
    );
  }
}
