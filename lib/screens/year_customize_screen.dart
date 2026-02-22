import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/customize_shared_widgets.dart';
import '../models/wallpaper_config.dart';
import 'wallpaper_preview_screen.dart';

enum YearLayoutStyle { days, months, quarters }

class YearCustomizeScreen extends StatefulWidget {
  const YearCustomizeScreen({
    super.key,
    required this.wallpaperTheme,
    this.initialData,
  });

  final WallpaperTheme wallpaperTheme;
  final WallpaperData? initialData;

  @override
  State<YearCustomizeScreen> createState() => _YearCustomizeScreenState();
}

class _YearCustomizeScreenState extends State<YearCustomizeScreen> {
  YearLayoutStyle _selected = YearLayoutStyle.days;

  void _generate(AppColorPalette palette) {
    final wallpaperData = WallpaperData.yearCalendar(
      wallpaperTheme: widget.wallpaperTheme,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WallpaperPreviewScreen(data: wallpaperData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<ThemeProvider>().palette;
    final themeLabel =
        widget.wallpaperTheme == WallpaperTheme.flow ? 'The Flow' : 'Dots';

    return OrganicBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: palette.textSecondary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),

                CustomizeBreadcrumb(
                  parts: ['Year Calendar', themeLabel, 'Customize'],
                  palette: palette,
                ),

                const SizedBox(height: 10),

                Text(
                  'Define your\nwallpaper',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: palette.textPrimary,
                    letterSpacing: -0.5,
                    height: 1.15,
                  ),
                ),

                const SizedBox(height: 32),

                GlassCard(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CardSectionHeader(
                        icon: Icons.view_module_rounded,
                        title: 'Layout Style',
                        palette: palette,
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.only(left: 48),
                        child: Text(
                          'Choose how days are arranged on the wallpaper',
                          style: TextStyle(
                            fontSize: 12,
                            color: palette.textMuted,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      _LayoutOption(
                        icon: Icons.grid_on_rounded,
                        title: 'Days',
                        subtitle: 'All 365 days of the year',
                        style: YearLayoutStyle.days,
                        selected: _selected,
                        palette: palette,
                        onTap: () =>
                            setState(() => _selected = YearLayoutStyle.days),
                      ),
                      const SizedBox(height: 10),
                      _LayoutOption(
                        icon: Icons.calendar_month_rounded,
                        title: 'Months',
                        subtitle: 'Days grouped by month',
                        style: YearLayoutStyle.months,
                        selected: _selected,
                        palette: palette,
                        onTap: () =>
                            setState(() => _selected = YearLayoutStyle.months),
                      ),
                      const SizedBox(height: 10),
                      _LayoutOption(
                        icon: Icons.view_week_rounded,
                        title: 'Quarters',
                        subtitle: 'Days grouped by quarter',
                        style: YearLayoutStyle.quarters,
                        selected: _selected,
                        palette: palette,
                        onTap: () => setState(
                            () => _selected = YearLayoutStyle.quarters),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                GenerateWallpaperButton(
                  enabled: true,
                  palette: palette,
                  onTap: () => _generate(palette),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LayoutOption extends StatelessWidget {
  const _LayoutOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.style,
    required this.selected,
    required this.palette,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final YearLayoutStyle style;
  final YearLayoutStyle selected;
  final dynamic palette;
  final VoidCallback onTap;

  bool get isSelected => style == selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isSelected
            ? (palette.primary as Color).withValues(alpha: 0.18)
            : Colors.white.withValues(alpha: 0.03),
        border: Border.all(
          color: isSelected
              ? (palette.primaryLight as Color).withValues(alpha: 0.40)
              : Colors.white.withValues(alpha: 0.06),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isSelected
                      ? palette.primaryLight as Color
                      : palette.textMuted as Color,
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
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? palette.textPrimary as Color
                              : palette.textSecondary as Color,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: palette.textMuted as Color,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? palette.primaryLight as Color
                          : Colors.white.withValues(alpha: 0.2),
                      width: isSelected ? 2 : 1.5,
                    ),
                    color: isSelected
                        ? (palette.primaryLight as Color)
                            .withValues(alpha: 0.15)
                        : Colors.transparent,
                  ),
                  child: isSelected
                      ? Icon(Icons.check_rounded,
                          size: 12,
                          color: palette.primaryLight as Color)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
