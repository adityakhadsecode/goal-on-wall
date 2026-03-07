import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import '../services/user_prefs.dart';

class LifeCalendarScreen extends StatefulWidget {
  const LifeCalendarScreen({super.key});

  @override
  State<LifeCalendarScreen> createState() => _LifeCalendarScreenState();
}

class _LifeCalendarScreenState extends State<LifeCalendarScreen> {
  static const int _lifeExpectancy = 80;
  DateTime? _birthDate;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final birth = await UserPrefs.getBirthDate();
    if (mounted) {
      setState(() {
        _birthDate = birth;
        _loaded = true;
      });
    }
  }

  void _showInfoPopup() {
    final palette = context.read<ThemeProvider>().palette;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: palette.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        title: Row(
          children: [
            Icon(Icons.info_outline_rounded, color: palette.primaryLight, size: 22),
            const SizedBox(width: 10),
            Text(
              'Life Calendar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: palette.textPrimary,
              ),
            ),
          ],
        ),
        content: Text(
          'Each dot represents one week of your life.\n\n'
          '● Filled dots are weeks you\'ve already lived.\n'
          '○ Empty dots are weeks remaining.\n\n'
          'This visualization helps you appreciate and make the most of your time.',
          style: TextStyle(
            fontSize: 13,
            color: palette.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Got it',
              style: TextStyle(
                color: palette.primaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<ThemeProvider>().palette;
    final now = DateTime.now();

    final birthDate = _birthDate ?? DateTime(2000, 1, 1);
    final ageInWeeks = now.difference(birthDate).inDays ~/ 7;
    final totalWeeks = _lifeExpectancy * 52;
    final ageInYears = now.difference(birthDate).inDays ~/ 365;
    final daysLived = now.difference(birthDate).inDays;

    if (!_loaded) {
      return OrganicBackground(
        child: Center(
          child: CircularProgressIndicator(color: palette.primaryLight),
        ),
      );
    }

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
                  GestureDetector(
                    onTap: _showInfoPopup,
                    child: Container(
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
                    _buildStat('Days Lived', '$daysLived', palette),
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
    const weeksPerRow = 52;
    final totalYears = _lifeExpectancy;
    // Calculate grid dimensions for the painter
    const double dotSize = 4;
    const double dotMargin = 0.8;
    const double cellSize = dotSize + dotMargin * 2;
    const double labelWidth = 24;
    final double rowHeight = cellSize + 2; // +2 for row padding
    final double totalHeight = totalYears * rowHeight;

    return SizedBox(
      height: totalHeight,
      child: CustomPaint(
        size: Size(double.infinity, totalHeight),
        painter: _LifeGridPainter(
          completedWeeks: completedWeeks,
          totalYears: totalYears,
          weeksPerRow: weeksPerRow,
          dotSize: dotSize,
          cellSize: cellSize,
          labelWidth: labelWidth,
          rowHeight: rowHeight,
          completedColor: palette.primaryLight as Color,
          emptyColor: Colors.white.withValues(alpha: 0.06),
          labelColor: palette.textMuted as Color,
        ),
      ),
    );
  }
}

class _LifeGridPainter extends CustomPainter {
  final int completedWeeks;
  final int totalYears;
  final int weeksPerRow;
  final double dotSize;
  final double cellSize;
  final double labelWidth;
  final double rowHeight;
  final Color completedColor;
  final Color emptyColor;
  final Color labelColor;

  _LifeGridPainter({
    required this.completedWeeks,
    required this.totalYears,
    required this.weeksPerRow,
    required this.dotSize,
    required this.cellSize,
    required this.labelWidth,
    required this.rowHeight,
    required this.completedColor,
    required this.emptyColor,
    required this.labelColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final completedPaint = Paint()..color = completedColor;
    final emptyPaint = Paint()..color = emptyColor;
    final labelStyle = TextStyle(
      fontSize: 7,
      color: labelColor,
      fontWeight: FontWeight.w600,
    );
    final radius = dotSize / 2;
    final gridWidth = size.width - labelWidth;
    final dotSpacing = gridWidth / weeksPerRow;

    for (int yearIndex = 0; yearIndex < totalYears; yearIndex++) {
      final y = yearIndex * rowHeight + cellSize / 2;

      // Year label every 10 years
      if (yearIndex % 10 == 0) {
        final tp = TextPainter(
          text: TextSpan(text: '$yearIndex', style: labelStyle),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(0, y - tp.height / 2));
      }

      for (int weekIndex = 0; weekIndex < weeksPerRow; weekIndex++) {
        final dotIndex = yearIndex * weeksPerRow + weekIndex;
        final isCompleted = dotIndex < completedWeeks;
        final x = labelWidth + weekIndex * dotSpacing + dotSpacing / 2;
        canvas.drawCircle(
          Offset(x, y),
          radius,
          isCompleted ? completedPaint : emptyPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LifeGridPainter old) =>
      old.completedWeeks != completedWeeks ||
      old.totalYears != totalYears ||
      old.completedColor != completedColor;
}
