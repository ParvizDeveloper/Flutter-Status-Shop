import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../base/local_storage.dart';
import '../providers/language_provider.dart';

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

  /// 🔥 Удобная функция перевода
  String tr(String ru, String uz, String en) {
    final lang = Provider.of<LanguageProvider>(context, listen: false).localeCode;
    if (lang == 'ru') return ru;
    if (lang == 'uz') return uz;
    return en;
  }

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
        SnackBar(
          content: Text(
            e.message ?? tr('Ошибка входа', 'Kirishda xatolik', 'Login error'),
          ),
        ),
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

                /// ЛОГОТИП
                Image.asset('assets/images/logo.png', width: 180, height: 80),

                const SizedBox(height: 20),

                /// 🔥 Заголовок
                Text(
                  tr('Вход в аккаунт', 'Akkauntga kirish', 'Login to account'),
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 40),

                /// 🔥 Поля ввода
                _buildInput(_emailController, tr('Email', 'Email', 'Email')),
                _buildInput(_passwordController, tr('Пароль', 'Parol', 'Password'),
                    obscure: true),

                const SizedBox(height: 30),

                /// 🔥 Кнопка Войти
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
                        : Text(
                            tr('Войти', 'Kirish', 'Sign In'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔥 Ссылка "Нет аккаунта?"
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/registration'),
                  child: RichText(
                    text: TextSpan(
                      text: tr(
                        'Нет аккаунта? ',
                        'Akkaunt yo‘qmi? ',
                        'No account? ',
                      ),
                      style: const TextStyle(color: Colors.black87, fontSize: 15),
                      children: [
                        TextSpan(
                          text: tr(
                              'Зарегистрироваться',
                              'Ro‘yxatdan o‘tish',
                              'Register'),
                          style: const TextStyle(
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
        decoration: InputDecoration(
          labelText: label,
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: underlineColor, width: 2),
          ),
        ),
      ),
    );
  }
}
