import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _fileName = 'users.txt';
  static const _loggedKey = 'is_logged_in';

  /// 📁 Получаем путь к локальной папке
  static Future<String> _getFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/$_fileName';
  }

  /// 💾 Сохраняем пользователя в TXT
  static Future<void> saveUserToTxt({
    required String name,
    required String surname,
    required String company,
    required String position,
    required String city,
    required String phone,
    required String email,
  }) async {
    final filePath = await _getFilePath();
    final file = File(filePath);

    final data = '''
name=$name
surname=$surname
company=$company
position=$position
city=$city
phone=$phone
email=$email
---
''';

    await file.writeAsString(data, mode: FileMode.append);
  }

  /// 📖 Считываем последнего пользователя из TXT
  static Future<Map<String, String>> readUserFromTxt() async {
    final filePath = await _getFilePath();
    final file = File(filePath);

    if (!await file.exists()) return {};

    final lines = await file.readAsLines();
    final Map<String, String> data = {};

    for (var line in lines) {
      if (line.trim().isEmpty || line.trim() == '---') continue;
      final parts = line.split('=');
      if (parts.length == 2) data[parts[0]] = parts[1];
    }

    return data;
  }

  /// 🔐 Сохраняем статус авторизации
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedKey, value);
  }

  /// 🔓 Проверяем, вошёл ли пользователь
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedKey) ?? false;
  }

  /// 🚪 Выход из аккаунта
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedKey, false);
  }
}
