import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import 'wallpaper_service.dart';
import 'wallpaper_storage.dart';

/// The task name registered with WorkManager for daily wallpaper refresh.
const refreshWallpaperTask = 'refreshWallpaper';

/// Top-level entry point called by WorkManager in a separate isolate.
/// Must be annotated and be a top-level (non-class) function.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, _) async {
    if (task == refreshWallpaperTask) {
      try {
        WidgetsFlutterBinding.ensureInitialized();

        final saved = await WallpaperStorage.load();
        if (saved == null) return true; // No config stored, nothing to do.

        final pngBytes = await WallpaperService.renderToPng(
          data: saved.data,
          pastColor: Colors.white,
          todayColor: Color(saved.todayColor),
          futureColor: const Color(0x1FFFFFFF),
          labelColor: Color(saved.labelColor),
          monthLabelColor: Color(saved.monthLabelColor),
          width: saved.width,
          height: saved.height,
        );

        await WallpaperService.setAsLockScreen(pngBytes);
      } catch (_) {
        // Silently swallow — WorkManager will retry on next schedule.
      }
    }
    return Future.value(true);
  });
}
