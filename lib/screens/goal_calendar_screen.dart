import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';

class GoalCalendarScreen extends StatelessWidget {
  const GoalCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<ThemeProvider>().palette;
    final now = DateTime.now();

    // Sample goal
    final goalName = 'Product Launch';
    final goalStart = DateTime(now.year, 1, 1);
    final goalEnd = DateTime(now.year, 12, 31);
    final totalDays = goalEnd.difference(goalStart).inDays + 1;
    final daysPassed = now.difference(goalStart).inDays + 1;
    final daysRemaining = totalDays - daysPassed;
    final percentage = ((daysPassed / totalDays) * 100).round();

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

            // Countdown card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GlassCard(
                borderRadius: 24,
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
                            ' days',
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
                      'UNTIL $goalName'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3,
                        color: palette.accent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
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
                          '$daysPassed completed',
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
            ),

            const SizedBox(height: 16),

            // Dot grid
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
                              borderRadius: BorderRadius.circular(8),
                              color: palette.primary.withValues(alpha: 0.2),
                            ),
                            child: Text(
                              goalName,
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
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
