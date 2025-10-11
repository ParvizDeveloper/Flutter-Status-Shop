import 'package:flutter/material.dart';
import './components/login.dart';
import './components/registration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Регистрация',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      // Маршруты
      initialRoute: '/registration',
      routes: {
        '/registration': (context) => const RegistrationScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
