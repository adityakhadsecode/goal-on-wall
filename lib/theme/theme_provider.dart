import 'package:flutter/material.dart';
import '../services/user_prefs.dart';
import 'app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  AppColorPalette _currentPalette = AppThemes.forest;

  ThemeProvider() {
    _loadSavedTheme();
  }

  AppColorPalette get palette => _currentPalette;

  Future<void> _loadSavedTheme() async {
    final name = await UserPrefs.getThemeName();
    if (name != null) setPaletteByName(name, persist: false);
  }

  void setPalette(AppColorPalette palette) {
    _currentPalette = palette;
    UserPrefs.saveThemeName(palette.name);
    notifyListeners();
  }

  void setPaletteByName(String name, {bool persist = true}) {
    final found = AppThemes.allThemes.firstWhere(
      (t) => t.name == name,
      orElse: () => AppThemes.forest,
    );
    if (persist) {
      setPalette(found);
    } else {
      _currentPalette = found;
      notifyListeners();
    }
  }
}
