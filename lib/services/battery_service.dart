import 'package:flutter/services.dart';

/// Bridges to Android battery-optimization state via [MainActivity] so the
/// daily wallpaper refresh survives aggressive OEM battery managers
/// (Xiaomi, Oppo, OnePlus, etc.).
class BatteryService {
  static const _channel = MethodChannel('goal_on_wall/battery');

  /// Whether the app is exempt from Doze / battery optimization. Returns
  /// true on non-Android platforms where there is nothing to exempt.
  static Future<bool> isIgnoringOptimizations() async {
    try {
      return await _channel.invokeMethod<bool>(
            'isIgnoringBatteryOptimizations',
          ) ??
          true;
    } on PlatformException {
      return true;
    } on MissingPluginException {
      return true;
    }
  }

  /// Opens the system battery-optimization settings list.
  static Future<void> openOptimizationSettings() async {
    try {
      await _channel.invokeMethod('openBatteryOptimizationSettings');
    } on PlatformException {
      // Settings screen unavailable on this device/OS shape
    } on MissingPluginException {
      // Non-Android platform
    }
  }
}
