import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import '../models/wallpaper_config.dart';
import 'life_customize_screen.dart';
import 'year_customize_screen.dart';
import 'goal_customize_screen.dart';
import 'product_launch_customize_screen.dart';
import 'fitness_goal_customize_screen.dart';

class ThemeSelectionScreen extends StatelessWidget {
  const ThemeSelectionScreen({super.key, required this.calendarType});

  final CalendarType calendarType;

  String get _calendarLabel {
    switch (calendarType) {
      case CalendarType.life:
        return 'Life Calendar';
      case CalendarType.year:
        return 'Year Calendar';
      case CalendarType.goal:
        return 'Goal Calendar';
      case CalendarType.productLaunch:
        return 'Product Launch';
      case CalendarType.fitnessGoal:
        return 'Fitness Goal';
    }
  }

  void _onThemeSelected(BuildContext context, WallpaperTheme theme) {
    Widget screen;
    switch (calendarType) {
      case CalendarType.life:
        screen = LifeCustomizeScreen(wallpaperTheme: theme);
      case CalendarType.year:
        screen = YearCustomizeScreen(wallpaperTheme: theme);
      case CalendarType.goal:
        screen = GoalCustomizeScreen(wallpaperTheme: theme);
      case CalendarType.productLaunch:
        screen = ProductLaunchCustomizeScreen(wallpaperTheme: theme);
      case CalendarType.fitnessGoal:
        screen = FitnessGoalCustomizeScreen(wallpaperTheme: theme);
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<ThemeProvider>().palette;

    return OrganicBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: palette.textSecondary,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),

                // Breadcrumb
                Row(
                  children: [
                    Text(
                      _calendarLabel,
                      style: TextStyle(
                        fontSize: 12,
                        color: palette.primaryLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded,
                        size: 16, color: palette.textMuted),
                    Text(
                      'Choose Style',
                      style: TextStyle(
                        fontSize: 12,
                        color: palette.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  'Pick a Style',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: palette.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Choose how your wallpaper will look.',
                  style: TextStyle(fontSize: 14, color: palette.textMuted),
                ),

                const SizedBox(height: 36),

                Text(
                  'VISUAL STYLE',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.5,
                    color: palette.primaryLight.withValues(alpha: 0.7),
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: _ThemeCard(
                        label: 'The Flow',
                        description:
                            'Organic river path showing your journey',
                        palette: palette,
                        onTap: () =>
                            _onThemeSelected(context, WallpaperTheme.flow),
                        previewChild: _FlowPreview(palette: palette),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _ThemeCard(
                        label: 'Dots',
                        description:
                            'Grid of dots marking each unit of time',
                        palette: palette,
                        onTap: () =>
                            _onThemeSelected(context, WallpaperTheme.dots),
                        previewChild: _DotsPreview(palette: palette),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Theme Card ─────────────────────────────────────────────────
class _ThemeCard extends StatelessWidget {
  const _ThemeCard({
    required this.label,
    required this.description,
    required this.palette,
    required this.onTap,
    required this.previewChild,
  });

  final String label;
  final String description;
  final AppColorPalette palette;
  final VoidCallback onTap;
  final Widget previewChild;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 24,
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          splashColor: palette.primary.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Preview area
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    child: previewChild,
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: palette.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
                    color: palette.textMuted,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Text(
                      'Select',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: palette.primaryLight,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded,
                        size: 14, color: palette.primaryLight),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Flow Preview ───────────────────────────────────────────────
class _FlowPreview extends StatelessWidget {
  const _FlowPreview({required this.palette});

  final AppColorPalette palette;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _FlowPreviewPainter(palette: palette));
}

class _FlowPreviewPainter extends CustomPainter {
  const _FlowPreviewPainter({required this.palette});

  final AppColorPalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path()
      ..moveTo(w * 0.5, h * 0.95)
      ..cubicTo(w * 0.3, h * 0.75, w * 0.7, h * 0.60, w * 0.5, h * 0.45)
      ..cubicTo(w * 0.3, h * 0.30, w * 0.65, h * 0.15, w * 0.5, h * 0.05);

    canvas.drawPath(
      path,
      Paint()
        ..color = palette.primaryLight.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: palette.vineGradient,
        ).createShader(Rect.fromLTWH(0, 0, w, h))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );

    final metrics = path.computeMetrics().first;
    final halfway = metrics.getTangentForOffset(metrics.length * 0.5);
    if (halfway != null) {
      canvas.drawCircle(
        halfway.position,
        9,
        Paint()
          ..color = palette.primaryLight.withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
      canvas.drawCircle(
          halfway.position, 5, Paint()..color = palette.primaryLight);
    }
  }

  @override
  bool shouldRepaint(covariant _FlowPreviewPainter old) => false;
}

// ── Dots Preview ───────────────────────────────────────────────
class _DotsPreview extends StatelessWidget {
  const _DotsPreview({required this.palette});

  final AppColorPalette palette;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _DotsPreviewPainter(palette: palette));
}

class _DotsPreviewPainter extends CustomPainter {
  const _DotsPreviewPainter({required this.palette});

  final AppColorPalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    const cols = 16;
    const rows = 8;
    const filled = 28;
    final dotR = size.width / (cols * 2.8);
    final spacingX = size.width / cols;
    final spacingY = size.height / rows;
    int count = 0;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final cx = spacingX * c + spacingX * 0.5;
        final cy = spacingY * r + spacingY * 0.5;
        count++;
        if (count <= filled) {
          if (count == filled) {
            canvas.drawCircle(
              Offset(cx, cy),
              dotR + 3,
              Paint()
                ..color = palette.primaryLight.withValues(alpha: 0.4)
                ..maskFilter =
                    const MaskFilter.blur(BlurStyle.normal, 4),
            );
          }
          canvas.drawCircle(
            Offset(cx, cy),
            dotR,
            Paint()
              ..color = count == filled
                  ? palette.primaryLight
                  : palette.primary.withValues(alpha: 0.8),
          );
        } else {
          canvas.drawCircle(
            Offset(cx, cy),
            dotR,
            Paint()..color = Colors.white.withValues(alpha: 0.07),
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotsPreviewPainter old) => false;
}
