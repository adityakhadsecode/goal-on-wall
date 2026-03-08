import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../theme/theme_provider.dart';
import '../models/wallpaper_config.dart';
import '../providers/wallpaper_provider.dart';
import '../painters/dot_wallpaper_painter.dart';
import '../painters/flow_wallpaper_painter.dart';
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
  bool _isSharing = false;
  bool _isSettingBoth = false;

  // Customization toggles
  bool _showCaption = true;
  bool _showTodayGlow = true;
  bool _showPercent = true;

  Future<void> _setWallpaper(dynamic palette, {bool both = false}) async {
    if (both) {
      setState(() => _isSettingBoth = true);
    } else {
      setState(() => _isSetting = true);
    }
    try {
      final todayColor = palette.accent as Color;
      final labelColor = palette.primaryLight as Color;
      final monthLabelColor = palette.textMuted as Color;

      final physicalSize = View.of(context).physicalSize;
      final width = physicalSize.width;
      final height = physicalSize.height;

      final pngBytes = await WallpaperService.renderToPng(
        data: widget.data,
        pastColor: Colors.white,
        todayColor: todayColor,
        futureColor: const Color(0x1FFFFFFF),
        labelColor: labelColor,
        monthLabelColor: monthLabelColor,
        width: width,
        height: height,
      );

      if (both) {
        await WallpaperService.setAsBothScreens(pngBytes);
      } else {
        await WallpaperService.setAsLockScreen(pngBytes);
      }

      // Persist config so WorkManager can refresh it daily
      await WallpaperStorage.save(
        data: widget.data,
        todayColor: todayColor.toARGB32(),
        labelColor: labelColor.toARGB32(),
        monthLabelColor: monthLabelColor.toARGB32(),
        width: width,
        height: height,
        screenTarget: both ? 'both' : 'lock',
      );

      // Add to memory provider and set as active
      if (mounted) {
        final provider = Provider.of<WallpaperProvider>(context, listen: false);
        provider.addWallpaper(widget.data);
        provider.setActiveWallpaper(widget.data);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF1A1A1A),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded,
                    color: Colors.greenAccent, size: 20),
                const SizedBox(width: 12),
                Text(both
                    ? 'Wallpaper set on both screens!'
                    : 'Lock screen updated successfully!'),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSetting = false;
          _isSettingBoth = false;
        });
      }
    }
  }

  Future<void> _shareWallpaper(dynamic palette) async {
    setState(() => _isSharing = true);
    try {
      final todayColor = palette.accent as Color;
      final labelColor = palette.primaryLight as Color;
      final monthLabelColor = palette.textMuted as Color;

      final physicalSize = View.of(context).physicalSize;
      final width = physicalSize.width;
      final height = physicalSize.height;

      final pngBytes = await WallpaperService.renderToPng(
        data: widget.data,
        pastColor: Colors.white,
        todayColor: todayColor,
        futureColor: const Color(0x1FFFFFFF),
        labelColor: labelColor,
        monthLabelColor: monthLabelColor,
        width: width,
        height: height,
      );

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/my_progress.png');
      await file.writeAsBytes(pngBytes);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: widget.data.shareText,
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sharing failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  Future<void> _previewWallpaper(dynamic palette) async {
    try {
      final todayColor = palette.accent as Color;
      final labelColor = palette.primaryLight as Color;
      final monthLabelColor = palette.textMuted as Color;

      final physicalSize = View.of(context).physicalSize;
      final width = physicalSize.width;
      final height = physicalSize.height;

      final pngBytes = await WallpaperService.renderToPng(
        data: widget.data,
        pastColor: Colors.white,
        todayColor: todayColor,
        futureColor: const Color(0x1FFFFFFF),
        labelColor: labelColor,
        monthLabelColor: monthLabelColor,
        width: width,
        height: height,
      );

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/gow_preview.png');
      await file.writeAsBytes(pngBytes);

      // Use share intent to let user set as wallpaper via system picker
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'image/png')],
          text: 'Set as wallpaper',
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Preview failed: ${e.toString()}')),
        );
      }
    }
  }

  void _showCustomizeSheet(dynamic palette) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1A1A1A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Title
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: (palette.primary as Color).withValues(alpha: 0.25),
                    ),
                    child: Icon(Icons.tune_rounded,
                        color: palette.primaryLight as Color, size: 18),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Customize Wallpaper',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Toggle: Show caption text
              _ToggleTile(
                icon: Icons.text_fields_rounded,
                title: 'Caption Text',
                subtitle: 'Show days left label at bottom',
                value: _showCaption,
                accentColor: palette.primaryLight as Color,
                onChanged: (v) {
                  setSheetState(() => _showCaption = v);
                  setState(() {});
                },
              ),

              const SizedBox(height: 12),

              // Toggle: Show today dot glow
              _ToggleTile(
                icon: Icons.blur_on_rounded,
                title: 'Today Dot Glow',
                subtitle: 'Highlight today\'s dot with a glow effect',
                value: _showTodayGlow,
                accentColor: palette.primaryLight as Color,
                onChanged: (v) {
                  setSheetState(() => _showTodayGlow = v);
                  setState(() {});
                },
              ),

              const SizedBox(height: 12),

              // Toggle: Show percent completion
              _ToggleTile(
                icon: Icons.percent_rounded,
                title: 'Percent Completion',
                subtitle: 'Show completion percentage in caption',
                value: _showPercent,
                accentColor: palette.primaryLight as Color,
                onChanged: (v) {
                  setSheetState(() => _showPercent = v);
                  setState(() {});
                },
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final palette = themeProvider.palette;

    final CustomPainter painter;
    if (widget.data.wallpaperTheme == WallpaperTheme.flow) {
      painter = FlowWallpaperPainter(
        data: widget.data,
        pastColor: Colors.white,
        todayColor: palette.accent,
        futureColor: Colors.white.withValues(alpha: 0.12),
        bgColor: const Color(0xFF0D0D0D),
        labelColor: palette.primaryLight,
        monthLabelColor: palette.textMuted,
        showCaption: _showCaption,
        showTodayGlow: _showTodayGlow,
        showPercent: _showPercent,
      );
    } else {
      painter = DotWallpaperPainter(
        data: widget.data,
        pastColor: Colors.white,
        todayColor: palette.accent,
        futureColor: Colors.white.withValues(alpha: 0.12),
        bgColor: const Color(0xFF0D0D0D),
        labelColor: palette.primaryLight,
        monthLabelColor: palette.textMuted,
        showCaption: _showCaption,
        showTodayGlow: _showTodayGlow,
        showPercent: _showPercent,
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
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
        actions: [
          // Customize button
          IconButton(
            icon: const Icon(Icons.tune_rounded,
                color: Colors.white70, size: 22),
            onPressed: () => _showCustomizeSheet(palette),
            tooltip: 'Customize',
          ),

          // Share button (moved to top-right)
          _isSharing
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white70,
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.share_rounded,
                      color: Colors.white70, size: 22),
                  onPressed: () => _shareWallpaper(palette),
                  tooltip: 'Share',
                ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Android Device Frame Preview ──────────────────────
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
                  child: Hero(
                    tag: 'wallpaper_preview',
                    child: AspectRatio(
                      aspectRatio: 9 / 19.5,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Main device body
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              color: const Color(0xFF1C1C1C),
                              border: Border.all(
                                color: const Color(0xFF3A3A3A),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.7),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                                BoxShadow(
                                  color: palette.primaryLight
                                      .withValues(alpha: 0.04),
                                  blurRadius: 40,
                                  spreadRadius: -10,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Stack(
                                  children: [
                                    // Wallpaper
                                    Positioned.fill(
                                      child: CustomPaint(
                                        painter: painter,
                                        child: const SizedBox.expand(),
                                      ),
                                    ),
                                    // Camera punch-hole
                                    Positioned(
                                      top: 10,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: const Color(0xFF1A1A1A),
                                            border: Border.all(
                                              color: const Color(0xFF333333),
                                              width: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Bottom nav bar indicator
                                    Positioned(
                                      bottom: 6,
                                      left: 0,
                                      right: 0,
                                      child: Center(
                                        child: Container(
                                          width: 80,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.25),
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Power button (right side)
                          Positioned(
                            right: -3,
                            top: 80,
                            child: Container(
                              width: 3,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFF3A3A3A),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ),
                          // Volume up (right side)
                          Positioned(
                            right: -3,
                            top: 130,
                            child: Container(
                              width: 3,
                              height: 28,
                              decoration: BoxDecoration(
                                color: const Color(0xFF3A3A3A),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ),
                          // Volume down (right side)
                          Positioned(
                            right: -3,
                            top: 166,
                            child: Container(
                              width: 3,
                              height: 28,
                              decoration: BoxDecoration(
                                color: const Color(0xFF3A3A3A),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Bottom action bar ──────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Platform.isAndroid
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Primary: Set as Both
                        _ActionButton(
                          palette: palette,
                          icon: Icons.wallpaper_rounded,
                          label: 'Set as Both Screens',
                          isLoading: _isSettingBoth,
                          isPrimary: true,
                          onTap: () =>
                              _setWallpaper(palette, both: true),
                        ),

                        const SizedBox(height: 10),

                        // Secondary row: Lock Screen & Preview
                        Row(
                          children: [
                            Expanded(
                              child: _ActionButton(
                                palette: palette,
                                icon: Icons.lock_rounded,
                                label: 'Lock Screen',
                                isLoading: _isSetting,
                                isPrimary: false,
                                onTap: () => _setWallpaper(palette),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _ActionButton(
                                palette: palette,
                                icon: Icons.visibility_rounded,
                                label: 'Preview',
                                isLoading: false,
                                isPrimary: false,
                                onTap: () =>
                                    _previewWallpaper(palette),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : _IOSWallpaperNote(palette: palette),
            ),
          ],
        ),
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

// ── Action Button ──────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.palette,
    required this.icon,
    required this.label,
    required this.isLoading,
    required this.isPrimary,
    required this.onTap,
  });

  final dynamic palette;
  final IconData icon;
  final String label;
  final bool isLoading;
  final bool isPrimary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: isPrimary
            ? LinearGradient(
                colors: [
                  palette.primary as Color,
                  palette.primaryLight as Color,
                ],
              )
            : null,
        color: isPrimary ? null : Colors.white.withValues(alpha: 0.07),
        border: isPrimary
            ? null
            : Border.all(color: Colors.white.withValues(alpha: 0.10)),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color:
                      (palette.primaryLight as Color).withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: isLoading ? null : onTap,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon,
                          color: isPrimary ? Colors.white : Colors.white70,
                          size: 18),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isPrimary ? Colors.white : Colors.white70,
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

// ── Toggle Tile for Customize Sheet ─────────────────────────────

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.accentColor,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final Color accentColor;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Icon(icon, color: accentColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: accentColor,
            activeTrackColor: accentColor.withValues(alpha: 0.3),
            inactiveThumbColor: Colors.white38,
            inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
          ),
        ],
      ),
    );
  }
}

// ── iOS Note ────────────────────────────────────────────────────

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
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: const Center(
        child: Text(
          'Save image → set from Photos on iOS',
          style: TextStyle(
              fontSize: 12,
              color: Colors.white54,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
