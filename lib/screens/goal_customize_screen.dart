import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/customize_shared_widgets.dart';
import '../models/wallpaper_config.dart';
import 'wallpaper_preview_screen.dart';

class GoalCustomizeScreen extends StatefulWidget {
  const GoalCustomizeScreen({
    super.key,
    required this.wallpaperTheme,
    this.initialData,
  });

  final WallpaperTheme wallpaperTheme;
  final WallpaperData? initialData;

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

  // Validation
  bool _dateOrderError = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      final data = widget.initialData!;
      _goalCtrl.text = data.label ?? '';
      
      _startDayCtrl.text = data.startDate.day.toString().padLeft(2, '0');
      _startMonthCtrl.text = data.startDate.month.toString().padLeft(2, '0');
      _startYearCtrl.text = data.startDate.year.toString();

      _deadlineDayCtrl.text = data.endDate.day.toString().padLeft(2, '0');
      _deadlineMonthCtrl.text = data.endDate.month.toString().padLeft(2, '0');
      _deadlineYearCtrl.text = data.endDate.year.toString();
    }
  }

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

  void _checkDateOrder() {
    if (!_isComplete) return;
    final start = DateTime(
      int.parse(_startYearCtrl.text),
      int.parse(_startMonthCtrl.text),
      int.parse(_startDayCtrl.text),
    );
    final end = DateTime(
      int.parse(_deadlineYearCtrl.text),
      int.parse(_deadlineMonthCtrl.text),
      int.parse(_deadlineDayCtrl.text),
    );
    setState(() => _dateOrderError = !start.isBefore(end));
  }

  int get _startMaxDay {
    final y = int.tryParse(_startYearCtrl.text) ?? DateTime.now().year;
    final m = (int.tryParse(_startMonthCtrl.text) ?? 1).clamp(1, 12);
    return DateTime(y, m + 1, 0).day;
  }

  int get _deadlineMaxDay {
    final y = int.tryParse(_deadlineYearCtrl.text) ?? DateTime.now().year;
    final m = (int.tryParse(_deadlineMonthCtrl.text) ?? 1).clamp(1, 12);
    return DateTime(y, m + 1, 0).day;
  }

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
    final startDate = DateTime(
      int.parse(_startYearCtrl.text),
      int.parse(_startMonthCtrl.text),
      int.parse(_startDayCtrl.text),
    );
    final endDate = DateTime(
      int.parse(_deadlineYearCtrl.text),
      int.parse(_deadlineMonthCtrl.text),
      int.parse(_deadlineDayCtrl.text),
    );
    if (!startDate.isBefore(endDate)) {
      setState(() => _dateOrderError = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: palette.cardBackground,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Row(
            children: [
              Icon(Icons.error_outline_rounded,
                  color: Colors.redAccent, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Start date must be earlier than the deadline.',
                  style: TextStyle(color: palette.textPrimary),
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }
    setState(() => _dateOrderError = false);
    final wallpaperData = WallpaperData(
      calendarType: CalendarType.goal,
      wallpaperTheme: widget.wallpaperTheme,
      startDate: startDate,
      endDate: endDate,
      label: _goalCtrl.text,
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
                              maxValue: 2099,
                              minValue: 1900,
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
                              maxValue: 12,
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
                              maxValue: _startMaxDay,
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
                              maxValue: 2099,
                              minValue: 1900,
                              palette: palette,
                              onChanged: (_) {
                                setState(() {});
                                _checkDateOrder();
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DateInputField(
                              controller: _deadlineMonthCtrl,
                              hint: 'MM',
                              label: 'Month',
                              maxLength: 2,
                              maxValue: 12,
                              palette: palette,
                              onChanged: (_) {
                                setState(() {});
                                _checkDateOrder();
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DateInputField(
                              controller: _deadlineDayCtrl,
                              hint: 'DD',
                              label: 'Day',
                              maxLength: 2,
                              maxValue: _deadlineMaxDay,
                              palette: palette,
                              onChanged: (_) {
                                setState(() {});
                                _checkDateOrder();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Inline date order error
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  child: _dateOrderError
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8, left: 4),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline_rounded,
                                  color: Colors.redAccent, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                'Start date must be earlier than the deadline.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
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
