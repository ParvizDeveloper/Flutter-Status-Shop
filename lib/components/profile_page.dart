import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../base/translation.dart';

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

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(tr(context, 'saved'))));
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
        title: Text(
          tr(context, 'profile'),
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // TOP
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
                      Text(
                        _nameController.text.isNotEmpty
                            ? _nameController.text
                            : tr(context, 'user'),
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                      ),
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

          _sectionTitle(tr(context, 'personal_data')),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _editableField(tr(context, 'name'), _nameController),
                _editableField(tr(context, 'company'), _companyController),
                _editableField(tr(context, 'position'), _positionController),
                _editableField(tr(context, 'city'), _cityController),

                _readonlyField(tr(context, 'phone'), _phone),
                _readonlyField('Email', _email),
              ],
            ),
          ),

          const SizedBox(height: 16),

          if (_editing)
            _saving
                ? const Center(child: CircularProgressIndicator(color: redColor))
                : ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: redColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      tr(context, 'save'),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),

          const SizedBox(height: 24),

          _sectionTitle(tr(context, 'settings')),

          // ---- FIXED ---- МОИ ЗАКАЗЫ теперь работает!
          _settingItem(
            Icons.shopping_bag_outlined,
            tr(context, 'my_orders'),
            onTap: () {
              Navigator.pushNamed(context, '/my_orders');
            },
          ),

          _settingItem(
            Icons.rate_review_outlined,
            tr(context, 'my_reviews'),
          ),

          _settingItem(
            Icons.lock_outline,
            tr(context, 'privacy'),
          ),

          // LANGUAGE SELECTOR
          Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const Icon(Icons.language_outlined, color: redColor),
              title: Text(tr(context, 'language')),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showLanguageModal(),
            ),
          ),

          _settingItem(Icons.help_outline, tr(context, 'help')),

          const SizedBox(height: 60),
        ],
      ),
    );
  }

  void _showLanguageModal() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        final lp = Provider.of<LanguageProvider>(context, listen: false);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: const Text('Русский'), onTap: () {
              lp.setLocale('ru');
              Navigator.pop(context);
            }),
            ListTile(title: const Text("O'zbekcha"), onTap: () {
              lp.setLocale('uz');
              Navigator.pop(context);
            }),
            ListTile(title: const Text('English'), onTap: () {
              lp.setLocale('en');
              Navigator.pop(context);
            }),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
  );

  Widget _editableField(String label, TextEditingController controller) {
    const redColor = Color(0xFFE53935);

    return ListTile(
      title: Text(label),
      subtitle: _editing
          ? TextField(
              controller: controller,
              decoration: const InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: redColor)),
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

  Widget _readonlyField(String label, String value) =>
      ListTile(title: Text(label), subtitle: Text(value), enabled: false);

  Widget _settingItem(IconData icon, String title, {VoidCallback? onTap}) =>
      Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: Icon(icon, color: Colors.redAccent),
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
      );
}
