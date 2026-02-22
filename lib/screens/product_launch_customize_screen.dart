import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/customize_shared_widgets.dart';
import '../models/wallpaper_config.dart';
import 'wallpaper_preview_screen.dart';

class ProductLaunchCustomizeScreen extends StatefulWidget {
  const ProductLaunchCustomizeScreen({
    super.key,
    required this.wallpaperTheme,
    this.initialData,
  });

  final WallpaperTheme wallpaperTheme;
  final WallpaperData? initialData;

  @override
  State<ProductLaunchCustomizeScreen> createState() =>
      _ProductLaunchCustomizeScreenState();
}

class _ProductLaunchCustomizeScreenState
    extends State<ProductLaunchCustomizeScreen> {
  final _productCtrl = TextEditingController();

  // Countdown start date
  final _startYearCtrl = TextEditingController();
  final _startMonthCtrl = TextEditingController();
  final _startDayCtrl = TextEditingController();

  // Launch date
  final _launchYearCtrl = TextEditingController();
  final _launchMonthCtrl = TextEditingController();
  final _launchDayCtrl = TextEditingController();

  // Validation
  bool _dateOrderError = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      final data = widget.initialData!;
      _productCtrl.text = data.label ?? '';

      _startDayCtrl.text = data.startDate.day.toString().padLeft(2, '0');
      _startMonthCtrl.text = data.startDate.month.toString().padLeft(2, '0');
      _startYearCtrl.text = data.startDate.year.toString();

      _launchDayCtrl.text = data.endDate.day.toString().padLeft(2, '0');
      _launchMonthCtrl.text = data.endDate.month.toString().padLeft(2, '0');
      _launchYearCtrl.text = data.endDate.year.toString();
    }
  }

  @override
  void dispose() {
    _productCtrl.dispose();
    _startYearCtrl.dispose();
    _startMonthCtrl.dispose();
    _startDayCtrl.dispose();
    _launchYearCtrl.dispose();
    _launchMonthCtrl.dispose();
    _launchDayCtrl.dispose();
    super.dispose();
  }

  bool get _isComplete =>
      _productCtrl.text.trim().isNotEmpty &&
      _startYearCtrl.text.length == 4 &&
      _startMonthCtrl.text.length == 2 &&
      _startDayCtrl.text.length == 2 &&
      _launchYearCtrl.text.length == 4 &&
      _launchMonthCtrl.text.length == 2 &&
      _launchDayCtrl.text.length == 2;

  int get _startMaxDay {
    final y = int.tryParse(_startYearCtrl.text) ?? DateTime.now().year;
    final m = (int.tryParse(_startMonthCtrl.text) ?? 1).clamp(1, 12);
    return DateTime(y, m + 1, 0).day;
  }

  int get _launchMaxDay {
    final y = int.tryParse(_launchYearCtrl.text) ?? DateTime.now().year;
    final m = (int.tryParse(_launchMonthCtrl.text) ?? 1).clamp(1, 12);
    return DateTime(y, m + 1, 0).day;
  }

  void _checkDateOrder() {
    if (!_isComplete) return;
    final start = DateTime(
      int.parse(_startYearCtrl.text),
      int.parse(_startMonthCtrl.text),
      int.parse(_startDayCtrl.text),
    );
    final end = DateTime(
      int.parse(_launchYearCtrl.text),
      int.parse(_launchMonthCtrl.text),
      int.parse(_launchDayCtrl.text),
    );
    setState(() => _dateOrderError = !start.isBefore(end));
  }

  void _generate(AppColorPalette palette) {
    if (!_isComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: palette.cardBackground,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Text('Please fill in all fields.',
              style: TextStyle(color: palette.textSecondary)),
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
      int.parse(_launchYearCtrl.text),
      int.parse(_launchMonthCtrl.text),
      int.parse(_launchDayCtrl.text),
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
                  'Start date must be earlier than the launch date.',
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
      calendarType: CalendarType.productLaunch,
      wallpaperTheme: widget.wallpaperTheme,
      startDate: startDate,
      endDate: endDate,
      label: _productCtrl.text,
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
                  parts: ['Product Launch', themeLabel, 'Customize'],
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

                // ── Product name ──────────────────────────────
                GlassCard(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CardSectionHeader(
                        icon: Icons.rocket_launch_rounded,
                        title: 'Product',
                        palette: palette,
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.only(left: 48),
                        child: Text(
                          'E.g., App v2.0, Album Drop, Store Opening',
                          style: TextStyle(
                            fontSize: 12,
                            color: palette.textMuted,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _SimpleTextField(
                        controller: _productCtrl,
                        hint: 'Enter product or project name…',
                        palette: palette,
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ── Countdown start date ───────────────────────
                GlassCard(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CardSectionHeader(
                        icon: Icons.hourglass_top_rounded,
                        title: 'Countdown Start',
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

                // ── Launch date ───────────────────────────────
                GlassCard(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CardSectionHeader(
                        icon: Icons.event_rounded,
                        title: 'Launch Date',
                        palette: palette,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: DateInputField(
                              controller: _launchYearCtrl,
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
                              controller: _launchMonthCtrl,
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
                              controller: _launchDayCtrl,
                              hint: 'DD',
                              label: 'Day',
                              maxLength: 2,
                              maxValue: _launchMaxDay,
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
                                'Start date must be earlier than the launch date.',
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

class _SimpleTextField extends StatelessWidget {
  const _SimpleTextField({
    required this.controller,
    required this.hint,
    required this.palette,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final AppColorPalette palette;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: 15,
          color: palette.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              fontSize: 14,
              color: palette.textMuted,
              fontWeight: FontWeight.w400),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      ),
    );
  }
}
