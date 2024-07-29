import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static SessionManager? _instance;
  late SharedPreferences _prefs;

  // Private constructor
  SessionManager._();

  // Singleton instance retrieval
  static Future<SessionManager> getInstance() async {
    if (_instance == null) {
      _instance = SessionManager._();
      await _instance!._init();
    }
    return _instance!;
  }

  // Initialize SharedPreferences
  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save string value to SharedPreferences
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  // Retrieve string value from SharedPreferences
  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  // Remove value from SharedPreferences
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }
}
