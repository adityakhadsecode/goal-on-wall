import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../providers/wallpaper_provider.dart';
import '../models/wallpaper_config.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import 'year_calendar_screen.dart';
import 'goal_calendar_screen.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<ThemeProvider>().palette;

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
                        'Your Calendars',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: palette.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'MANAGE & EDIT',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                          color: palette.textMuted,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.05),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Icon(
                      Icons.search_rounded,
                      color: palette.textSecondary,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Calendar cards
            Expanded(
              child: Consumer<WallpaperProvider>(
                builder: (context, provider, child) {
                  final savedWallpapers = provider.savedWallpapers;
                  
                  if (savedWallpapers.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history_rounded,
                            size: 64,
                            color: palette.textMuted.withValues(alpha: 0.2),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No saved wallpapers yet',
                            style: TextStyle(
                              fontSize: 16,
                              color: palette.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create one to see it here',
                            style: TextStyle(
                              fontSize: 12,
                              color: palette.textMuted.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                    itemCount: savedWallpapers.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final data = savedWallpapers[index];
                      return _buildCalendarCard(
                        context,
                        icon: _getIconForType(data.calendarType),
                        title: data.label ?? _getTitleForType(data.calendarType),
                        subtitle: data.caption,
                        progress: data.progress,
                        palette: palette,
                        onTap: () {
                          // Navigate to preview for that specific data
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getYearProgress() {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear = DateTime(now.year, 12, 31);
    final totalDays = endOfYear.difference(startOfYear).inDays + 1;
    final daysPassed = now.difference(startOfYear).inDays + 1;
    return daysPassed / totalDays;
  }

  IconData _getIconForType(CalendarType type) {
    switch (type) {
      case CalendarType.life: return Icons.grid_view_rounded;
      case CalendarType.year: return Icons.calendar_view_day_rounded;
      case CalendarType.goal: return Icons.flag_rounded;
      case CalendarType.productLaunch: return Icons.rocket_launch_rounded;
      case CalendarType.fitnessGoal: return Icons.fitness_center_rounded;
    }
  }

  String _getTitleForType(CalendarType type) {
    switch (type) {
      case CalendarType.life: return 'Life Calendar';
      case CalendarType.year: return 'Year Calendar';
      case CalendarType.goal: return 'Goal Calendar';
      case CalendarType.productLaunch: return 'Product Launch';
      case CalendarType.fitnessGoal: return 'Fitness Goal';
    }
  }

  Widget _buildCalendarCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required double progress,
    required dynamic palette,
    required VoidCallback onTap,
  }) {
    return GlassCard(
      borderRadius: 20,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: palette.primary.withValues(alpha: 0.2),
                  ),
                  child: Icon(icon, color: palette.primaryLight, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: palette.textMuted,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor:
                              Colors.white.withValues(alpha: 0.08),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            palette.primaryLight,
                          ),
                          minHeight: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    Text(
                      '${(progress * 100).round()}%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: palette.primaryLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  color: palette.textMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
