import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/wallpaper_config.dart';

/// Renders the "Dots" wallpaper style onto a canvas.
///
/// Two layout modes:
///   - **flat**    – all days in a single uniform grid (Goal, Life, Product Launch, Fitness)
///   - **monthly** – 12 month blocks arranged 3-wide (Year Calendar)
class DotWallpaperPainter extends CustomPainter {
  DotWallpaperPainter({
    required this.data,
    required this.pastColor,
    required this.todayColor,
    required this.futureColor,
    required this.bgColor,
    required this.labelColor,
    required this.monthLabelColor,
    this.showCaption = true,
    this.showTodayGlow = true,
    this.showPercent = true,
  });

  final WallpaperData data;
  final Color pastColor;
  final Color todayColor;
  final Color futureColor;
  final Color bgColor;
  final Color labelColor;
  final Color monthLabelColor;
  final bool showCaption;
  final bool showTodayGlow;
  final bool showPercent;

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    canvas.drawRect(Offset.zero & size, Paint()..color = bgColor);

    if (data.calendarType == CalendarType.year) {
      switch (data.yearLayout) {
        case YearLayoutStyle.days:
          _paintFlatLayout(canvas, size);
          break;
        case YearLayoutStyle.months:
          _paintMonthlyLayout(canvas, size);
          break;
        case YearLayoutStyle.quarters:
          _paintQuarterlyLayout(canvas, size);
          break;
      }
    } else {
      _paintFlatLayout(canvas, size);
    }

    if (showCaption) _paintCaption(canvas, size);
  }

  // ── Flat layout ──────────────────────────────────────────────

  void _paintFlatLayout(Canvas canvas, Size size) {
    const cols = 20;
    final total = data.totalDays;
    final elapsed = data.elapsedDays;

    final horizontalPadding = size.width * 0.07;
    final availableWidth = size.width - horizontalPadding * 2;

    // dot radius + gap so cols dots + (cols-1) gaps = availableWidth
    // dotDiameter * cols + gap * (cols - 1) = availableWidth
    // Let gap = dotDiameter * 0.6  →  dotDiameter * (cols + 0.6*(cols-1)) = avail
    final dotDiameter = availableWidth / (cols + 0.6 * (cols - 1));
    final gap = dotDiameter * 0.6;
    final stride = dotDiameter + gap;
    final dotRadius = dotDiameter / 2;

    final rows = (total / cols).ceil();
    final gridHeight = rows * stride - gap; // subtract trailing gap
    final topOffset = (size.height - gridHeight) / 2 - size.height * 0.05;

    for (int i = 0; i < total; i++) {
      final col = i % cols;
      final row = i ~/ cols;
      final cx = horizontalPadding + col * stride + dotRadius;
      final cy = topOffset + row * stride + dotRadius;

      final color = i < elapsed
          ? pastColor
          : (i == elapsed ? todayColor : futureColor);

      final paint = Paint()..color = color;
      canvas.drawCircle(Offset(cx, cy), dotRadius, paint);

      // glow on today dot
      if (i == elapsed && showTodayGlow) {
        final glowPaint = Paint()
          ..color = todayColor.withValues(alpha: 0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
        canvas.drawCircle(Offset(cx, cy), dotRadius * 2.2, glowPaint);
        // redraw solid on top of glow
        canvas.drawCircle(Offset(cx, cy), dotRadius, Paint()..color = todayColor);
      }
    }
  }

  // ── Monthly layout (Year Calendar) ───────────────────────────

  static const _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  void _paintMonthlyLayout(Canvas canvas, Size size) {
    final year = data.startDate.year;
    final elapsed = data.elapsedDays; // global day index for coloring

    const outerPadH = 0.06; // fraction of width
    const outerPadTop = 0.12; // fraction of height
    const outerPadBottom = 0.18;

    final leftMargin = size.width * outerPadH;
    final topMargin = size.height * outerPadTop;
    final availW = size.width - leftMargin * 2;
    final availH = size.height * (1 - outerPadTop - outerPadBottom);

    // 3 cols, 4 rows of month blocks
    const monthCols = 3;
    const monthRows = 4;
    final blockW = availW / monthCols;
    final blockH = availH / monthRows;

    int globalDayIndex = 0;

    for (int m = 0; m < 12; m++) {
      final col = m % monthCols;
      final row = m ~/ monthCols;
      final blockLeft = leftMargin + col * blockW;
      final blockTop = topMargin + row * blockH;

      final daysInMonth = _daysInMonth(year, m + 1);

      // Month label
      final labelStyle = TextStyle(
        fontSize: size.width * 0.028,
        fontWeight: FontWeight.w600,
        color: monthLabelColor,
      );
      _drawText(
        canvas,
        _monthNames[m],
        Offset(blockLeft, blockTop),
        labelStyle,
      );

      final labelHeight = size.width * 0.028 * 1.4;
      final dotAreaTop = blockTop + labelHeight + size.height * 0.005;
      final dotAreaW = blockW * 0.92;
      final dotAreaH = blockH - labelHeight - size.height * 0.01;

      // Fit dots: 7 cols for month grid
      const dotCols = 7;
      final dotD = math.min(
        dotAreaW / (dotCols + 0.5 * (dotCols - 1)),
        dotAreaH / (5 + 0.5 * 4), // max 5 rows
      );
      final dotGap = dotD * 0.5;
      final dotStride = dotD + dotGap;
      final dotR = dotD / 2;

      for (int d = 0; d < daysInMonth; d++) {
        final dcol = d % dotCols;
        final drow = d ~/ dotCols;
        final cx = blockLeft + dcol * dotStride + dotR;
        final cy = dotAreaTop + drow * dotStride + dotR;

        final isToday = globalDayIndex == elapsed;
        final isPast = globalDayIndex < elapsed;
        final color = isPast ? pastColor : (isToday ? todayColor : futureColor);

        canvas.drawCircle(Offset(cx, cy), dotR, Paint()..color = color);

        if (isToday && showTodayGlow) {
          final glowPaint = Paint()
            ..color = todayColor.withValues(alpha: 0.4)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
          canvas.drawCircle(Offset(cx, cy), dotR * 2, glowPaint);
          canvas.drawCircle(Offset(cx, cy), dotR, Paint()..color = todayColor);
        }

        globalDayIndex++;
      }
    }
  }

  // ── Quarterly layout (Year Calendar) ─────────────────────────

  static const _quarterMonths = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
    [10, 11, 12],
  ];
  static const _quarterNames = ['Q1', 'Q2', 'Q3', 'Q4'];

  /// Four quarter headers, each with one dot-row per month.
  void _paintQuarterlyLayout(Canvas canvas, Size size) {
    final year = data.startDate.year;
    final elapsed = data.elapsedDays; // global day index for coloring

    const outerPadH = 0.07;
    final leftMargin = size.width * outerPadH;
    final topMargin = size.height * 0.10;
    final availW = size.width - leftMargin * 2;
    final availH = size.height * (1 - 0.10 - 0.16); // caption zone at bottom

    final quarterHeaderH = availH * 0.055;
    final monthRowH = availH * 0.042;
    final quarterGap = availH * 0.018;
    final monthLabelW = availW * 0.05;

    int globalDayIndex = 0;

    double y = topMargin;
    for (int q = 0; q < 4; q++) {
      final months = _quarterMonths[q];

      // Quarter header
      _drawText(
        canvas,
        '${_quarterNames[q]}  ·  ${_monthNames[months.first - 1]}–${_monthNames[months.last - 1]}',
        Offset(leftMargin, y),
        TextStyle(
          fontSize: size.width * 0.026,
          fontWeight: FontWeight.w600,
          color: monthLabelColor,
        ),
      );
      y += quarterHeaderH;

      for (final month in months) {
        // Month initial
        _drawText(
          canvas,
          _monthNames[month - 1].substring(0, 1),
          Offset(leftMargin, y + monthRowH * 0.18),
          TextStyle(
            fontSize: monthRowH * 0.5,
            fontWeight: FontWeight.w600,
            color: monthLabelColor,
          ),
        );

        // Day dots across the remaining width
        final days = _daysInMonth(year, month);
        final dotAvailW = availW - monthLabelW;
        final dotD = math.min(
          monthRowH * 0.72,
          dotAvailW / (31 + 0.5 * 30),
        );
        final dotGap = dotD * 0.5;
        final dotR = dotD / 2;

        for (int d = 0; d < days; d++) {
          final cx = leftMargin + monthLabelW + d * (dotD + dotGap) + dotR;
          final cy = y + monthRowH / 2;

          final isToday = globalDayIndex == elapsed;
          final isPast = globalDayIndex < elapsed;
          final color = isPast ? pastColor : (isToday ? todayColor : futureColor);

          canvas.drawCircle(Offset(cx, cy), dotR, Paint()..color = color);

          if (isToday && showTodayGlow) {
            final glowPaint = Paint()
              ..color = todayColor.withValues(alpha: 0.4)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
            canvas.drawCircle(Offset(cx, cy), dotR * 2, glowPaint);
            canvas.drawCircle(Offset(cx, cy), dotR, Paint()..color = todayColor);
          }

          globalDayIndex++;
        }

        y += monthRowH;
      }

      y += quarterGap;
    }
  }

  // ── Caption ───────────────────────────────────────────────────

  void _paintCaption(Canvas canvas, Size size) {
    final style = TextStyle(
      fontSize: size.width * 0.038,
      fontWeight: FontWeight.w400,
      color: labelColor,
      letterSpacing: 0.5,
    );
    // Build caption text based on showPercent toggle
    final text = showPercent
        ? data.caption
        : '${data.daysLeft}d left';
    final tp = _buildTextPainter(text, style, size.width);
    final x = (size.width - tp.width) / 2;
    final y = size.height * 0.87;
    tp.paint(canvas, Offset(x, y));
  }

  // ── Helpers ───────────────────────────────────────────────────

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style) {
    final tp = _buildTextPainter(text, style, double.infinity);
    tp.paint(canvas, offset);
  }

  TextPainter _buildTextPainter(String text, TextStyle style, double maxWidth) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    return tp;
  }

  int _daysInMonth(int year, int month) =>
      DateTime(year, month + 1, 0).day;

  @override
  bool shouldRepaint(DotWallpaperPainter old) =>
      old.data != data ||
      old.pastColor != pastColor ||
      old.todayColor != todayColor ||
      old.futureColor != futureColor ||
      old.showCaption != showCaption ||
      old.showTodayGlow != showTodayGlow ||
      old.showPercent != showPercent;
}
