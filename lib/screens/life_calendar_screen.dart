import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';

class LifeCalendarScreen extends StatelessWidget {
  const LifeCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<ThemeProvider>().palette;
    final now = DateTime.now();

    // Assume birth year for demo — user can configure later
    final birthDate = DateTime(2000, 1, 1);
    final ageInWeeks = now.difference(birthDate).inDays ~/ 7;
    final totalWeeks = 80 * 52; // 80-year lifespan
    final ageInYears = now.difference(birthDate).inDays ~/ 365;
    final percentage = ((ageInWeeks / totalWeeks) * 100).round();

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
                        'Life Calendar',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: palette.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'YOUR LIFE IN WEEKS',
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
                      Icons.info_outline_rounded,
                      color: palette.textSecondary,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Stats row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GlassCard(
                borderRadius: 20,
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat('Age', '$ageInYears yrs', palette),
                    Container(
                      width: 1,
                      height: 32,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    _buildStat('Weeks Lived', '$ageInWeeks', palette),
                    Container(
                      width: 1,
                      height: 32,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    _buildStat('Progress', '$percentage%', palette),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Life grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GlassCard(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'LIFE GRID',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                              color: palette.textMuted,
                            ),
                          ),
                          Text(
                            '1 dot = 1 week',
                            style: TextStyle(
                              fontSize: 10,
                              color: palette.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: SingleChildScrollView(
                          child: _buildLifeGrid(ageInWeeks, totalWeeks, palette),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, dynamic palette) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: palette.primaryLight,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: palette.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildLifeGrid(int completedWeeks, int totalWeeks, dynamic palette) {
    const weeksPerRow = 52; // one row per year
    final totalYears = 80;

    return Column(
      children: List.generate(totalYears, (yearIndex) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Row(
            children: [
              // Year label every 10 years
              SizedBox(
                width: 24,
                child: yearIndex % 10 == 0
                    ? Text(
                        '$yearIndex',
                        style: TextStyle(
                          fontSize: 7,
                          color: palette.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : const SizedBox(),
              ),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(weeksPerRow, (weekIndex) {
                      final dotIndex = yearIndex * weeksPerRow + weekIndex;
                      final isCompleted = dotIndex < completedWeeks;
                      return Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.all(0.8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted
                              ? palette.primaryLight
                              : Colors.white.withValues(alpha: 0.06),
                          boxShadow: isCompleted
                              ? [
                                  BoxShadow(
                                    color: (palette.primaryLight)
                                        .withValues(alpha: 0.2),
                                    blurRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
