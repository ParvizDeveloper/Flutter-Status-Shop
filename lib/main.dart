import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './components/login.dart';
import './components/registration.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Регистрация',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        inputDecorationTheme: const InputDecorationTheme(
          border: UnderlineInputBorder(),
        ),
      ),
      // Маршруты
      initialRoute: '/registration',
      routes: {
        '/registration': (context) => const RegistrationScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
