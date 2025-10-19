import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatabase {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  // Добавить пользователя
  Future<void> addUser(Map<String, dynamic> data) async {
    await users.doc(data['uid']).set(data);
  }
}