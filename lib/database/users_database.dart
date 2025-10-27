import 'package:cloud_firestore/cloud_firestore.dart';

class UsersDatabase {
  // Ссылка на коллекцию "users"
  static final _db = FirebaseFirestore.instance.collection('users');

  /// Создание нового пользователя
  static Future<void> saveUserData({
    required String uid,
    required String name,
    required String surname,
    required String company,
    required String position,
    required String city,
    required String phone,
    required String email,
  }) async {
    try {
      await _db.doc(uid).set({
        'uid': uid,
        'name': name,
        'surname': surname,
        'company': company,
        'position': position,
        'city': city,
        'phone': phone,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('✅ User saved to Firestore');
    } catch (e) {
      print('❌ Error saving user: $e');
      rethrow;
    }
  }

  /// Обновление данных пользователя (для CRUD/админки)
  static Future<void> updateUserData(String uid, Map<String, dynamic> newData) async {
    try {
      await _db.doc(uid).update(newData);
      print('✅ User updated');
    } catch (e) {
      print('❌ Error updating user: $e');
      rethrow;
    }
  }

  /// Удаление пользователя (для админки)
  static Future<void> deleteUser(String uid) async {
    try {
      await _db.doc(uid).delete();
      print('✅ User deleted');
    } catch (e) {
      print('❌ Error deleting user: $e');
      rethrow;
    }
  }

  /// Получение данных пользователя
  static Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String uid) async {
    try {
      return await _db.doc(uid).get();
    } catch (e) {
      print('❌ Error fetching user: $e');
      rethrow;
    }
  }
}
