/// Shared enums and data model for the wallpaper creation flow.
enum CalendarType { life, year, goal, productLaunch, fitnessGoal }

enum WallpaperTheme { flow, dots }

/// Dot arrangement for Year Calendar wallpapers (only meaningful for the
/// "Dots" style — The Flow is a single path and ignores it).
enum YearLayoutStyle { days, months, quarters }

/// All the information needed to render any wallpaper type.
class WallpaperData {
  const WallpaperData({
    required this.calendarType,
    required this.wallpaperTheme,
    required this.startDate,
    required this.endDate,
    this.label,
    this.yearLayout = YearLayoutStyle.months,
  });

  final CalendarType calendarType;
  final WallpaperTheme wallpaperTheme;

  /// Dot layout for year calendars (ignored by other types).
  final YearLayoutStyle yearLayout;

  /// First day of the period (inclusive).
  final DateTime startDate;

  /// Last day of the period (inclusive).
  final DateTime endDate;

  /// Optional human-readable label (goal name, product name, etc.).
  final String? label;

  // ── Computed helpers ─────────────────────────────────────────

  /// Total number of days in the period.
  int get totalDays {
    final d = _dateOnly(endDate).difference(_dateOnly(startDate)).inDays + 1;
    return d < 1 ? 1 : d;
  }

  /// How many days have elapsed from startDate (0 = today is day 0 / first dot).
  int get elapsedDays {
    final today = _dateOnly(DateTime.now());
    final start = _dateOnly(startDate);
    final diff = today.difference(start).inDays;
    return diff.clamp(0, totalDays);
  }

  /// Index of today's dot (same as elapsedDays but capped at totalDays - 1).
  int get todayIndex => elapsedDays.clamp(0, totalDays - 1);

  /// 0.0 – 1.0 progress.
  double get progress => elapsedDays / totalDays;

  /// Days remaining until (and including) endDate.
  int get daysLeft {
    final today = _dateOnly(DateTime.now());
    final end = _dateOnly(endDate);
    final diff = end.difference(today).inDays;
    return diff < 0 ? 0 : diff;
  }

  /// Percentage elapsed, 0–100 integer.
  int get percentElapsed => (progress * 100).round().clamp(0, 100);

  /// Bottom caption string, e.g. "341d left · 6%"
  String get caption => '${daysLeft}d left  ·  $percentElapsed%';

  /// Formatted text summary for sharing.
  String get shareText {
    final subject = calendarType == CalendarType.year
        ? 'Year: ${label ?? startDate.year}'
        : 'Goal: ${label ?? 'My Goal'}';
    return 'Check out my progress! ✨\n\n'
        '$subject\n'
        'Status: $elapsedDays of $totalDays days passed\n'
        'Remaining: $daysLeft days ($percentElapsed% done)\n\n'
        'Sent via Goal on Wall 🎯';
  }

  /// Strip H/M/S so date arithmetic is clean.
  static DateTime _dateOnly(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);

  // ── Factory helpers for types that don't need custom dates ───

  /// Year Calendar: always Jan 1 → Dec 31 of the current year.
  factory WallpaperData.yearCalendar({
    WallpaperTheme wallpaperTheme = WallpaperTheme.dots,
    YearLayoutStyle yearLayout = YearLayoutStyle.months,
  }) {
    final now = DateTime.now();
    return WallpaperData(
      calendarType: CalendarType.year,
      wallpaperTheme: wallpaperTheme,
      startDate: DateTime(now.year, 1, 1),
      endDate: DateTime(now.year, 12, 31),
      label: '${now.year}',
      yearLayout: yearLayout,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calendarType': calendarType.index,
      'wallpaperTheme': wallpaperTheme.index,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'label': label,
      'yearLayout': yearLayout.index,
    };
  }

  factory WallpaperData.fromJson(Map<String, dynamic> json) {
    return WallpaperData(
      calendarType: CalendarType.values[json['calendarType'] as int],
      wallpaperTheme: WallpaperTheme.values[json['wallpaperTheme'] as int],
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      label: json['label'] as String?,
      // Older saved configs predate the layout field.
      yearLayout: json['yearLayout'] != null
          ? YearLayoutStyle.values[json['yearLayout'] as int]
          : YearLayoutStyle.months,
    );
  }
}
