import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

import '../models/wallpaper_config.dart';
import '../painters/dot_wallpaper_painter.dart';

/// Renders [WallpaperData] to a PNG image and sets it as the Android lock screen.
class WallpaperService {
  /// Renders the dot wallpaper to raw PNG bytes at phone resolution.
  static Future<Uint8List> renderToPng({
    required WallpaperData data,
    required Color pastColor,
    required Color todayColor,
    required Color futureColor,
    required Color labelColor,
    required Color monthLabelColor,
    required double width,
    required double height,
    Color bgColor = const Color(0xFF0D0D0D),
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, width, height),
    );

    final painter = DotWallpaperPainter(
      data: data,
      pastColor: pastColor,
      todayColor: todayColor,
      futureColor: futureColor,
      bgColor: bgColor,
      labelColor: labelColor,
      monthLabelColor: monthLabelColor,
    );

    painter.paint(canvas, Size(width, height));

    final picture = recorder.endRecording();
    final image = await picture.toImage(width.toInt(), height.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  /// Writes [pngBytes] to a temp file and sets it as the Android lock screen.
  /// Throws a [WallpaperServiceException] with a user-friendly message on failure.
  static Future<void> setAsLockScreen(Uint8List pngBytes) async {
    if (!Platform.isAndroid) {
      throw WallpaperServiceException(
        'Setting the lock screen wallpaper is only supported on Android.',
      );
    }
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/gow_wallpaper.png');
      await file.writeAsBytes(pngBytes);
      await WallpaperManagerFlutter()
          .setWallpaper(file, WallpaperManagerFlutter.lockScreen);
    } catch (e) {
      throw WallpaperServiceException(
        'Could not set wallpaper: ${e.toString()}',
      );
    }
  }
}

class WallpaperServiceException implements Exception {
  const WallpaperServiceException(this.message);
  final String message;
  @override
  String toString() => message;
}
