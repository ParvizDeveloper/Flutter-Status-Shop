import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

import 'package:provider/provider.dart';

import 'providers/language_provider.dart';

import 'components/login.dart';
import 'components/registration.dart';
import 'pages/mainpage.dart';
import 'components/profile_page.dart';
import 'firebase_options.dart';
import 'pages/product_page.dart';
import 'base/translation.dart';
import 'pages/my_orders.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final langProvider = LanguageProvider();
  await langProvider.loadLocale();

  runApp(
    ChangeNotifierProvider.value(
      value: langProvider,
      child: const StatusShopApp(),
    ),
  );
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
        '/product': (_) => const ProductPage(product: {}),
        '/my_orders': (_) => const MyOrdersPage(),
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
    _check();
    _subscription =
        Connectivity().onConnectivityChanged.listen((c) {
      setState(() => _hasInternet = c != ConnectivityResult.none);
    });
  }

  Future<void> _check() async {
    final c = await Connectivity().checkConnectivity();
    setState(() => _hasInternet = c != ConnectivityResult.none);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _hasInternet
        ? const LoginScreen()
        : const NoInternetScreen();
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
          children: [
            const Icon(Icons.wifi_off, color: Colors.redAccent, size: 80),
            const SizedBox(height: 20),
            Text(
              tr(context, 'cart_empty'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text('Проверьте соединение и перезапустите приложение.'),
          ],
        ),
      ),
    );
  }
}
