import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/customize_shared_widgets.dart';
import '../models/wallpaper_config.dart';
import '../services/user_prefs.dart';
import 'wallpaper_preview_screen.dart';

class LifeCustomizeScreen extends StatefulWidget {
  const LifeCustomizeScreen({
    super.key,
    required this.wallpaperTheme,
    this.initialData,
  });

  final WallpaperTheme wallpaperTheme;
  final WallpaperData? initialData;

  @override
  State<LifeCustomizeScreen> createState() => _LifeCustomizeScreenState();
}

class _LifeCustomizeScreenState extends State<LifeCustomizeScreen> {
  // Saved date from Settings
  DateTime? _savedBirthDate;
  bool _loadingPrefs = true;

  // "Use mine" = true (use saved), false = enter manually
  bool _useSaved = true;

  // Manual date input controllers
  final _dayCtrl = TextEditingController();
  final _monthCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      final date = widget.initialData!.startDate;
      _dayCtrl.text = date.day.toString().padLeft(2, '0');
      _monthCtrl.text = date.month.toString().padLeft(2, '0');
      _yearCtrl.text = date.year.toString();
      _useSaved = false;
      _loadingPrefs = false;
    } else {
      _loadSavedDate();
    }
  }

  Future<void> _loadSavedDate() async {
    final date = await UserPrefs.getBirthDate();
    if (mounted) {
      setState(() {
        _savedBirthDate = date;
        _loadingPrefs = false;
        // Default mode: if a saved date exists, use it automatically
        _useSaved = date != null;
      });
    }
  }

  @override
  void dispose() {
    _dayCtrl.dispose();
    _monthCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
  }

  bool get _isComplete {
    if (_useSaved && _savedBirthDate != null) return true;
    return _dayCtrl.text.length == 2 &&
        _monthCtrl.text.length == 2 &&
        _yearCtrl.text.length == 4;
  }

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

    final birthDate = _useSaved && _savedBirthDate != null
        ? _savedBirthDate!
        : DateTime(
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

                if (_loadingPrefs)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: CircularProgressIndicator(
                          color: palette.primaryLight, strokeWidth: 2),
                    ),
                  )
                else ...[
                  // ── Saved date available ──────────────────────────────
                  if (_savedBirthDate != null) ...[
                    GlassCard(
                      borderRadius: 24,
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CardSectionHeader(
                            icon: Icons.cake_rounded,
                            title: 'Birthdate',
                            palette: palette,
                          ),
                          const SizedBox(height: 16),

                          // Mode toggle
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.08)),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              children: [
                                _ModeChip(
                                  label: 'Use Mine',
                                  isSelected: _useSaved,
                                  palette: palette,
                                  onTap: () =>
                                      setState(() => _useSaved = true),
                                ),
                                _ModeChip(
                                  label: "Someone Else's",
                                  isSelected: !_useSaved,
                                  palette: palette,
                                  onTap: () =>
                                      setState(() => _useSaved = false),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Show saved date info when "Use Mine" is selected
                          AnimatedCrossFade(
                            duration: const Duration(milliseconds: 250),
                            crossFadeState: _useSaved
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            firstChild: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: palette.primaryLight
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: palette.primaryLight
                                        .withValues(alpha: 0.25)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle_rounded,
                                      color: palette.primaryLight, size: 20),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat('MMMM d, yyyy')
                                            .format(_savedBirthDate!),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: palette.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        'Saved from Settings',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: palette.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            secondChild: _buildManualDateFields(palette),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    // ── No saved date: show regular fields ─────────────
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
                          const SizedBox(height: 6),
                          // Hint to save in settings
                          Padding(
                            padding: const EdgeInsets.only(left: 48),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline_rounded,
                                    size: 12, color: palette.primaryLight),
                                const SizedBox(width: 4),
                                Text(
                                  'Save your date in Settings to skip this step next time.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: palette.primaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildManualDateFields(palette),
                        ],
                      ),
                    ),
                  ],
                ],

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

  Widget _buildManualDateFields(AppColorPalette palette) {
    return Row(
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
            maxValue: DateTime.now().year,
            minValue: 1900,
            palette: palette,
            onChanged: (_) => setState(() {}),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mode Toggle Chip
// ─────────────────────────────────────────────────────────────────────────────

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.isSelected,
    required this.palette,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final AppColorPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? palette.primaryLight.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
            border: isSelected
                ? Border.all(
                    color: palette.primaryLight.withValues(alpha: 0.4))
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? palette.primaryLight : palette.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
