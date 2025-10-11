import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Вход выполнен успешно!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const redColor = Color(0xFFE53935);
    const blueColor = Color(0xFF1E88E5);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ====== ЛОГОТИП ======
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 90),
                child: Image.asset(
                  'assets/images/logo.png', // <-- тот же логотип
                  width: 200,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),

              // ====== ЗАГОЛОВОК ======
              const Text(
                'Вход в аккаунт',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 32),

              // ====== ФОРМА ======
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildInput(
                      controller: _phoneController,
                      label: 'Номер телефона (+998 ** *** ** **)',
                      keyboardType: TextInputType.phone,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Введите номер телефона';
                        }
                        if (!RegExp(r'^\+998\d{9}$').hasMatch(v)) {
                          return 'Формат должен быть: +998XXXXXXXXX';
                        }
                        return null;
                      },
                    ),
                    _buildInput(
                      controller: _passwordController,
                      label: 'Пароль',
                      obscureText: true,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Введите пароль' : null,
                    ),
                    const SizedBox(height: 32),
                    

                    // ====== КНОПКА ВОЙТИ ======
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: redColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Войти',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ====== ЕЩЁ НЕТ АККАУНТА ======
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/register'),
                      child: RichText(
                        text: TextSpan(
                          text: 'Ещё нет аккаунта? ',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                          ),
                          children: [
                            TextSpan(
                              text: 'Создать',
                              style: TextStyle(
                                color: blueColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // ====== КОПИРАЙТ ======
                    const Text(
                      '© 2025 Все права защищены',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ====== ОДНО ПОЛЕ ВВОДА ======
  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    const underlineColor = Color(0xFFE53935);

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        obscureText: obscureText,
        cursorColor: underlineColor,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black87),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: underlineColor, width: 2),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black26),
          ),
        ),
      ),
    );
  }
}
