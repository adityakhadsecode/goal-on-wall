// ============================================================
// HOME SCREEN V1 BACKUP
// Original design preserved exactly. Class renamed to HomeScreenV1Backup.
// Do not modify this file — it is a reference backup of the v1 layout.
// ============================================================

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';

class HomeScreenV1Backup extends StatefulWidget {
  const HomeScreenV1Backup({super.key});

  @override
  State<HomeScreenV1Backup> createState() => _HomeScreenV1BackupState();
}

class _HomeScreenV1BackupState extends State<HomeScreenV1Backup>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatingController;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _floatingController.dispose();
    super.dispose();
  }

  // Calculate year progress
  double get _yearProgress {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear = DateTime(now.year, 12, 31);
    final totalDays = endOfYear.difference(startOfYear).inDays + 1;
    final daysPassed = now.difference(startOfYear).inDays + 1;
    return daysPassed / totalDays;
  }

  int get _daysPassed {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    return now.difference(startOfYear).inDays + 1;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<ThemeProvider>().palette;
    final percentage = (_yearProgress * 100).round();

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
                        "Today's Flow",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: palette.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'CURRENT JOURNEY',
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
                      Icons.share_rounded,
                      color: palette.textSecondary,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Glass card with vine visualization
                    Expanded(
                      child: GlassCard(
                        borderRadius: 40,
                        child: Stack(
                          children: [
                            // Preview button
                            Positioned(
                              top: 20,
                              right: 20,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                                child: Text(
                                  'PREVIEW',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2,
                                    color: palette.textMuted,
                                  ),
                                ),
                              ),
                            ),

                            // Vine/river visualization
                            CustomPaint(
                              painter: VinePathPainterV1(
                                progress: _yearProgress,
                                palette: palette,
                                animationValue: _floatingController,
                              ),
                              size: Size.infinite,
                            ),

                            // "Current Growth" badge
                            Positioned(
                              top: MediaQuery.of(context).size.height * 0.22,
                              right: 30,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color:
                                        palette.accent.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: palette.accent,
                                        boxShadow: [
                                          BoxShadow(
                                            color: palette.accent
                                                .withValues(alpha: 0.6),
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'CURRENT GROWTH',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 2,
                                        color: palette.accent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Bottom overlay: percentage + stats
                            Positioned(
                              left: 32,
                              right: 32,
                              bottom: 32,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '$percentage',
                                        style: TextStyle(
                                          fontSize: 72,
                                          fontWeight: FontWeight.w300,
                                          color: palette.textPrimary,
                                          height: 1,
                                          letterSpacing: -3,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 14),
                                        child: Text(
                                          '%',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w300,
                                            color: palette.primaryLight,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        'CULTIVATED',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 3,
                                          color: palette.primaryLight,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Container(
                                        height: 1,
                                        width: 48,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              palette.primaryLight
                                                  .withValues(alpha: 0.5),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    padding: const EdgeInsets.only(top: 16),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Colors.white
                                              .withValues(alpha: 0.05),
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today_rounded,
                                              size: 16,
                                              color: palette.textMuted,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              '$_daysPassed Cycles Grown',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: palette.textSecondary,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.check_circle_rounded,
                                          size: 22,
                                          color: palette.primaryLight,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: palette.buttonGradient,
                              ),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      palette.primary.withValues(alpha: 0.2),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.ios_share_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'SHARE FLOW',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white.withValues(alpha: 0.05),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.05),
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.wallpaper_rounded,
                                      color: palette.textSecondary,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'SET ACTIVE',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.5,
                                        color: palette.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 100), // space for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Backup of original VinePathPainter (v1)
class VinePathPainterV1 extends CustomPainter {
  final double progress;
  final dynamic palette;
  final AnimationController animationValue;

  VinePathPainterV1({
    required this.progress,
    required this.palette,
    required this.animationValue,
  }) : super(repaint: animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Future path (dashed, faint)
    final futurePath = Path();
    futurePath.moveTo(w * 0.5, h * 0.97);
    futurePath.cubicTo(
      w * 0.4, h * 0.83,
      w * 0.73, h * 0.75,
      w * 0.5, h * 0.58,
    );
    futurePath.cubicTo(
      w * 0.27, h * 0.42,
      w * 0.67, h * 0.25,
      w * 0.5, h * 0.03,
    );

    final futurePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    _drawDashedPath(canvas, futurePath, futurePaint, 10, 10);

    final completedLength = progress.clamp(0.0, 1.0);
    final pathMetrics = futurePath.computeMetrics().first;
    final totalLength = pathMetrics.length;
    final extractedPath =
        pathMetrics.extractPath(totalLength * (1 - completedLength), totalLength);

    final completedPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: palette.vineGradient as List<Color>,
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: (palette.vineGradient as List<Color>)
            .map((c) => c.withValues(alpha: 0.4))
            .toList(),
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    canvas.drawPath(extractedPath, glowPaint);
    canvas.drawPath(extractedPath, completedPaint);

    final leadingPoint =
        pathMetrics.getTangentForOffset(totalLength * (1 - completedLength));
    if (leadingPoint != null) {
      final floatOffset = sin(animationValue.value * 2 * pi) * 4;

      canvas.drawCircle(
        Offset(leadingPoint.position.dx, leadingPoint.position.dy + floatOffset),
        12,
        Paint()
          ..color = (palette.primaryLight).withValues(alpha: 0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
      );
      canvas.drawCircle(
        Offset(leadingPoint.position.dx, leadingPoint.position.dy + floatOffset),
        8,
        Paint()..color = palette.primaryLight,
      );
      canvas.drawCircle(
        Offset(leadingPoint.position.dx, leadingPoint.position.dy + floatOffset),
        3,
        Paint()..color = Colors.white.withValues(alpha: 0.4),
      );
    }

    final startPoint = pathMetrics.getTangentForOffset(totalLength);
    if (startPoint != null) {
      canvas.drawCircle(startPoint.position, 6, Paint()..color = palette.primaryLight);
    }

    final amberPoint = pathMetrics.getTangentForOffset(totalLength * 0.87);
    if (amberPoint != null) {
      canvas.drawCircle(amberPoint.position, 5, Paint()..color = palette.accent);
      canvas.drawCircle(
        amberPoint.position,
        8,
        Paint()
          ..color = (palette.accent).withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
      );
    }

    final faintDot1 = pathMetrics.getTangentForOffset(totalLength * 0.35);
    if (faintDot1 != null) {
      canvas.drawCircle(faintDot1.position, 6, Paint()..color = Colors.white.withValues(alpha: 0.05));
    }
    final faintDot2 = pathMetrics.getTangentForOffset(totalLength * 0.2);
    if (faintDot2 != null) {
      canvas.drawCircle(faintDot2.position, 4, Paint()..color = Colors.white.withValues(alpha: 0.05));
    }
  }

  void _drawDashedPath(
      Canvas canvas, Path path, Paint paint, double dashWidth, double dashSpace) {
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dashWidth).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant VinePathPainterV1 oldDelegate) =>
      oldDelegate.progress != progress;
}
