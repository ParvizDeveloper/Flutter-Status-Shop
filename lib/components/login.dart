import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../base/local_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await LocalStorage.setLoggedIn(true);

      Navigator.pushReplacementNamed(context, '/mainpage');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Ошибка входа')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const redColor = Color(0xFFE53935);
    const blueColor = Color(0xFF1E88E5);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Image.asset('assets/images/logo.png', width: 180, height: 80),
                const SizedBox(height: 20),
                const Text(
                  'Вход в аккаунт',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                _buildInput(_emailController, 'Email'),
                _buildInput(_passwordController, 'Пароль', obscure: true),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: redColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Войти',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/registration'),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Нет аккаунта? ',
                      style: TextStyle(color: Colors.black87, fontSize: 15),
                      children: [
                        TextSpan(
                          text: 'Зарегистрироваться',
                          style: TextStyle(
                            color: blueColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String label,
      {bool obscure = false}) {
    const underlineColor = Color(0xFFE53935);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: const InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: underlineColor, width: 2),
          ),
        ).copyWith(labelText: label),
      ),
    );
  }
}
