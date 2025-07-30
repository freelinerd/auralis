import 'package:auralis/views/main_navigation_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/check_auth_view.dart';

// ✅ Agrega esta línea:
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auralis App',
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver], // ✅ Agrega el observer global aquí
      initialRoute: '/',
      routes: {
        '/': (context) => const CheckAuthView(),
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/home': (context) => const MainNavigationView(),
      },
    );
  }
}
