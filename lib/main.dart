import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

import 'components/login.dart';
import 'components/registration.dart';
import 'pages/mainpage.dart';
import 'components/profile_page.dart';
import 'firebase_options.dart';
import 'pages/product_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const StatusShopApp());
}

class StatusShopApp extends StatelessWidget {
  const StatusShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Status Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      home: const ConnectionChecker(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/registration': (_) => const RegistrationScreen(),
        '/mainpage': (_) => const MainPage(),
        '/profile': (_) => const ProfilePage(),
        '/product': (_) => const ProductPage(
        product: {}, 
      ),
      },
    );
  }
}

class ConnectionChecker extends StatefulWidget {
  const ConnectionChecker({super.key});

  @override
  State<ConnectionChecker> createState() => _ConnectionCheckerState();
}

class _ConnectionCheckerState extends State<ConnectionChecker> {
  bool _hasInternet = true;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _checkConnection();
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      setState(() => _hasInternet = result != ConnectivityResult.none);
    });
  }

  Future<void> _checkConnection() async {
    final result = await Connectivity().checkConnectivity();
    setState(() => _hasInternet = result != ConnectivityResult.none);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasInternet) {
      return const NoInternetScreen();
    }
    return const LoginScreen();
  }
}

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.wifi_off, color: Colors.redAccent, size: 80),
            SizedBox(height: 20),
            Text(
              'Нет подключения к интернету',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text('Проверьте соединение и перезапустите приложение.'),
          ],
        ),
      ),
    );
  }
}
