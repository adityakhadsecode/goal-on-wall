import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wallpaper_config.dart';
import '../services/wallpaper_storage.dart';

class WallpaperProvider extends ChangeNotifier {
  static const _keySavedWallpapers = 'gow_saved_wallpapers';
  
  List<WallpaperData> _savedWallpapers = [];
  WallpaperData? _activeWallpaper;

  List<WallpaperData> get savedWallpapers => List.unmodifiable(_savedWallpapers);
  WallpaperData? get activeWallpaper => _activeWallpaper;

  WallpaperProvider() {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    // Load saved wallpapers
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_keySavedWallpapers);
    if (jsonStr != null) {
      try {
        final List<dynamic> decoded = json.decode(jsonStr);
        _savedWallpapers = decoded
            .map((item) => WallpaperData.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (e) {
        debugPrint('Error loading saved wallpapers: $e');
      }
    }

    // Load active wallpaper
    final saved = await WallpaperStorage.load();
    _activeWallpaper = saved?.data;
    
    notifyListeners();
  }

  Future<void> setActiveWallpaper(WallpaperData data) async {
    _activeWallpaper = data;
    notifyListeners();
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = json.encode(_savedWallpapers.map((w) => w.toJson()).toList());
    await prefs.setString(_keySavedWallpapers, jsonStr);
  }

  Future<void> addWallpaper(WallpaperData data) async {
    // Avoid duplicates if same data is added (simplified check)
    final exists = _savedWallpapers.any((w) => 
      w.calendarType == data.calendarType && 
      w.label == data.label &&
      w.startDate == data.startDate &&
      w.endDate == data.endDate
    );
    
    if (!exists) {
      _savedWallpapers.insert(0, data); // Newest first
      notifyListeners();
      await _saveToStorage();
    }
  }

  Future<void> removeWallpaper(int index) async {
    if (index >= 0 && index < _savedWallpapers.length) {
      _savedWallpapers.removeAt(index);
      notifyListeners();
      await _saveToStorage();
    }
  }
}
