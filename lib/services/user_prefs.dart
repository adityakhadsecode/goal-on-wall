import 'package:shared_preferences/shared_preferences.dart';

/// Manages user-level preferences (birthdate, life expectancy, etc.)
/// separate from the active wallpaper configuration.
class UserPrefs {
  static const _keyBirthDate = 'gow_birthDate';
  static const _keyLifeExpectancy = 'gow_lifeExpectancy';
  static const _keyUserName = 'gow_userName';
  static const int defaultLifeExpectancy = 80;

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

  /// Returns the saved life expectancy in years, or [defaultLifeExpectancy] if
  /// none is saved.
  static Future<int> getLifeExpectancy() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyLifeExpectancy) ?? defaultLifeExpectancy;
  }

  /// Saves the user's life expectancy in years.
  static Future<void> saveLifeExpectancy(int years) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyLifeExpectancy, years);
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
}
