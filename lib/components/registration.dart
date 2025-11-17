import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../database/users_database.dart';
import '../base/local_storage.dart';
import '../providers/language_provider.dart';

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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _selectedCity;
  bool _loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Функция перевода
  String tr(String ru, String uz, String en) {
    final lang = Provider.of<LanguageProvider>(context, listen: false).localeCode;
    if (lang == 'ru') return ru;
    if (lang == 'uz') return uz;
    return en;
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr(
          'Пожалуйста, выберите город',
          'Iltimos, shaharni tanlang',
          'Please select a city',
        ))),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await UsersDatabase.saveUserData(
        uid: userCredential.user!.uid,
        name: _nameController.text.trim(),
        surname: _surnameController.text.trim(),
        company: _companyController.text.trim(),
      	position: _positionController.text.trim(),
        city: _selectedCity!,
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
      );

      await LocalStorage.saveUserToTxt(
        name: _nameController.text.trim(),
        surname: _surnameController.text.trim(),
        company: _companyController.text.trim(),
        position: _positionController.text.trim(),
        city: _selectedCity!,
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr(
          'Регистрация прошла успешно!',
          'Ro‘yxatdan o‘tish muvaffaqiyatli yakunlandi!',
          'Registration completed successfully!',
        ))),
      );

      Navigator.pushNamed(context, '/login');

    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          e.message ?? tr('Ошибка при регистрации', 'Ro‘yxatdan o‘tishda xatolik', 'Registration error'),
        )),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),

              Image.asset('assets/images/logo.png', width: 180, height: 80),

              const SizedBox(height: 20),

              Text(
                tr('Регистрация', 'Ro‘yxatdan o‘tish', 'Registration'),
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 25),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildInput(_nameController, tr('Имя *', 'Ism *', 'Name *')),
                    _buildInput(_surnameController, tr('Фамилия *', 'Familiya *', 'Surname *')),
                    _buildInput(_companyController, tr('Компания', 'Kompaniya', 'Company')),
                    _buildInput(_positionController, tr('Должность', 'Lavozim', 'Position')),
                    _buildCityDropdown(),
                    _buildInput(
                      _phoneController,
                      tr('Номер телефона (+998 ** *** ** **)', 'Telefon raqami', 'Phone number'),
                      keyboard: TextInputType.phone,
                    ),
                    _buildInput(
                      _emailController,
                      tr('Email *', 'Email *', 'Email *'),
                      keyboard: TextInputType.emailAddress,
                    ),
                    _buildInput(
                      _passwordController,
                      tr('Пароль *', 'Parol *', 'Password *'),
                      obscure: true,
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _register,
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
                                tr('Создать аккаунт', 'Hisob yaratish', 'Create account'),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/login'),
                      child: RichText(
                        text: TextSpan(
                          text: tr('Уже есть аккаунт? ', 'Akkount bormi? ', 'Already have an account? '),
                          style: const TextStyle(color: Colors.black87, fontSize: 15),
                          children: [
                            TextSpan(
                              text: tr('Войти', 'Kirish', 'Login'),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCityDropdown() {
    const underlineColor = Color(0xFFE53935);

    final cities = [
      tr('Ташкент', 'Toshkent', 'Tashkent'),
      tr('Самарканд', 'Samarqand', 'Samarkand'),
      tr('Навои', 'Navoiy', 'Navoi'),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: _selectedCity,
        items: cities.map((city) {
          return DropdownMenuItem(value: city, child: Text(city));
        }).toList(),
        onChanged: (v) => setState(() => _selectedCity = v),
        decoration: InputDecoration(
          labelText: tr('Город *', 'Shahar *', 'City *'),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: underlineColor, width: 2),
          ),
        ),
        validator: (v) =>
            v == null ? tr('Выберите город', 'Shaharni tanlang', 'Select a city') : null,
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String label, {
    TextInputType keyboard = TextInputType.text,
    bool obscure = false,
  }) {
    const underlineColor = Color(0xFFE53935);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: underlineColor, width: 2),
          ),
        ),
        validator: (v) =>
            v == null || v.isEmpty ? '${tr("Введите", "Kiriting", "Enter")} $label' : null,
      ),
    );
  }
}
