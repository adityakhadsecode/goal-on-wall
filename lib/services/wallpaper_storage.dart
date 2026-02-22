import 'package:shared_preferences/shared_preferences.dart';
import '../models/wallpaper_config.dart';

/// Persists the active [WallpaperData] + rendering colors to SharedPreferences
/// so the background WorkManager task can re-apply the wallpaper daily.
class WallpaperStorage {
  static const _keyCalendarType = 'gow_calendarType';
  static const _keyWallpaperTheme = 'gow_wallpaperTheme';
  static const _keyStartDate = 'gow_startDate';
  static const _keyEndDate = 'gow_endDate';
  static const _keyLabel = 'gow_label';
  static const _keyTodayColor = 'gow_todayColor';
  static const _keyLabelColor = 'gow_labelColor';
  static const _keyMonthLabelColor = 'gow_monthLabelColor';
  static const _keyWidth = 'gow_width';
  static const _keyHeight = 'gow_height';

  static Future<void> save({
    required WallpaperData data,
    required int todayColor,
    required int labelColor,
    required int monthLabelColor,
    required double width,
    required double height,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCalendarType, data.calendarType.index);
    await prefs.setInt(_keyWallpaperTheme, data.wallpaperTheme.index);
    await prefs.setString(_keyStartDate, data.startDate.toIso8601String());
    await prefs.setString(_keyEndDate, data.endDate.toIso8601String());
    if (data.label != null) {
      await prefs.setString(_keyLabel, data.label!);
    } else {
      await prefs.remove(_keyLabel);
    }
    await prefs.setInt(_keyTodayColor, todayColor);
    await prefs.setInt(_keyLabelColor, labelColor);
    await prefs.setInt(_keyMonthLabelColor, monthLabelColor);
    await prefs.setDouble(_keyWidth, width);
    await prefs.setDouble(_keyHeight, height);
  }

  static Future<SavedWallpaperConfig?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final calTypeIdx = prefs.getInt(_keyCalendarType);
    final themeIdx = prefs.getInt(_keyWallpaperTheme);
    final startStr = prefs.getString(_keyStartDate);
    final endStr = prefs.getString(_keyEndDate);

    if (calTypeIdx == null ||
        themeIdx == null ||
        startStr == null ||
        endStr == null) {
      return null;
    }

    return SavedWallpaperConfig(
      data: WallpaperData(
        calendarType: CalendarType.values[calTypeIdx],
        wallpaperTheme: WallpaperTheme.values[themeIdx],
        startDate: DateTime.parse(startStr),
        endDate: DateTime.parse(endStr),
        label: prefs.getString(_keyLabel),
      ),
      todayColor: prefs.getInt(_keyTodayColor) ?? 0xFFFF6B35,
      labelColor: prefs.getInt(_keyLabelColor) ?? 0xFFFF6B35,
      monthLabelColor: prefs.getInt(_keyMonthLabelColor) ?? 0xFF888888,
      width: prefs.getDouble(_keyWidth) ?? 1080.0,
      height: prefs.getDouble(_keyHeight) ?? 2340.0,
    );
  }
}

class SavedWallpaperConfig {
  const SavedWallpaperConfig({
    required this.data,
    required this.todayColor,
    required this.labelColor,
    required this.monthLabelColor,
    required this.width,
    required this.height,
  });

  final WallpaperData data;
  final int todayColor;
  final int labelColor;
  final int monthLabelColor;
  final double width;
  final double height;
}
