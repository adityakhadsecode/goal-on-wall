import 'package:shared_preferences/shared_preferences.dart';

/// Manages user-level preferences (birthdate, life expectancy, etc.)
/// separate from the active wallpaper configuration.
class UserPrefs {
  static const _keyBirthDate = 'gow_birthDate';

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
}
