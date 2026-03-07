import 'package:shared_preferences/shared_preferences.dart';

/// Manages user-level preferences (birthdate, auto-wallpaper, etc.)
/// separate from the active wallpaper configuration.
class UserPrefs {
  static const _keyBirthDate = 'gow_birthDate';
  static const _keyUserName = 'gow_userName';
  static const _keyAutoSetWallpaper = 'gow_autoSetWallpaper';

  /// Returns the saved [DateTime] birthdate, or `null` if none is saved.
  static Future<DateTime?> getBirthDate() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyBirthDate);
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  /// Saves [date] (year/month/day only) as the user's birthdate.
  static Future<void> saveBirthDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    // Store only the date portion
    final normalized = DateTime(date.year, date.month, date.day);
    await prefs.setString(_keyBirthDate, normalized.toIso8601String());
  }

  /// Clears the saved birthdate.
  static Future<void> clearBirthDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyBirthDate);
  }

  /// Returns the saved user name, or `null` if none is saved.
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  /// Saves the user's display name.
  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, name);
  }

  /// Returns the auto-set wallpaper preference (defaults to true).
  static Future<bool> getAutoSetWallpaper() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAutoSetWallpaper) ?? true;
  }

  /// Saves the auto-set wallpaper preference.
  static Future<void> saveAutoSetWallpaper(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAutoSetWallpaper, enabled);
  }
}
