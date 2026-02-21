import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import '../models/wallpaper_config.dart';
import 'theme_selection_screen.dart';

class WallpaperTypeScreen extends StatelessWidget {
  const WallpaperTypeScreen({super.key});

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
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
            children: [
              Text(
                'New Wallpaper',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: palette.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Visualize your life progress or year at a glance.\nUpdated automatically on your lock screen.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: palette.textMuted,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 36),
              Text(
                'CHOOSE TYPE',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.5,
                  color: palette.primaryLight.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 14),
              _TypeCard(
                icon: Icons.grid_view_rounded,
                title: 'Life Calendar',
                subtitle: 'Visualize your life in weeks',
                calendarType: CalendarType.life,
                palette: palette,
              ),
              const SizedBox(height: 12),
              _TypeCard(
                icon: Icons.calendar_view_week_rounded,
                title: 'Year Calendar',
                subtitle: "Track the current year's progress",
                calendarType: CalendarType.year,
                palette: palette,
              ),
              const SizedBox(height: 12),
              _TypeCard(
                icon: Icons.flag_rounded,
                title: 'Goal Calendar',
                subtitle: 'Count down to your deadline',
                calendarType: CalendarType.goal,
                palette: palette,
              ),
              const SizedBox(height: 12),
              _TypeCard(
                icon: Icons.rocket_launch_rounded,
                title: 'Product Launch',
                subtitle: 'Countdown to your big launch day',
                calendarType: CalendarType.productLaunch,
                palette: palette,
              ),
              const SizedBox(height: 12),
              _TypeCard(
                icon: Icons.fitness_center_rounded,
                title: 'Fitness Goal',
                subtitle: 'Track your training journey',
                calendarType: CalendarType.fitnessGoal,
                palette: palette,
              ),
            ],
          ),
        ),

      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.calendarType,
    required this.palette,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final CalendarType calendarType;
  final AppColorPalette palette;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 20,
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ThemeSelectionScreen(calendarType: calendarType),
            ),
          ),
          splashColor: palette.primary.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                // Icon bubble
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        palette.primary.withValues(alpha: 0.3),
                        palette.primaryLight.withValues(alpha: 0.15),
                      ],
                    ),
                    border: Border.all(
                      color: palette.primaryLight.withValues(alpha: 0.15),
                    ),
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
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: palette.textMuted,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Icon(
                  Icons.chevron_right_rounded,
                  color: palette.textMuted.withValues(alpha: 0.5),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
