import 'package:flutter/material.dart';
import 'app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  AppColorPalette _currentPalette = AppThemes.forest;

  AppColorPalette get palette => _currentPalette;

  void setPalette(AppColorPalette palette) {
    _currentPalette = palette;
    notifyListeners();
  }

  void setPaletteByName(String name) {
    final found = AppThemes.allThemes.firstWhere(
      (t) => t.name == name,
      orElse: () => AppThemes.forest,
    );
    setPalette(found);
  }
}
