import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/customize_shared_widgets.dart';
import '../models/wallpaper_config.dart';
import 'wallpaper_preview_screen.dart';

class LifeCustomizeScreen extends StatefulWidget {
  const LifeCustomizeScreen({super.key, required this.wallpaperTheme});

  final WallpaperTheme wallpaperTheme;

  @override
  State<LifeCustomizeScreen> createState() => _LifeCustomizeScreenState();
}

class _LifeCustomizeScreenState extends State<LifeCustomizeScreen> {
  final _dayCtrl = TextEditingController();
  final _monthCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();

  @override
  void dispose() {
    _dayCtrl.dispose();
    _monthCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
  }

  bool get _isComplete =>
      _dayCtrl.text.length == 2 &&
      _monthCtrl.text.length == 2 &&
      _yearCtrl.text.length == 4;

  int get _birthMaxDay {
    final y = int.tryParse(_yearCtrl.text) ?? DateTime.now().year;
    final m = (int.tryParse(_monthCtrl.text) ?? 1).clamp(1, 12);
    return DateTime(y, m + 1, 0).day;
  }

  void _generate(AppColorPalette palette) {
    if (!_isComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: palette.cardBackground,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          content: Text(
            'Please enter a complete birthdate.',
            style: TextStyle(color: palette.textSecondary),
          ),
        ),
      );
      return;
    }
    final birthDate = DateTime(
      int.parse(_yearCtrl.text),
      int.parse(_monthCtrl.text),
      int.parse(_dayCtrl.text),
    );
    // Life calendar: birthdate → 80th birthday
    final endDate = DateTime(
      birthDate.year + 80,
      birthDate.month,
      birthDate.day,
    );
    final wallpaperData = WallpaperData(
      calendarType: CalendarType.life,
      wallpaperTheme: widget.wallpaperTheme,
      startDate: birthDate,
      endDate: endDate,
      label: 'Life Calendar',
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
                  parts: ['Life Calendar', themeLabel, 'Customize'],
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
                        icon: Icons.cake_rounded,
                        title: 'Enter Birthdate',
                        palette: palette,
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.only(left: 48),
                        child: Text(
                          'Used to calculate weeks already lived',
                          style: TextStyle(
                            fontSize: 12,
                            color: palette.textMuted,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: DateInputField(
                              controller: _dayCtrl,
                              hint: 'DD',
                              label: 'Day',
                              maxLength: 2,
                              maxValue: _birthMaxDay,
                              palette: palette,
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DateInputField(
                              controller: _monthCtrl,
                              hint: 'MM',
                              label: 'Month',
                              maxLength: 2,
                              maxValue: 12,
                              palette: palette,
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: DateInputField(
                              controller: _yearCtrl,
                              hint: 'YYYY',
                              label: 'Year',
                              maxLength: 4,
                              maxValue: 2099,
                              minValue: 1900,
                              palette: palette,
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                GenerateWallpaperButton(
                  enabled: _isComplete,
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
