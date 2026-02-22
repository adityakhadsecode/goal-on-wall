import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import 'wallpaper_type_screen.dart';
import '../services/wallpaper_storage.dart';
import '../models/wallpaper_config.dart';
import 'life_customize_screen.dart';
import 'year_customize_screen.dart';
import 'goal_customize_screen.dart';
import 'product_launch_customize_screen.dart';
import 'fitness_goal_customize_screen.dart';
import 'analytics_screen.dart';
import '../providers/wallpaper_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _riverController;
  late AnimationController _insightFadeController;
  int _insightIndex = 0;

  static const List<String> _insights = [
    '✦  Every day is a brushstroke on your canvas.',
    '✦  Small steps today, towering peaks tomorrow.',
    '✦  You are further than you were yesterday.',
    '✦  Growth is quiet — but relentless.',
    '✦  The river never stops. Neither do you.',
    '✦  Let today add another ring to your tree.',
  ];

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _riverController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _insightFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _scheduleInsightCycle();
  }

  void _scheduleInsightCycle() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      _insightFadeController.reverse().then((_) {
        if (!mounted) return;
        setState(() {
          _insightIndex = (_insightIndex + 1) % _insights.length;
        });
        _insightFadeController.forward();
        _scheduleInsightCycle();
      });
    });
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _riverController.dispose();
    _insightFadeController.dispose();
    super.dispose();
  }

  // ── Year progress ──────────────────────────────────────────
  double get _yearProgress {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear = DateTime(now.year, 12, 31);
    final totalDays = endOfYear.difference(startOfYear).inDays + 1;
    final daysPassed = now.difference(startOfYear).inDays + 1;
    return daysPassed / totalDays;
  }

  int get _daysPassed {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    return now.difference(startOfYear).inDays + 1;
  }

  int get _daysRemaining {
    final now = DateTime.now();
    final endOfYear = DateTime(now.year, 12, 31);
    return endOfYear.difference(now).inDays;
  }

  // ── Week progress (Mon=1 … Sun=7) ─────────────────────────
  double get _weekProgress => DateTime.now().weekday / 7.0;

  // ── Day progress ──────────────────────────────────────────
  double get _dayProgress {
    final now = DateTime.now();
    return (now.hour * 60 + now.minute) / (24 * 60);
  }

  String _pct(double v) => '${(v * 100).round()}%';

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<ThemeProvider>().palette;
    final wpProvider = context.watch<WallpaperProvider>();
    final activeWp = wpProvider.activeWallpaper;
    final size = MediaQuery.of(context).size;

    // Use active wallpaper data if available, otherwise fallback to local Year progress
    final double progress = activeWp?.percentElapsed.toDouble() ?? (_yearProgress * 100);
    final int progressPct = progress.round();
    final int elapsedDaysValue = activeWp?.elapsedDays ?? _daysPassed;
    final int daysRemainingValue = activeWp?.daysLeft ?? _daysRemaining;
    final double progressFactor = (activeWp != null) 
      ? (activeWp.percentElapsed / 100.0) 
      : _yearProgress;

    return OrganicBackground(
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 110),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // ── GREETING ─────────────────────────────────
                _GreetingHeader(
                  palette: palette,
                  floatController: _floatingController,
                ),

                const SizedBox(height: 28),

                // ── ACTIVE WALLPAPER CARD ─────────────────────
                _WallpaperPreviewCard(
                  palette: palette,
                  yearProgress: progressFactor,
                  yearPct: progressPct,
                  daysPassed: elapsedDaysValue,
                  floatController: _floatingController,
                  riverController: _riverController,
                  cardHeight: size.height * 0.40,
                ),

                const SizedBox(height: 20),

                // ── ACTION BUTTONS ────────────────────────────
                _ActionButtons(palette: palette),

                const SizedBox(height: 20),

                // ── MY GOAL PROGRESS ──────────────────────────
                _MyGoalProgress(
                  palette: palette,
                  progressPct: progressPct,
                  progressFactor: progressFactor,
                  daysPassed: elapsedDaysValue,
                  daysRemaining: daysRemainingValue,
                  insightText: _insights[_insightIndex],
                  insightFade: _insightFadeController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// GREETING HEADER
// ══════════════════════════════════════════════════════════════
class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader({
    required this.palette,
    required this.floatController,
  });

  final dynamic palette;
  final AnimationController floatController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: floatController,
          builder: (context, child) {
            final dy = sin(floatController.value * 2 * pi) * 1.5;
            return Transform.translate(
              offset: Offset(0, dy),
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    palette.textPrimary as Color,
                    palette.primaryLight as Color,
                  ],
                  stops: const [0.55, 1.0],
                ).createShader(bounds),
                blendMode: BlendMode.srcIn,
                child: const Text(
                  'Hii Aditya 👋',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    height: 1.1,
                    color: Colors.white, // shaderMask overrides color
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 6),
        Text(
          "Let's grow today.",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: (palette.primaryLight as Color).withValues(alpha: 0.65),
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ACTIVE WALLPAPER PREVIEW CARD
// ══════════════════════════════════════════════════════════════
class _WallpaperPreviewCard extends StatelessWidget {
  const _WallpaperPreviewCard({
    required this.palette,
    required this.yearProgress,
    required this.yearPct,
    required this.daysPassed,
    required this.floatController,
    required this.riverController,
    required this.cardHeight,
  });

  final dynamic palette;
  final double yearProgress;
  final int yearPct;
  final int daysPassed;
  final AnimationController floatController;
  final AnimationController riverController;
  final double cardHeight;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 40,
      blurAmount: 14,
      child: SizedBox(
        height: cardHeight,
        child: Stack(
          children: [
            // River flow background painter
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: AnimatedBuilder(
                  animation: riverController,
                  builder: (context, child) => CustomPaint(
                    painter: RiverFlowPainter(
                      progress: yearProgress,
                      animValue: riverController.value,
                      palette: palette,
                    ),
                  ),
                ),
              ),
            ),

            // "ACTIVE WALLPAPER" label top-left
            Positioned(
              top: 22,
              left: 26,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: (palette.primaryLight as Color)
                        .withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: floatController,
                      builder: (context, child) {
                        final pulse =
                            0.5 + 0.5 * sin(floatController.value * 2 * pi);
                        return Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: palette.primaryLight as Color,
                            boxShadow: [
                              BoxShadow(
                                color: (palette.primaryLight as Color)
                                    .withValues(alpha: 0.3 + 0.4 * pulse),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'ACTIVE WALLPAPER',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.8,
                        color: palette.primaryLight as Color,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Overlay stats — bottom section
            Positioned(
              left: 26,
              right: 26,
              bottom: 26,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Big percentage
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$yearPct',
                        style: TextStyle(
                          fontSize: 68,
                          fontWeight: FontWeight.w200,
                          color: palette.textPrimary as Color,
                          height: 1,
                          letterSpacing: -3,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          '%',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w300,
                            color: palette.primaryLight as Color,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Days passed badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: (palette.accent as Color)
                                .withValues(alpha: 0.25),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '$daysPassed',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: palette.accent as Color,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'DAYS\nPASSED',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 7,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                                color: palette.textMuted as Color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Thin progress line
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: yearProgress,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: palette.vineGradient as List<Color>,
                            ),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: (palette.primaryLight as Color)
                                    .withValues(alpha: 0.6),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ACTION BUTTONS
// ══════════════════════════════════════════════════════════════
class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.palette});

  final dynamic palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _GradientButton(
          label: 'Create New Wallpaper',
          icon: Icons.add_circle_outline_rounded,
          palette: palette,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const WallpaperTypeScreen(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _GlassButton(
          label: 'Customize Current Wallpaper',
          icon: Icons.tune_rounded,
          palette: palette,
          onTap: () async {
            final savedConfig = await WallpaperStorage.load();
            if (savedConfig == null) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No active wallpaper found.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
              return;
            }
            if (!context.mounted) return;

            final data = savedConfig.data;
            Widget screen;
            switch (data.calendarType) {
              case CalendarType.life:
                screen = LifeCustomizeScreen(
                    wallpaperTheme: data.wallpaperTheme, initialData: data);
                break;
              case CalendarType.year:
                screen = YearCustomizeScreen(
                    wallpaperTheme: data.wallpaperTheme, initialData: data);
                break;
              case CalendarType.goal:
                screen = GoalCustomizeScreen(
                    wallpaperTheme: data.wallpaperTheme, initialData: data);
                break;
              case CalendarType.productLaunch:
                screen = ProductLaunchCustomizeScreen(
                    wallpaperTheme: data.wallpaperTheme, initialData: data);
                break;
              case CalendarType.fitnessGoal:
                screen = FitnessGoalCustomizeScreen(
                    wallpaperTheme: data.wallpaperTheme, initialData: data);
                break;
            }
            Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
          },
        ),
        const SizedBox(height: 12),
        _GlassButton(
          label: 'View Current Progress',
          icon: Icons.bar_chart_rounded,
          palette: palette,
          onTap: () async {
            final savedConfig = await WallpaperStorage.load();
            if (savedConfig != null && context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AnalyticsScreen(data: savedConfig.data)),
              );
            } else if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No active wallpaper found.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.icon,
    required this.palette,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final dynamic palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            palette.primary as Color,
            palette.primaryLight as Color,
            palette.accent as Color,
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: (palette.primaryLight as Color).withValues(alpha: 0.30),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: (palette.accent as Color).withValues(alpha: 0.15),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          splashColor: Colors.white.withValues(alpha: 0.08),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  const _GlassButton({
    required this.label,
    required this.icon,
    required this.palette,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final dynamic palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withValues(alpha: 0.04),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          splashColor: (palette.primary as Color).withValues(alpha: 0.08),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: palette.textSecondary as Color, size: 18),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: palette.textSecondary as Color,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// MY GOAL PROGRESS PANEL
// ══════════════════════════════════════════════════════════════
class _MyGoalProgress extends StatelessWidget {
  const _MyGoalProgress({
    required this.palette,
    required this.progressPct,
    required this.progressFactor,
    required this.daysPassed,
    required this.daysRemaining,
    required this.insightText,
    required this.insightFade,
  });

  final dynamic palette;
  final int progressPct;
  final double progressFactor;
  final int daysPassed;
  final int daysRemaining;
  final String insightText;
  final AnimationController insightFade;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 28,
      blurAmount: 12,
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Icon(
                Icons.grid_view_rounded,
                size: 14,
                color: (palette.primaryLight as Color).withValues(alpha: 0.7),
              ),
              const SizedBox(width: 7),
              Text(
                'MY GOAL PROGRESS',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.5,
                  color:
                      (palette.primaryLight as Color).withValues(alpha: 0.7),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Stats row
          Row(
            children: [
              Expanded(
                child: _SnapshotStat(
                  label: 'COMPLETE',
                  value: '$progressPct%',
                  progress: progressFactor,
                  accent: palette.primaryLight as Color,
                  palette: palette,
                ),
              ),
              _SnapDivider(),
              Expanded(
                child: _SnapshotStat(
                  label: 'PASSED',
                  value: '$daysPassed',
                  progress: 1.0, // Fixed full since it's just a count
                  accent: palette.accent as Color,
                  palette: palette,
                ),
              ),
              _SnapDivider(),
              Expanded(
                child: _SnapshotDaysRemaining(
                  days: daysRemaining,
                  palette: palette,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Horizontal divider
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white.withValues(alpha: 0.07),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Rotating insight
          FadeTransition(
            opacity: insightFade,
            child: Text(
              insightText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: palette.textMuted as Color,
                letterSpacing: 0.3,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SnapDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 50,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Color(0x11FFFFFF),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class _SnapshotStat extends StatelessWidget {
  const _SnapshotStat({
    required this.label,
    required this.value,
    required this.progress,
    required this.accent,
    required this.palette,
  });

  final String label;
  final String value;
  final double progress;
  final Color accent;
  final dynamic palette;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              color: palette.textMuted as Color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: accent,
              height: 1,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SnapshotDaysRemaining extends StatelessWidget {
  const _SnapshotDaysRemaining({required this.days, required this.palette});

  final int days;
  final dynamic palette;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Text(
            'REMAINING',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              color: palette.textMuted as Color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$days',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: palette.textSecondary as Color,
              height: 1,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'days left',
            style: TextStyle(
              fontSize: 9,
              color: palette.textMuted as Color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// RIVER FLOW PAINTER  (background of wallpaper preview card)
// ══════════════════════════════════════════════════════════════
class RiverFlowPainter extends CustomPainter {
  final double progress;
  final double animValue;
  final dynamic palette;

  const RiverFlowPainter({
    required this.progress,
    required this.animValue,
    required this.palette,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Depth gradient overlay
    final bgPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.3, -0.5),
        radius: 1.1,
        colors: [
          (palette.surfaceColor as Color).withValues(alpha: 0.25),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // River path
    final riverPath = Path();
    riverPath.moveTo(w * 0.5, h * 0.98);
    riverPath.cubicTo(
      w * 0.38, h * 0.82,
      w * 0.68, h * 0.70,
      w * 0.5, h * 0.52,
    );
    riverPath.cubicTo(
      w * 0.30, h * 0.35,
      w * 0.65, h * 0.20,
      w * 0.5, h * 0.02,
    );

    final metrics = riverPath.computeMetrics().first;
    final totalLen = metrics.length;
    final completedLen = progress.clamp(0.0, 1.0);

    // Dashed future path
    _drawDashed(
      canvas,
      riverPath,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.06)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
      8,
      10,
    );

    // Completed path
    final completedPath =
        metrics.extractPath(totalLen * (1 - completedLen), totalLen);

    // Glow
    canvas.drawPath(
      completedPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: (palette.vineGradient as List<Color>)
              .map((c) => c.withValues(alpha: 0.35))
              .toList(),
        ).createShader(Rect.fromLTWH(0, 0, w, h))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 22
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
    );

    // Core line
    canvas.drawPath(
      completedPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: palette.vineGradient as List<Color>,
        ).createShader(Rect.fromLTWH(0, 0, w, h))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );

    // Animated shimmer dots
    for (int i = 0; i < 5; i++) {
      final t = (animValue + i / 5.0) % 1.0;
      final offsetLen =
          totalLen * (1 - completedLen) + t * totalLen * completedLen;
      final tan =
          metrics.getTangentForOffset(offsetLen.clamp(0.0, totalLen));
      if (tan != null) {
        canvas.drawCircle(
          tan.position,
          2.5,
          Paint()
            ..color = Colors.white.withValues(alpha: 0.40)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        );
      }
    }

    // Leading glow dot
    final leadOffset =
        (totalLen * (1 - completedLen)).clamp(0.0, totalLen);
    final leading = metrics.getTangentForOffset(leadOffset);
    if (leading != null) {
      final pulse = 0.5 + 0.5 * sin(animValue * 2 * pi);
      canvas.drawCircle(
        leading.position,
        14,
        Paint()
          ..color = (palette.primaryLight as Color)
              .withValues(alpha: 0.25 * pulse)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
      );
      canvas.drawCircle(
        leading.position,
        6,
        Paint()..color = palette.primaryLight as Color,
      );
      canvas.drawCircle(
        leading.position,
        2.5,
        Paint()..color = Colors.white.withValues(alpha: 0.6),
      );
    }

    // Milestone amber dot
    final amberTan = metrics.getTangentForOffset(totalLen * 0.85);
    if (amberTan != null) {
      canvas.drawCircle(
        amberTan.position,
        4,
        Paint()..color = palette.accent as Color,
      );
      canvas.drawCircle(
        amberTan.position,
        9,
        Paint()
          ..color = (palette.accent as Color).withValues(alpha: 0.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );
    }
  }

  void _drawDashed(
    Canvas canvas,
    Path path,
    Paint paint,
    double dash,
    double gap,
  ) {
    for (final m in path.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        final end = (d + dash).clamp(0.0, m.length);
        canvas.drawPath(m.extractPath(d, end), paint);
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant RiverFlowPainter old) =>
      old.animValue != animValue || old.progress != progress;
}
