import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../models/wallpaper_config.dart';

/// Renders "The Flow" wallpaper style onto a canvas.
///
/// A winding river path flows from top to bottom of the screen.
/// The completed portion is drawn as a solid gradient stroke with a glow,
/// the future portion as a subtle dashed line.
/// "Today" is marked with a glowing dot at the current progress offset.
class FlowWallpaperPainter extends CustomPainter {
  FlowWallpaperPainter({
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
    final w = size.width;
    final h = size.height;

    // ── Background ──────────────────────────────────────────────
    canvas.drawRect(Offset.zero & size, Paint()..color = bgColor);

    // Subtle radial glow behind the path
    final bgGlow = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.2, -0.3),
        radius: 1.2,
        colors: [
          todayColor.withValues(alpha: 0.06),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgGlow);

    // ── Build the river path ────────────────────────────────────
    final riverPath = _buildRiverPath(w, h);

    final metrics = riverPath.computeMetrics().first;
    final totalLen = metrics.length;
    final progress = data.progress.clamp(0.0, 1.0);

    // The path flows from top (0) to bottom (totalLen).
    // "Completed" portion = from the start of the path up to progress.
    final completedLen = totalLen * progress;

    // ── Draw future (dashed) path ───────────────────────────────
    _drawDashed(
      canvas,
      riverPath,
      Paint()
        ..color = futureColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.007
        ..strokeCap = StrokeCap.round,
      w * 0.016,
      w * 0.02,
    );

    // ── Draw completed path glow ────────────────────────────────
    if (completedLen > 0) {
      final completedPath = metrics.extractPath(0, completedLen);

      // Outer glow
      canvas.drawPath(
        completedPath,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              pastColor.withValues(alpha: 0.15),
              todayColor.withValues(alpha: 0.30),
            ],
          ).createShader(Rect.fromLTWH(0, 0, w, h))
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.05
          ..strokeCap = StrokeCap.round
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.04),
      );

      // Core solid stroke
      canvas.drawPath(
        completedPath,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              pastColor,
              todayColor,
            ],
          ).createShader(Rect.fromLTWH(0, 0, w, h))
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.018
          ..strokeCap = StrokeCap.round,
      );

      // ── Shimmer dots along the completed path ─────────────────
      for (int i = 0; i < 5; i++) {
        final t = (i / 5.0);
        final shimmerOffset = completedLen * t;
        if (shimmerOffset <= 0) continue;
        final tan = metrics.getTangentForOffset(shimmerOffset);
        if (tan != null) {
          canvas.drawCircle(
            tan.position,
            w * 0.005,
            Paint()
              ..color = Colors.white.withValues(alpha: 0.25)
              ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.006),
          );
        }
      }
    }

    // ── Draw "today" leading dot ────────────────────────────────
    if (showTodayGlow && completedLen > 0) {
      final leadTan = metrics.getTangentForOffset(completedLen.clamp(0.0, totalLen));
      if (leadTan != null) {
        // Outer glow pulse
        canvas.drawCircle(
          leadTan.position,
          w * 0.035,
          Paint()
            ..color = todayColor.withValues(alpha: 0.3)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.04),
        );
        // Solid core
        canvas.drawCircle(
          leadTan.position,
          w * 0.014,
          Paint()..color = todayColor,
        );
        // Inner highlight
        canvas.drawCircle(
          leadTan.position,
          w * 0.006,
          Paint()..color = Colors.white.withValues(alpha: 0.7),
        );
      }
    }

    // ── Milestone markers along the path ────────────────────────
    _drawMilestoneMarkers(canvas, metrics, totalLen, w);

    // ── Caption ─────────────────────────────────────────────────
    if (showCaption) _paintCaption(canvas, size);
  }

  /// Builds a winding cubic Bézier path from top to bottom.
  Path _buildRiverPath(double w, double h) {
    final path = Path();
    // Start near top-center
    path.moveTo(w * 0.50, h * 0.04);

    // 1st curve: gentle right
    path.cubicTo(
      w * 0.65, h * 0.12,
      w * 0.72, h * 0.20,
      w * 0.55, h * 0.28,
    );
    // 2nd curve: sweep left
    path.cubicTo(
      w * 0.35, h * 0.36,
      w * 0.22, h * 0.40,
      w * 0.38, h * 0.48,
    );
    // 3rd curve: back to center-right
    path.cubicTo(
      w * 0.58, h * 0.54,
      w * 0.75, h * 0.58,
      w * 0.58, h * 0.66,
    );
    // 4th curve: sweep left again
    path.cubicTo(
      w * 0.38, h * 0.72,
      w * 0.25, h * 0.78,
      w * 0.45, h * 0.84,
    );
    // 5th curve: end near bottom center
    path.cubicTo(
      w * 0.60, h * 0.88,
      w * 0.55, h * 0.92,
      w * 0.50, h * 0.96,
    );

    return path;
  }

  /// Draw small amber dots at 25%, 50%, 75% milestones.
  void _drawMilestoneMarkers(
    Canvas canvas,
    ui.PathMetric metrics,
    double totalLen,
    double w,
  ) {
    final milestones = [0.25, 0.50, 0.75];
    for (final m in milestones) {
      final tan = metrics.getTangentForOffset(totalLen * m);
      if (tan != null) {
        // Small dot
        canvas.drawCircle(
          tan.position,
          w * 0.008,
          Paint()..color = monthLabelColor.withValues(alpha: 0.5),
        );
        // Glow ring
        canvas.drawCircle(
          tan.position,
          w * 0.02,
          Paint()
            ..color = monthLabelColor.withValues(alpha: 0.12)
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 0.02),
        );
      }
    }
  }

  /// Draw dashed version of a path.
  void _drawDashed(
    Canvas canvas,
    Path path,
    Paint paint,
    double dash,
    double gap,
  ) {
    for (final m in path.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        final end = (d + dash).clamp(0.0, m.length);
        canvas.drawPath(m.extractPath(d, end), paint);
        d += dash + gap;
      }
    }
  }

  /// Renders the bottom caption text.
  void _paintCaption(Canvas canvas, Size size) {
    final text = showPercent ? data.caption : '${data.daysLeft}d left';
    final style = TextStyle(
      fontSize: size.width * 0.038,
      fontWeight: FontWeight.w400,
      color: labelColor,
      letterSpacing: 0.5,
    );
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);
    final x = (size.width - tp.width) / 2;
    final y = size.height * 0.87;
    tp.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(FlowWallpaperPainter old) =>
      old.data != data ||
      old.pastColor != pastColor ||
      old.todayColor != todayColor ||
      old.futureColor != futureColor ||
      old.showCaption != showCaption ||
      old.showTodayGlow != showTodayGlow ||
      old.showPercent != showPercent;
}
