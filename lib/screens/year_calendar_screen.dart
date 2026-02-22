import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';

class YearCalendarScreen extends StatefulWidget {
  const YearCalendarScreen({super.key});

  @override
  State<YearCalendarScreen> createState() => _YearCalendarScreenState();
}

class _YearCalendarScreenState extends State<YearCalendarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int get _totalDaysInYear {
    final year = DateTime.now().year;
    return DateTime(year, 12, 31).difference(DateTime(year, 1, 1)).inDays + 1;
  }

  int get _daysPassed {
    final now = DateTime.now();
    return now.difference(DateTime(now.year, 1, 1)).inDays + 1;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<ThemeProvider>().palette;
    final percentage = ((_daysPassed / _totalDaysInYear) * 100).round();

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
                  Row(
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
                            'Year Calendar',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: palette.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${DateTime.now().year} PROGRESS',
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
                    _buildStat('Completed', '$_daysPassed', palette),
                    Container(
                      width: 1,
                      height: 32,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    _buildStat('Remaining', '${_totalDaysInYear - _daysPassed}', palette),
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

            // Tab bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: palette.primary.withValues(alpha: 0.3),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: palette.primaryLight,
                  unselectedLabelColor: palette.textMuted,
                  labelStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.5,
                  ),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'DAYS'),
                    Tab(text: 'MONTHS'),
                    Tab(text: 'QUARTERS'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tab views
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GlassCard(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(16),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildDaysView(palette),
                      _buildMonthsView(palette),
                      _buildQuartersView(palette),
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

  Widget _buildDaysView(dynamic palette) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ALL DAYS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              color: palette.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              const dotSize = 7.0;
              const spacing = 3.0;
              return FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: List.generate(_totalDaysInYear, (index) {
                      final isCompleted = index < _daysPassed;
                      return Container(
                        width: dotSize,
                        height: dotSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted
                              ? palette.primaryLight
                              : Colors.white.withValues(alpha: 0.08),
                          boxShadow: isCompleted
                              ? [
                                  BoxShadow(
                                    color: (palette.primaryLight)
                                        .withValues(alpha: 0.25),
                                    blurRadius: 3,
                                  ),
                                ]
                              : null,
                        ),
                      );
                    }),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMonthsView(dynamic palette) {
    final year = DateTime.now().year;
    final monthNames = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(12, (monthIndex) {
          final daysInMonth = DateTime(year, monthIndex + 2, 0).day;
          final startOfMonth = DateTime(year, monthIndex + 1, 1);
          final dayOfYearStart = startOfMonth.difference(DateTime(year, 1, 1)).inDays;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      monthNames[monthIndex],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: palette.textMuted,
                      ),
                    ),
                    Text(
                      '$daysInMonth days',
                      style: TextStyle(
                        fontSize: 9,
                        color: palette.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LayoutBuilder(builder: (context, constraints) {
                  return FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: constraints.maxWidth,
                      child: Wrap(
                        spacing: 3,
                        runSpacing: 3,
                        children: List.generate(daysInMonth, (dayIndex) {
                          final dayOfYear = dayOfYearStart + dayIndex;
                          final isCompleted = dayOfYear < _daysPassed;
                          return Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCompleted
                                  ? palette.primaryLight
                                  : Colors.white.withValues(alpha: 0.08),
                              boxShadow: isCompleted
                                  ? [
                                      BoxShadow(
                                        color: (palette.primaryLight as Color)
                                            .withValues(alpha: 0.25),
                                        blurRadius: 3,
                                      ),
                                    ]
                                  : null,
                            ),
                          );
                        }),
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildQuartersView(dynamic palette) {
    final year = DateTime.now().year;
    final quarterMonths = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
      [10, 11, 12],
    ];
    final quarterNames = ['Q1', 'Q2', 'Q3', 'Q4'];
    final monthNames = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(4, (qIndex) {
          final months = quarterMonths[qIndex];
          int totalQuarterDays = 0;
          int completedQuarterDays = 0;

          for (final month in months) {
            final daysInMonth = DateTime(year, month + 1, 0).day;
            totalQuarterDays += daysInMonth;
            final startOfMonth = DateTime(year, month, 1);
            final dayOfYearStart = startOfMonth.difference(DateTime(year, 1, 1)).inDays;
            for (int d = 0; d < daysInMonth; d++) {
              if (dayOfYearStart + d < _daysPassed) {
                completedQuarterDays++;
              }
            }
          }

          final qPercent = ((completedQuarterDays / totalQuarterDays) * 100).round();

          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${quarterNames[qIndex]} — ${monthNames[months.first]}–${monthNames[months.last]}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: palette.textSecondary,
                      ),
                    ),
                    Text(
                      '$qPercent%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: palette.primaryLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...months.map((month) {
                  final daysInMonth = DateTime(year, month + 1, 0).day;
                  final startOfMonth = DateTime(year, month, 1);
                  final dayOfYearStart = startOfMonth.difference(DateTime(year, 1, 1)).inDays;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 28,
                          child: Text(
                            monthNames[month].substring(0, 1),
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: palette.textMuted,
                            ),
                          ),
                        ),
                        Expanded(
                          child: LayoutBuilder(builder: (context, constraints) {
                            return FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                width: constraints.maxWidth,
                                child: Wrap(
                                  spacing: 2.5,
                                  runSpacing: 2.5,
                                  children: List.generate(daysInMonth, (dayIndex) {
                                    final dayOfYear = dayOfYearStart + dayIndex;
                                    final isCompleted = dayOfYear < _daysPassed;
                                    return Container(
                                      width: 7,
                                      height: 7,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isCompleted
                                            ? palette.primaryLight
                                            : Colors.white.withValues(alpha: 0.08),
                                        boxShadow: isCompleted
                                            ? [
                                                BoxShadow(
                                                  color: (palette.primaryLight as Color)
                                                      .withValues(alpha: 0.25),
                                                  blurRadius: 3,
                                                ),
                                              ]
                                            : null,
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ),
    );
  }
}
