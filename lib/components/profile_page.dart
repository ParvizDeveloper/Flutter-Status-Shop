import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  bool _editing = false;
  bool _saving = false;

  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _positionController = TextEditingController();
  final _cityController = TextEditingController();

  String _email = '';
  String _phone = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        _nameController.text = data['name'] ?? '';
        _companyController.text = data['company'] ?? '';
        _positionController.text = data['position'] ?? '';
        _cityController.text = data['city'] ?? '';
        _email = data['email'] ?? '';
        _phone = data['phone'] ?? '';
      });
    }
  }

  Future<void> _saveChanges() async {
    final user = _auth.currentUser;
    if (user == null) return;

    setState(() => _saving = true);

    await _firestore.collection('users').doc(user.uid).update({
      'name': _nameController.text.trim(),
      'company': _companyController.text.trim(),
      'position': _positionController.text.trim(),
      'city': _cityController.text.trim(),
    });

    setState(() {
      _editing = false;
      _saving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Данные успешно обновлены')),
    );
  }

  @override
  Widget build(BuildContext context) {
    const redColor = Color(0xFFE53935);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'Профиль',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🧑‍💼 Верхняя секция
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/profile_avatar.png'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_nameController.text.isNotEmpty
                          ? _nameController.text
                          : 'Пользователь'),
                      const SizedBox(height: 4),
                      Text(_email, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.grey),
                  onPressed: () async {
                    await _auth.signOut();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ⚙️ Раздел "Личные данные"
          _sectionTitle('Личные данные'),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _editableField('Имя', _nameController),
                _editableField('Компания', _companyController),
                _editableField('Должность', _positionController),
                _editableField('Город', _cityController),
                _readonlyField('Телефон', _phone),
                _readonlyField('E-mail', _email),
              ],
            ),
          ),

          const SizedBox(height: 16),

          if (_editing)
            _saving
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(color: redColor),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: redColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Сохранить изменения',
                          style:
                              TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),

          const SizedBox(height: 24),

          // 🔧 Остальные секции
          _sectionTitle('Настройки'),
          _settingItem(Icons.shopping_bag_outlined, 'Мои заказы'),
          _settingItem(Icons.rate_review_outlined, 'Мои отзывы'),
          _settingItem(Icons.lock_outline, 'Конфиденциальность'),
          _settingItem(Icons.language_outlined, 'Язык интерфейса'),
          _settingItem(Icons.help_outline, 'Помощь'),

          const SizedBox(height: 60),
        ],
      ),
    );
  }

  // 🔹 Заголовок секции
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
    );
  }

  // 🔹 Редактируемое поле
  Widget _editableField(String label, TextEditingController controller) {
    const redColor = Color(0xFFE53935);

    return ListTile(
      title: Text(label),
      subtitle: _editing
          ? TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: label,
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: redColor),
                ),
              ),
            )
          : Text(controller.text.isNotEmpty ? controller.text : '—'),
      trailing: !_editing
          ? IconButton(
              icon: const Icon(Icons.edit_outlined, color: redColor),
              onPressed: () => setState(() => _editing = true),
            )
          : null,
    );
  }

  // 🔹 Поле только для чтения
  Widget _readonlyField(String label, String value) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value.isNotEmpty ? value : '—'),
      enabled: false,
    );
  }

  // 🔹 Пункт меню (как у Uzum)
  Widget _settingItem(IconData icon, String title) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.redAccent),
        title: Text(title,
            style:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title — раздел в разработке')),
          );
        },
      ),
    );
  }
}
