import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../models/wallpaper_config.dart';
import '../painters/dot_wallpaper_painter.dart';

class WallpaperPreviewScreen extends StatelessWidget {
  const WallpaperPreviewScreen({super.key, required this.data});

  final WallpaperData data;

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<ThemeProvider>().palette;

    // Colors matching the reference design
    const bgColor = Color(0xFF0D0D0D);
    const pastColor = Colors.white;
    final todayColor = palette.accent;
    const futureColor = Color(0x1FFFFFFF); // ~12% white

    final painter = DotWallpaperPainter(
      data: data,
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
              data.label != null ? data.label! : _typeLabel(data.calendarType),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              data.caption,
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: AspectRatio(
                  // 9:19.5 — standard phone ratio
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
                  // Share button
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

                  // Save button (primary)
                  Expanded(
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            palette.primary,
                            palette.primaryLight,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: palette.primaryLight.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Save to Photos — coming soon!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.download_rounded,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 10),
                              Text(
                                'Save to Photos',
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
