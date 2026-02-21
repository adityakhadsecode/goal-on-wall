import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
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
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildCalendarCard(
                    context,
                    icon: Icons.calendar_view_day_rounded,
                    title: 'Year Calendar',
                    subtitle: 'Track ${DateTime.now().year} progress',
                    progress: _getYearProgress(),
                    palette: palette,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const YearCalendarScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildCalendarCard(
                    context,
                    icon: Icons.grid_view_rounded,
                    title: 'Life Calendar',
                    subtitle: 'Your life visualized in weeks',
                    progress: 0.33,
                    palette: palette,
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _buildCalendarCard(
                    context,
                    icon: Icons.flag_rounded,
                    title: 'Product Launch',
                    subtitle: 'Goal countdown • 314 days left',
                    progress: 0.14,
                    palette: palette,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GoalCalendarScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildCalendarCard(
                    context,
                    icon: Icons.fitness_center_rounded,
                    title: 'Fitness Goal',
                    subtitle: 'Goal countdown • 180 days left',
                    progress: 0.5,
                    palette: palette,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GoalCalendarScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 100),
                ],
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
