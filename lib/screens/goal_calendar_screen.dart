import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import '../models/wallpaper_config.dart';
import '../providers/wallpaper_provider.dart';
import 'wallpaper_type_screen.dart';

/// Countdown view for the user's goal-type calendars (goal, product launch,
/// fitness). Shows the active wallpaper if it's a goal type, otherwise the
/// most recently saved one; falls back to a composed empty state.
class GoalCalendarScreen extends StatelessWidget {
  const GoalCalendarScreen({super.key});

  /// The goal-type calendar to display, or null if none exists.
  WallpaperData? _pickGoal(WallpaperProvider provider) {
    const goalTypes = {
      CalendarType.goal,
      CalendarType.productLaunch,
      CalendarType.fitnessGoal,
    };
    final active = provider.activeWallpaper;
    if (active != null && goalTypes.contains(active.calendarType)) {
      return active;
    }
    for (final w in provider.savedWallpapers) {
      if (goalTypes.contains(w.calendarType)) return w;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<ThemeProvider>().palette;
    final provider = context.watch<WallpaperProvider>();
    final goal = _pickGoal(provider);

    return OrganicBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: palette.textSecondary,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Goal Calendar',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: palette.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'COUNTDOWN TO DEADLINE',
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

            if (goal == null)
              Expanded(child: _buildEmptyState(palette, context))
            else
              Expanded(
                child: _GoalCountdownView(data: goal, palette: palette),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppColorPalette palette, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flag_rounded,
              size: 64,
              color: palette.textMuted.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            Text(
              'No goal calendar yet',
              style: TextStyle(
                fontSize: 16,
                color: palette.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Set a deadline and watch the countdown.',
              style: TextStyle(
                fontSize: 12,
                color: palette.textMuted.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const WallpaperTypeScreen()),
              ),
              icon: Icon(Icons.add_rounded,
                  color: palette.primaryLight, size: 18),
              label: Text(
                'Create a goal calendar',
                style: TextStyle(
                  color: palette.primaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor:
                    palette.primaryLight.withValues(alpha: 0.1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalCountdownView extends StatelessWidget {
  const _GoalCountdownView({required this.data, required this.palette});

  final WallpaperData data;
  final AppColorPalette palette;

  @override
  Widget build(BuildContext context) {
    final totalDays = data.totalDays;
    final daysPassed = data.elapsedDays;
    final daysRemaining = data.daysLeft;
    final percentage = data.percentElapsed;
    final goalName = data.label ?? 'My Goal';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Countdown card
          GlassCard(
            borderRadius: AppRadius.xl,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$daysRemaining',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w300,
                        color: palette.textPrimary,
                        height: 1,
                        letterSpacing: -2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        daysRemaining == 1 ? ' day' : ' days',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          color: palette.primaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'UNTIL ${goalName.toUpperCase()}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                    color: palette.primaryLight,
                  ),
                ),
                const SizedBox(height: 20),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: daysPassed / totalDays,
                    backgroundColor: Colors.white.withValues(alpha: 0.08),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      palette.primaryLight,
                    ),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$daysPassed of $totalDays days',
                      style: TextStyle(
                        fontSize: 10,
                        color: palette.textMuted,
                      ),
                    ),
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: palette.primaryLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Dot grid
          SizedBox(
            height: 360,
            child: GlassCard(
              borderRadius: AppRadius.xl,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PROGRESS MAP',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          color: palette.textMuted,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          color: palette.primary.withValues(alpha: 0.2),
                        ),
                        child: Text(
                          goalName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: palette.primaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          const dotSize = 8.0;
                          const spacing = 3.0;
                          return Wrap(
                            spacing: spacing,
                            runSpacing: spacing,
                            children:
                                List.generate(totalDays, (index) {
                              final isCompleted = index < daysPassed;
                              final isToday = index == daysPassed - 1;
                              return Container(
                                width: dotSize,
                                height: dotSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isToday
                                      ? palette.accent
                                      : isCompleted
                                          ? palette.primaryLight
                                          : Colors.white
                                              .withValues(alpha: 0.08),
                                  boxShadow: isToday
                                      ? [
                                          BoxShadow(
                                            color: palette.accent
                                                .withValues(alpha: 0.6),
                                            blurRadius: 8,
                                          ),
                                        ]
                                      : isCompleted
                                          ? [
                                              BoxShadow(
                                                color: palette
                                                            .primaryLight
                                                    .withValues(alpha: 0.2),
                                                blurRadius: 3,
                                              ),
                                            ]
                                          : null,
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
