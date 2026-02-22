import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/wallpaper_config.dart';
import '../theme/theme_provider.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key, required this.data});

  final WallpaperData data;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<ThemeProvider>().palette;
    final theme = Theme.of(context);

    return OrganicBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: palette.textSecondary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Goal Analytics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── HEADER SECTION ──────────────────────────────
                _AnalyticsHeader(data: data, palette: palette),

                const SizedBox(height: 32),

                // ── PROGRESS SECTION ────────────────────────────
                _ProgressCard(data: data, palette: palette),

                const SizedBox(height: 24),

                // ── METRICS GRID ────────────────────────────────
                _MetricsGrid(data: data, palette: palette),

                const SizedBox(height: 24),

                // ── TIMELINE CARD ───────────────────────────────
                _TimelineCard(data: data, palette: palette),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AnalyticsHeader extends StatelessWidget {
  const _AnalyticsHeader({required this.data, required this.palette});
  final WallpaperData data;
  final dynamic palette;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (palette.primaryLight as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: (palette.primaryLight as Color).withValues(alpha: 0.2)),
              ),
              child: Text(
                _typeLabel(data.calendarType).toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: palette.primaryLight,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          data.label ?? 'Untiteld Goal',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: palette.textPrimary,
            letterSpacing: -1,
            height: 1.1,
          ),
        ),
      ],
    );
  }

  String _typeLabel(CalendarType type) {
    switch (type) {
      case CalendarType.life: return 'Life';
      case CalendarType.year: return 'Year';
      case CalendarType.goal: return 'Goal';
      case CalendarType.productLaunch: return 'Launch';
      case CalendarType.fitnessGoal: return 'Fitness';
    }
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.data, required this.palette});
  final WallpaperData data;
  final dynamic palette;

  @override
  Widget build(BuildContext context) {
    final progress = data.percentElapsed / 100.0;
    
    return GlassCard(
      borderRadius: 32,
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 160,
                height: 160,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 14,
                  strokeCap: StrokeCap.round,
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                  color: palette.accent,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${data.percentElapsed}%',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                      color: palette.textPrimary,
                      height: 1,
                    ),
                  ),
                  Text(
                    'COMPLETE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: palette.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            '${data.elapsedDays} days passed  ·  ${data.daysLeft} days left',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.data, required this.palette});
  final WallpaperData data;
  final dynamic palette;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _MetricTile(
          label: 'TOTAL DAYS',
          value: '${data.totalDays}',
          icon: Icons.calendar_today_rounded,
          palette: palette,
        ),
        _MetricTile(
          label: 'DAYS PASSED',
          value: '${data.elapsedDays}',
          icon: Icons.history_rounded,
          palette: palette,
        ),
        _MetricTile(
          label: 'DAYS LEFT',
          value: '${data.daysLeft}',
          icon: Icons.timer_outlined,
          palette: palette,
        ),
        _MetricTile(
          label: 'WEEKS LEFT',
          value: '${(data.daysLeft / 7).floor()}',
          icon: Icons.view_week_rounded,
          palette: palette,
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.palette,
  });

  final String label;
  final String value;
  final IconData icon;
  final dynamic palette;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: palette.primaryLight),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: palette.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: palette.textPrimary,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.data, required this.palette});
  final WallpaperData data;
  final dynamic palette;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return GlassCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timeline_rounded, size: 16, color: palette.primaryLight),
              const SizedBox(width: 8),
              Text(
                'TIMELINE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: palette.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _TimelineItem(
            date: data.startDate,
            label: 'Start Date',
            isPast: true,
            palette: palette,
            dateFormat: dateFormat,
          ),
          _TimelineConnector(palette: palette),
          _TimelineItem(
            date: DateTime.now(),
            label: 'Today',
            isPast: false,
            isToday: true,
            palette: palette,
            dateFormat: dateFormat,
          ),
          _TimelineConnector(palette: palette),
          _TimelineItem(
            date: data.endDate,
            label: 'Deadline / Goal',
            isPast: false,
            palette: palette,
            dateFormat: dateFormat,
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.date,
    required this.label,
    required this.isPast,
    required this.palette,
    required this.dateFormat,
    this.isToday = false,
  });

  final DateTime date;
  final String label;
  final bool isPast;
  final bool isToday;
  final dynamic palette;
  final DateFormat dateFormat;

  @override
  Widget build(BuildContext context) {
    final color = isToday ? palette.accent as Color : (isPast ? palette.primaryLight as Color : palette.textMuted as Color);
    
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: isToday ? [
              BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 10)
            ] : null,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: palette.textMuted,
              ),
            ),
            Text(
              dateFormat.format(date), 
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: palette.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TimelineConnector extends StatelessWidget {
  const _TimelineConnector({required this.palette});
  final dynamic palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5.5),
      width: 1,
      height: 24,
      color: Colors.white.withValues(alpha: 0.1),
    );
  }
}
