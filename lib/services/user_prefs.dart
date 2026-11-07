import 'package:shared_preferences/shared_preferences.dart';

/// Manages user-level preferences (birthdate, auto-wallpaper, etc.)
/// separate from the active wallpaper configuration.
class UserPrefs {
  static const _keyBirthDate = 'gow_birthDate';
  static const _keyUserName = 'gow_userName';
  static const _keyAutoSetWallpaper = 'gow_autoSetWallpaper';
  static const _keyThemeName = 'gow_themeName';
  static const _keyShowCaption = 'gow_showCaption';
  static const _keyShowTodayGlow = 'gow_showTodayGlow';
  static const _keyShowPercent = 'gow_showPercent';
  static const _keyWallpaperTodayColor = 'gow_wallpaperTodayColor';
  static const _keyWallpaperLabelColor = 'gow_wallpaperLabelColor';
  static const _keyWallpaperMonthLabelColor = 'gow_wallpaperMonthLabelColor';

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

  /// Returns the saved theme palette name, or `null` if none is saved.
  static Future<String?> getThemeName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyThemeName);
  }

  /// Saves the selected theme palette name.
  static Future<void> saveThemeName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemeName, name);
  }

  /// Wallpaper customization toggles (default true), shared by the preview
  /// screen and the daily background refresh so both render identically.
  static Future<bool> getShowCaption() async =>
      (await SharedPreferences.getInstance()).getBool(_keyShowCaption) ?? true;

  static Future<bool> getShowTodayGlow() async =>
      (await SharedPreferences.getInstance()).getBool(_keyShowTodayGlow) ??
          true;

  static Future<bool> getShowPercent() async =>
      (await SharedPreferences.getInstance()).getBool(_keyShowPercent) ?? true;

  static Future<void> saveShowCaption(bool value) async =>
      (await SharedPreferences.getInstance()).setBool(_keyShowCaption, value);

  static Future<void> saveShowTodayGlow(bool value) async =>
      (await SharedPreferences.getInstance())
          .setBool(_keyShowTodayGlow, value);

  static Future<void> saveShowPercent(bool value) async =>
      (await SharedPreferences.getInstance()).setBool(_keyShowPercent, value);

  /// Wallpaper color overrides (ARGB ints). `null` = derive from the app
  /// theme. Used by the preview screen; the chosen values are baked into the
  /// saved wallpaper config so the daily refresh renders identically.
  static Future<int?> getWallpaperTodayColor() async =>
      (await SharedPreferences.getInstance()).getInt(_keyWallpaperTodayColor);

  static Future<int?> getWallpaperLabelColor() async =>
      (await SharedPreferences.getInstance()).getInt(_keyWallpaperLabelColor);

  static Future<int?> getWallpaperMonthLabelColor() async =>
      (await SharedPreferences.getInstance())
          .getInt(_keyWallpaperMonthLabelColor);

  static Future<void> saveWallpaperTodayColor(int argb) async =>
      (await SharedPreferences.getInstance())
          .setInt(_keyWallpaperTodayColor, argb);

  static Future<void> saveWallpaperLabelColor(int argb) async =>
      (await SharedPreferences.getInstance())
          .setInt(_keyWallpaperLabelColor, argb);

  static Future<void> saveWallpaperMonthLabelColor(int argb) async =>
      (await SharedPreferences.getInstance())
          .setInt(_keyWallpaperMonthLabelColor, argb);

  static Future<void> clearWallpaperColors() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyWallpaperTodayColor);
    await prefs.remove(_keyWallpaperLabelColor);
    await prefs.remove(_keyWallpaperMonthLabelColor);
  }
}
