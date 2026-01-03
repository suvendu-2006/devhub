import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static const String _userBoxName = 'user_data';
  static const String _bookmarksBoxName = 'bookmarks';
  static const String _settingsBoxName = 'settings';
  
  static late Box _userBox;
  static late Box _bookmarksBox;
  static late Box _settingsBox;
  
  // Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    _userBox = await Hive.openBox(_userBoxName);
    _bookmarksBox = await Hive.openBox(_bookmarksBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
  }
  
  // User Profile
  static Future<void> saveUserProfile({
    String? name,
    String? email,
    String? bio,
    String? currentRole,
    int? yearsExperience,
  }) async {
    if (name != null) await _userBox.put('name', name);
    if (email != null) await _userBox.put('email', email);
    if (bio != null) await _userBox.put('bio', bio);
    if (currentRole != null) await _userBox.put('currentRole', currentRole);
    if (yearsExperience != null) await _userBox.put('yearsExperience', yearsExperience);
  }
  
  static Map<String, dynamic> getUserProfile() {
    return {
      'name': _userBox.get('name', defaultValue: ''),
      'email': _userBox.get('email', defaultValue: ''),
      'bio': _userBox.get('bio', defaultValue: ''),
      'currentRole': _userBox.get('currentRole', defaultValue: ''),
      'yearsExperience': _userBox.get('yearsExperience', defaultValue: 0),
    };
  }
  
  // Skills
  static Future<void> saveSkills(List<String> skills) async {
    await _userBox.put('skills', skills);
  }
  
  static List<String> getSkills() {
    final skills = _userBox.get('skills', defaultValue: <String>[]);
    return List<String>.from(skills);
  }
  
  // Selected Goal
  static Future<void> saveSelectedGoal(String? goalId) async {
    if (goalId != null) {
      await _userBox.put('selectedGoal', goalId);
    } else {
      await _userBox.delete('selectedGoal');
    }
  }
  
  static String? getSelectedGoal() {
    return _userBox.get('selectedGoal');
  }
  
  // Bookmarks
  static Future<void> addBookmark(String type, String id) async {
    final key = '${type}_$id';
    await _bookmarksBox.put(key, true);
  }
  
  static Future<void> removeBookmark(String type, String id) async {
    final key = '${type}_$id';
    await _bookmarksBox.delete(key);
  }
  
  static bool isBookmarked(String type, String id) {
    final key = '${type}_$id';
    return _bookmarksBox.get(key, defaultValue: false);
  }
  
  static List<String> getBookmarkedIds(String type) {
    final List<String> ids = [];
    for (var key in _bookmarksBox.keys) {
      if (key.toString().startsWith('${type}_')) {
        ids.add(key.toString().replaceFirst('${type}_', ''));
      }
    }
    return ids;
  }
  
  // Settings
  static Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }
  
  static T? getSetting<T>(String key, {T? defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue);
  }
  
  // API Keys (encrypted storage would be better for production)
  static Future<void> saveApiKey(String provider, String key) async {
    await _settingsBox.put('api_key_$provider', key);
  }
  
  static String? getApiKey(String provider) {
    return _settingsBox.get('api_key_$provider');
  }
  
  // Theme
  static Future<void> saveThemeMode(bool isDark) async {
    await _settingsBox.put('isDarkMode', isDark);
  }
  
  static bool getThemeMode() {
    return _settingsBox.get('isDarkMode', defaultValue: true);
  }
  
  // Clear all data
  static Future<void> clearAll() async {
    await _userBox.clear();
    await _bookmarksBox.clear();
    await _settingsBox.clear();
  }
}
