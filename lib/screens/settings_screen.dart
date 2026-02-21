import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final palette = themeProvider.palette;

    return OrganicBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: palette.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'CUSTOMIZE YOUR EXPERIENCE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                          color: palette.textMuted,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  // Theme section
                  Text(
                    'THEME',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: palette.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GlassCard(
                    borderRadius: 20,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: AppThemes.allThemes.map((theme) {
                        final isSelected = palette.name == theme.name;
                        return _buildThemeOption(
                          context,
                          theme: theme,
                          isSelected: isSelected,
                          onTap: () => themeProvider.setPalette(theme),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Wallpaper section
                  Text(
                    'WALLPAPER',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: palette.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GlassCard(
                    borderRadius: 20,
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        _buildSettingsToggle(
                          'Auto-set Wallpaper',
                          'Automatically update wallpaper daily',
                          Icons.wallpaper_rounded,
                          true,
                          palette,
                          (val) {},
                        ),
                        Divider(
                          color: Colors.white.withValues(alpha: 0.05),
                          height: 1,
                        ),
                        _buildSettingsItem(
                          'Wallpaper Style',
                          'Dot grid with progress',
                          Icons.style_rounded,
                          palette,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Life calendar section
                  Text(
                    'LIFE CALENDAR',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: palette.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GlassCard(
                    borderRadius: 20,
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        _buildSettingsItem(
                          'Birth Date',
                          'January 1, 2000',
                          Icons.cake_rounded,
                          palette,
                        ),
                        Divider(
                          color: Colors.white.withValues(alpha: 0.05),
                          height: 1,
                        ),
                        _buildSettingsItem(
                          'Life Expectancy',
                          '80 years',
                          Icons.timeline_rounded,
                          palette,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // About section
                  Text(
                    'ABOUT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: palette.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GlassCard(
                    borderRadius: 20,
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        _buildSettingsItem(
                          'Version',
                          '1.0.0',
                          Icons.info_outline_rounded,
                          palette,
                        ),
                        Divider(
                          color: Colors.white.withValues(alpha: 0.05),
                          height: 1,
                        ),
                        _buildSettingsItem(
                          'Rate App',
                          'Share your feedback',
                          Icons.star_outline_rounded,
                          palette,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required AppColorPalette theme,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final palette = context.read<ThemeProvider>().palette;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            children: [
              // Theme color preview
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [theme.primary, theme.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: isSelected
                      ? Border.all(color: theme.accent, width: 2)
                      : null,
                ),
                child: isSelected
                    ? Icon(Icons.check_rounded, color: Colors.white, size: 18)
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      theme.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color:
                            isSelected ? theme.primaryLight : palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        _colorDot(theme.primary),
                        _colorDot(theme.primaryLight),
                        _colorDot(theme.accent),
                        _colorDot(theme.deepBackground),
                      ],
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: theme.primaryLight.withValues(alpha: 0.15),
                  ),
                  child: Text(
                    'ACTIVE',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: theme.primaryLight,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _colorDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsToggle(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    dynamic palette,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: palette.primary.withValues(alpha: 0.2),
            ),
            child: Icon(icon, color: palette.primaryLight, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: palette.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: palette.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            thumbColor: WidgetStateProperty.all(palette.primaryLight),
            trackColor: WidgetStateProperty.resolveWith((states) =>
                states.contains(WidgetState.selected)
                    ? palette.primary
                    : Colors.white.withValues(alpha: 0.1)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    String title,
    String subtitle,
    IconData icon,
    dynamic palette,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: palette.primary.withValues(alpha: 0.2),
            ),
            child: Icon(icon, color: palette.primaryLight, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: palette.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: palette.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: palette.textMuted,
            size: 20,
          ),
        ],
      ),
    );
  }
}
