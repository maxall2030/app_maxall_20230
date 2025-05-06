import 'package:shared_preferences/shared_preferences.dart';

class LanguageSession {
  static const _key = 'selected_language';

  static Future<void> saveLanguage(String langCode) async {
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, langCode);
  }

  static Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    
    return prefs.getString(_key);
  }
}
