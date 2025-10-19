import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../database/users_database.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _companyController = TextEditingController();
  final _positionController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedCity;
  final _cities = ['Ташкент', 'Самарканд', 'Навои'];

  // ====== РЕГИСТРАЦИЯ ======
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Для теста пока используем номер телефона как "email"
      final email = "${_phoneController.text}@statusshop.uz";
      const password = "temporary123"; // Можно заменить на генератор пароля

      // 1️⃣ Создаём пользователя в Firebase Auth
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // 2️⃣ Сохраняем профиль в Firestore
      final db = UserDatabase();
      await db.addUser({
        'uid': userCredential.user!.uid,
        'name': _nameController.text.trim(),
        'surname': _surnameController.text.trim(),
        'company': _companyController.text.trim(),
        'position': _positionController.text.trim(),
        'city': _selectedCity,
        'phone': _phoneController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 3️⃣ Уведомление
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Аккаунт успешно создан!')),
      );

      // 4️⃣ Переход на страницу логина
      Navigator.pushNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка Firebase: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
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
                margin: const EdgeInsets.only(top: 20, bottom: 30),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 200,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),

              // ====== ЗАГОЛОВОК ======
              const Text(
                'Регистрация',
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
                      controller: _nameController,
                      label: 'Имя *',
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Введите имя' : null,
                    ),
                    _buildInput(
                      controller: _surnameController,
                      label: 'Фамилия',
                    ),
                    _buildInput(
                      controller: _companyController,
                      label: 'Компания',
                    ),
                    _buildInput(
                      controller: _positionController,
                      label: 'Должность',
                    ),
                    _buildCityDropdown(),
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
                    const SizedBox(height: 32),

                    // ====== КНОПКА СОЗДАТЬ АККАУНТ ======
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: redColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Создать аккаунт',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ====== УЖЕ ЕСТЬ АККАУНТ ======
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/login'),
                      child: RichText(
                        text: TextSpan(
                          text: 'Уже есть аккаунт? ',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                          ),
                          children: [
                            TextSpan(
                              text: 'Войти',
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
                      'Все права защищены (2025)',
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
    String? Function(String?)? validator,
  }) {
    const underlineColor = Color(0xFFE53935);

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
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

  // ====== ВЫБОР ГОРОДА ======
  Widget _buildCityDropdown() {
    const underlineColor = Color(0xFFE53935);

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: DropdownButtonFormField<String>(
        value: _selectedCity,
        decoration: const InputDecoration(
          labelText: 'Выберите город *',
          labelStyle: TextStyle(color: Colors.black87),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: underlineColor, width: 2),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black26),
          ),
        ),
        items: _cities
            .map((city) => DropdownMenuItem(value: city, child: Text(city)))
            .toList(),
        onChanged: (value) => setState(() => _selectedCity = value),
        validator: (value) =>
            value == null || value.isEmpty ? 'Выберите город' : null,
      ),
    );
  }
}
