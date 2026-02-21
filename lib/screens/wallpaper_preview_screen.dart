import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../models/wallpaper_config.dart';
import '../painters/dot_wallpaper_painter.dart';
import '../services/wallpaper_service.dart';
import '../services/wallpaper_storage.dart';

class WallpaperPreviewScreen extends StatefulWidget {
  const WallpaperPreviewScreen({super.key, required this.data});

  final WallpaperData data;

  @override
  State<WallpaperPreviewScreen> createState() => _WallpaperPreviewScreenState();
}

class _WallpaperPreviewScreenState extends State<WallpaperPreviewScreen> {
  bool _isSetting = false;

  Future<void> _setWallpaper(dynamic palette) async {
    setState(() => _isSetting = true);
    try {
      final todayColor = palette.accent as Color;
      final labelColor = palette.primaryLight as Color;
      final monthLabelColor = palette.textMuted as Color;

      final pngBytes = await WallpaperService.renderToPng(
        data: widget.data,
        pastColor: Colors.white,
        todayColor: todayColor,
        futureColor: const Color(0x1FFFFFFF),
        labelColor: labelColor,
        monthLabelColor: monthLabelColor,
      );

      await WallpaperService.setAsLockScreen(pngBytes);

      // Persist config so WorkManager can refresh it daily
      await WallpaperStorage.save(
        data: widget.data,
        todayColor: todayColor.toARGB32(),
        labelColor: labelColor.toARGB32(),
        monthLabelColor: monthLabelColor.toARGB32(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF1A1A1A),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            content: Row(
              children: [
                Icon(Icons.check_circle_rounded,
                    color: palette.primaryLight as Color, size: 18),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Lock screen updated! Refreshes automatically every day.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } on WallpaperServiceException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF1A1A1A),
            behavior: SnackBarBehavior.floating,
            content: Text(e.message,
                style: const TextStyle(color: Colors.white70)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSetting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<ThemeProvider>().palette;

    // Colors matching the reference design
    const bgColor = Color(0xFF0D0D0D);
    const pastColor = Colors.white;
    final todayColor = palette.accent;
    const futureColor = Color(0x1FFFFFFF);

    final painter = DotWallpaperPainter(
      data: widget.data,
      pastColor: pastColor,
      todayColor: todayColor,
      futureColor: futureColor,
      bgColor: bgColor,
      labelColor: palette.primaryLight,
      monthLabelColor: palette.textMuted,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white54, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.data.label != null
                  ? widget.data.label!
                  : _typeLabel(widget.data.calendarType),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              widget.data.caption,
              style: TextStyle(
                fontSize: 12,
                color: palette.primaryLight,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Wallpaper preview ──────────────────────────────
          Expanded(
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: AspectRatio(
                  aspectRatio: 9 / 19.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: CustomPaint(
                      painter: painter,
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Bottom action bar ──────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                children: [
                  // Share button (stub)
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white.withValues(alpha: 0.07),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.10)),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.share_rounded,
                          color: Colors.white70, size: 22),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Share coming soon!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 14),

                  // Set as Lock Screen (primary) or iOS message
                  Expanded(
                    child: Platform.isAndroid
                        ? _SetWallpaperButton(
                            palette: palette,
                            isLoading: _isSetting,
                            onTap: () => _setWallpaper(palette),
                          )
                        : _IOSWallpaperNote(palette: palette),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _typeLabel(CalendarType type) {
    switch (type) {
      case CalendarType.life:
        return 'Life Calendar';
      case CalendarType.year:
        return 'Year Calendar';
      case CalendarType.goal:
        return 'Goal Calendar';
      case CalendarType.productLaunch:
        return 'Product Launch';
      case CalendarType.fitnessGoal:
        return 'Fitness Goal';
    }
  }
}

class _SetWallpaperButton extends StatelessWidget {
  const _SetWallpaperButton({
    required this.palette,
    required this.isLoading,
    required this.onTap,
  });

  final dynamic palette;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [palette.primary as Color, palette.primaryLight as Color],
        ),
        boxShadow: [
          BoxShadow(
            color: (palette.primaryLight as Color).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isLoading ? null : onTap,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wallpaper_rounded,
                          color: Colors.white, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Set as Lock Screen',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _IOSWallpaperNote extends StatelessWidget {
  const _IOSWallpaperNote({required this.palette});
  final dynamic palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withValues(alpha: 0.06),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: const Center(
        child: Text(
          'Save image → set from Photos on iOS',
          style: TextStyle(
              fontSize: 12, color: Colors.white54, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
