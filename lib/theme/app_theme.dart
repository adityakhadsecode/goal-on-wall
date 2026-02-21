import 'package:flutter/material.dart';

/// Defines a custom color palette for the app themes.
class AppColorPalette {
  final String name;
  final Color deepBackground;
  final Color cardBackground;
  final Color surfaceColor;
  final Color primary;
  final Color primaryLight;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color borderColor;
  final Color navBackground;
  final List<Color> vineGradient;
  final List<Color> buttonGradient;

  const AppColorPalette({
    required this.name,
    required this.deepBackground,
    required this.cardBackground,
    required this.surfaceColor,
    required this.primary,
    required this.primaryLight,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.borderColor,
    required this.navBackground,
    required this.vineGradient,
    required this.buttonGradient,
  });
}

class AppThemes {
  static const forest = AppColorPalette(
    name: 'Forest',
    deepBackground: Color(0xFF050805),
    cardBackground: Color(0xFF0F1810),
    surfaceColor: Color(0xFF241A12),
    primary: Color(0xFF586935),
    primaryLight: Color(0xFF9EC043),
    accent: Color(0xFFE8A838),
    textPrimary: Color(0xFFEDE8E3),
    textSecondary: Color(0xFFA8A29E),
    textMuted: Color(0xFF78716C),
    borderColor: Color(0x0DFFFFFF),
    navBackground: Color(0xD90F1810),
    vineGradient: [Color(0xFF586935), Color(0xFF9EC043), Color(0xFFE8A838)],
    buttonGradient: [Color(0xFF586935), Color(0xFF9EC043)],
  );

  static const ocean = AppColorPalette(
    name: 'Ocean',
    deepBackground: Color(0xFF030B14),
    cardBackground: Color(0xFF0A1929),
    surfaceColor: Color(0xFF0D2137),
    primary: Color(0xFF1565C0),
    primaryLight: Color(0xFF42A5F5),
    accent: Color(0xFF00E5FF),
    textPrimary: Color(0xFFE3F2FD),
    textSecondary: Color(0xFF90A4AE),
    textMuted: Color(0xFF546E7A),
    borderColor: Color(0x0DFFFFFF),
    navBackground: Color(0xD90A1929),
    vineGradient: [Color(0xFF1565C0), Color(0xFF42A5F5), Color(0xFF00E5FF)],
    buttonGradient: [Color(0xFF1565C0), Color(0xFF42A5F5)],
  );

  static const sunset = AppColorPalette(
    name: 'Sunset',
    deepBackground: Color(0xFF0A0506),
    cardBackground: Color(0xFF1A0E10),
    surfaceColor: Color(0xFF2D1518),
    primary: Color(0xFFD84315),
    primaryLight: Color(0xFFFF7043),
    accent: Color(0xFFFFAB40),
    textPrimary: Color(0xFFFBE9E7),
    textSecondary: Color(0xFFBCAAA4),
    textMuted: Color(0xFF8D6E63),
    borderColor: Color(0x0DFFFFFF),
    navBackground: Color(0xD91A0E10),
    vineGradient: [Color(0xFFD84315), Color(0xFFFF7043), Color(0xFFFFAB40)],
    buttonGradient: [Color(0xFFD84315), Color(0xFFFF7043)],
  );

  static const midnight = AppColorPalette(
    name: 'Midnight',
    deepBackground: Color(0xFF05020A),
    cardBackground: Color(0xFF0D0618),
    surfaceColor: Color(0xFF1A0D2E),
    primary: Color(0xFF7C4DFF),
    primaryLight: Color(0xFFB388FF),
    accent: Color(0xFFE040FB),
    textPrimary: Color(0xFFEDE7F6),
    textSecondary: Color(0xFF9FA8DA),
    textMuted: Color(0xFF5C6BC0),
    borderColor: Color(0x0DFFFFFF),
    navBackground: Color(0xD90D0618),
    vineGradient: [Color(0xFF7C4DFF), Color(0xFFB388FF), Color(0xFFE040FB)],
    buttonGradient: [Color(0xFF7C4DFF), Color(0xFFB388FF)],
  );

  static const rose = AppColorPalette(
    name: 'Rose',
    deepBackground: Color(0xFF080305),
    cardBackground: Color(0xFF1A0A12),
    surfaceColor: Color(0xFF2D1320),
    primary: Color(0xFFC2185B),
    primaryLight: Color(0xFFF06292),
    accent: Color(0xFFFFCDD2),
    textPrimary: Color(0xFFFCE4EC),
    textSecondary: Color(0xFFCE93D8),
    textMuted: Color(0xFF8E6B7A),
    borderColor: Color(0x0DFFFFFF),
    navBackground: Color(0xD91A0A12),
    vineGradient: [Color(0xFFC2185B), Color(0xFFF06292), Color(0xFFFFCDD2)],
    buttonGradient: [Color(0xFFC2185B), Color(0xFFF06292)],
  );

  static List<AppColorPalette> get allThemes => [
        forest,
        ocean,
        sunset,
        midnight,
        rose,
      ];
}
