import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/customize_shared_widgets.dart';
import '../models/wallpaper_config.dart';

class GoalCustomizeScreen extends StatefulWidget {
  const GoalCustomizeScreen({super.key, required this.wallpaperTheme});

  final WallpaperTheme wallpaperTheme;

  @override
  State<GoalCustomizeScreen> createState() => _GoalCustomizeScreenState();
}

class _GoalCustomizeScreenState extends State<GoalCustomizeScreen> {
  final _goalCtrl = TextEditingController();

  // Start date
  final _startYearCtrl = TextEditingController();
  final _startMonthCtrl = TextEditingController();
  final _startDayCtrl = TextEditingController();

  // Deadline
  final _deadlineYearCtrl = TextEditingController();
  final _deadlineMonthCtrl = TextEditingController();
  final _deadlineDayCtrl = TextEditingController();

  @override
  void dispose() {
    _goalCtrl.dispose();
    _startYearCtrl.dispose();
    _startMonthCtrl.dispose();
    _startDayCtrl.dispose();
    _deadlineYearCtrl.dispose();
    _deadlineMonthCtrl.dispose();
    _deadlineDayCtrl.dispose();
    super.dispose();
  }

  bool get _isComplete =>
      _goalCtrl.text.trim().isNotEmpty &&
      _startYearCtrl.text.length == 4 &&
      _startMonthCtrl.text.length == 2 &&
      _startDayCtrl.text.length == 2 &&
      _deadlineYearCtrl.text.length == 4 &&
      _deadlineMonthCtrl.text.length == 2 &&
      _deadlineDayCtrl.text.length == 2;

  void _generate(AppColorPalette palette) {
    if (!_isComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: palette.cardBackground,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Text(
            'Please fill in all fields.',
            style: TextStyle(color: palette.textSecondary),
          ),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: palette.cardBackground,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(
          'Generating Goal Calendar for "${_goalCtrl.text}"…',
          style: TextStyle(color: palette.primaryLight),
        ),
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
                  parts: ['Goal Calendar', themeLabel, 'Customize'],
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

                // ── Goal name ─────────────────────────────────
                GlassCard(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CardSectionHeader(
                        icon: Icons.emoji_events_rounded,
                        title: 'Goal',
                        palette: palette,
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.only(left: 48),
                        child: Text(
                          'E.g., New York City Marathon',
                          style: TextStyle(
                            fontSize: 12,
                            color: palette.textMuted,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _GoalTextField(
                        controller: _goalCtrl,
                        hint: 'Enter your goal…',
                        palette: palette,
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ── Start date ────────────────────────────────
                GlassCard(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CardSectionHeader(
                        icon: Icons.play_circle_outline_rounded,
                        title: 'Start Date',
                        palette: palette,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: DateInputField(
                              controller: _startYearCtrl,
                              hint: 'YYYY',
                              label: 'Year',
                              maxLength: 4,
                              palette: palette,
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DateInputField(
                              controller: _startMonthCtrl,
                              hint: 'MM',
                              label: 'Month',
                              maxLength: 2,
                              palette: palette,
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DateInputField(
                              controller: _startDayCtrl,
                              hint: 'DD',
                              label: 'Day',
                              maxLength: 2,
                              palette: palette,
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ── Deadline ──────────────────────────────────
                GlassCard(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CardSectionHeader(
                        icon: Icons.flag_rounded,
                        title: 'Deadline',
                        palette: palette,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: DateInputField(
                              controller: _deadlineYearCtrl,
                              hint: 'YYYY',
                              label: 'Year',
                              maxLength: 4,
                              palette: palette,
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DateInputField(
                              controller: _deadlineMonthCtrl,
                              hint: 'MM',
                              label: 'Month',
                              maxLength: 2,
                              palette: palette,
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DateInputField(
                              controller: _deadlineDayCtrl,
                              hint: 'DD',
                              label: 'Day',
                              maxLength: 2,
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

// ── Goal text field (local, only used here) ───────────────────
class _GoalTextField extends StatelessWidget {
  const _GoalTextField({
    required this.controller,
    required this.hint,
    required this.palette,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final dynamic palette;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 15,
          color: palette.textPrimary as Color,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14,
            color: palette.textMuted as Color,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
        ),
      ),
    );
  }
}
