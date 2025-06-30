import 'package:flutter/material.dart';
import 'views/login_view.dart';
import 'views/home_view.dart';
import 'views/register_view.dart';
import 'views/splash_view.dart';

class MeditApp extends StatelessWidget {
  const MeditApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auralis',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashView(),
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/home': (context) => const HomeView(),
      },
    );
  }
}
