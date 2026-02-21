import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import '../services/user_prefs.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  DateTime? _savedBirthDate;

  @override
  void initState() {
    super.initState();
    _loadBirthDate();
  }

  Future<void> _loadBirthDate() async {
    final date = await UserPrefs.getBirthDate();
    if (mounted) setState(() => _savedBirthDate = date);
  }

  String get _birthDateLabel {
    if (_savedBirthDate == null) return 'Not set';
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[_savedBirthDate!.month - 1]} ${_savedBirthDate!.day}, ${_savedBirthDate!.year}';
  }

  void _showBirthDateSheet(AppColorPalette palette) {
    final initial = _savedBirthDate;
    final dayCtrl = TextEditingController(
      text: initial != null ? initial.day.toString().padLeft(2, '0') : '',
    );
    final monthCtrl = TextEditingController(
      text: initial != null ? initial.month.toString().padLeft(2, '0') : '',
    );
    final yearCtrl = TextEditingController(
      text: initial != null ? initial.year.toString() : '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: _BirthDateSheet(
            palette: palette,
            dayCtrl: dayCtrl,
            monthCtrl: monthCtrl,
            yearCtrl: yearCtrl,
            onSave: (date) async {
              await UserPrefs.saveBirthDate(date);
              if (mounted) setState(() => _savedBirthDate = date);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final palette = themeProvider.palette;

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
                        'Settings',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: palette.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'CUSTOMIZE YOUR EXPERIENCE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                          color: palette.textMuted,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  // Theme section
                  Text(
                    'THEME',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: palette.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GlassCard(
                    borderRadius: 20,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: AppThemes.allThemes.map((theme) {
                        final isSelected = palette.name == theme.name;
                        return _buildThemeOption(
                          context,
                          theme: theme,
                          isSelected: isSelected,
                          onTap: () => themeProvider.setPalette(theme),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Wallpaper section
                  Text(
                    'WALLPAPER',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: palette.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GlassCard(
                    borderRadius: 20,
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        _buildSettingsToggle(
                          'Auto-set Wallpaper',
                          'Automatically update wallpaper daily',
                          Icons.wallpaper_rounded,
                          true,
                          palette,
                          (val) {},
                        ),
                        Divider(
                          color: Colors.white.withValues(alpha: 0.05),
                          height: 1,
                        ),
                        _buildSettingsItem(
                          'Wallpaper Style',
                          'Dot grid with progress',
                          Icons.style_rounded,
                          palette,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Life calendar section
                  Text(
                    'LIFE CALENDAR',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: palette.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GlassCard(
                    borderRadius: 20,
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        _buildTappableSettingsItem(
                          'Birth Date',
                          _birthDateLabel,
                          Icons.cake_rounded,
                          palette,
                          onTap: () => _showBirthDateSheet(palette),
                        ),
                        Divider(
                          color: Colors.white.withValues(alpha: 0.05),
                          height: 1,
                        ),
                        _buildSettingsItem(
                          'Life Expectancy',
                          '80 years',
                          Icons.timeline_rounded,
                          palette,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // About section
                  Text(
                    'ABOUT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: palette.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GlassCard(
                    borderRadius: 20,
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        _buildSettingsItem(
                          'Version',
                          '1.0.0',
                          Icons.info_outline_rounded,
                          palette,
                        ),
                        Divider(
                          color: Colors.white.withValues(alpha: 0.05),
                          height: 1,
                        ),
                        _buildSettingsItem(
                          'Rate App',
                          'Share your feedback',
                          Icons.star_outline_rounded,
                          palette,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required AppColorPalette theme,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final palette = context.read<ThemeProvider>().palette;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [theme.primary, theme.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: isSelected
                      ? Border.all(color: theme.accent, width: 2)
                      : null,
                ),
                child: isSelected
                    ? Icon(Icons.check_rounded, color: Colors.white, size: 18)
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      theme.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color:
                            isSelected ? theme.primaryLight : palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        _colorDot(theme.primary),
                        _colorDot(theme.primaryLight),
                        _colorDot(theme.accent),
                        _colorDot(theme.deepBackground),
                      ],
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: theme.primaryLight.withValues(alpha: 0.15),
                  ),
                  child: Text(
                    'ACTIVE',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: theme.primaryLight,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _colorDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsToggle(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    dynamic palette,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: palette.primary.withValues(alpha: 0.2),
            ),
            child: Icon(icon, color: palette.primaryLight, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: palette.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: palette.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            thumbColor: WidgetStateProperty.all(palette.primaryLight),
            trackColor: WidgetStateProperty.resolveWith((states) =>
                states.contains(WidgetState.selected)
                    ? palette.primary
                    : Colors.white.withValues(alpha: 0.1)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    String title,
    String subtitle,
    IconData icon,
    dynamic palette,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: palette.primary.withValues(alpha: 0.2),
            ),
            child: Icon(icon, color: palette.primaryLight, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: palette.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: palette.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: palette.textMuted,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildTappableSettingsItem(
    String title,
    String subtitle,
    IconData icon,
    dynamic palette, {
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: palette.primary.withValues(alpha: 0.2),
                ),
                child: Icon(icon, color: palette.primaryLight, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: palette.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 10,
                        color: subtitle == 'Not set'
                            ? palette.primaryLight
                            : palette.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.edit_rounded,
                color: palette.primaryLight,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Birth Date Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _BirthDateSheet extends StatefulWidget {
  const _BirthDateSheet({
    required this.palette,
    required this.dayCtrl,
    required this.monthCtrl,
    required this.yearCtrl,
    required this.onSave,
  });

  final AppColorPalette palette;
  final TextEditingController dayCtrl;
  final TextEditingController monthCtrl;
  final TextEditingController yearCtrl;
  final Future<void> Function(DateTime) onSave;

  @override
  State<_BirthDateSheet> createState() => _BirthDateSheetState();
}

class _BirthDateSheetState extends State<_BirthDateSheet> {
  bool _saving = false;

  bool get _isComplete =>
      widget.dayCtrl.text.length == 2 &&
      widget.monthCtrl.text.length == 2 &&
      widget.yearCtrl.text.length == 4;

  int get _maxDay {
    final y = int.tryParse(widget.yearCtrl.text) ?? DateTime.now().year;
    final m = (int.tryParse(widget.monthCtrl.text) ?? 1).clamp(1, 12);
    return DateTime(y, m + 1, 0).day;
  }

  Future<void> _save() async {
    if (!_isComplete) return;
    setState(() => _saving = true);
    final date = DateTime(
      int.parse(widget.yearCtrl.text),
      int.parse(widget.monthCtrl.text),
      int.parse(widget.dayCtrl.text),
    );
    await widget.onSave(date);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.palette;
    return Container(
      decoration: BoxDecoration(
        color: p.cardBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Row(
            children: [
              Icon(Icons.cake_rounded, color: p.primaryLight, size: 22),
              const SizedBox(width: 10),
              Text(
                'Your Birthdate',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: p.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Saved and used automatically in Life Calendar',
            style: TextStyle(fontSize: 12, color: p.textMuted),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _SheetDateField(
                  controller: widget.dayCtrl,
                  hint: 'DD',
                  label: 'Day',
                  maxLength: 2,
                  maxValue: _maxDay,
                  palette: p,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SheetDateField(
                  controller: widget.monthCtrl,
                  hint: 'MM',
                  label: 'Month',
                  maxLength: 2,
                  maxValue: 12,
                  palette: p,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: _SheetDateField(
                  controller: widget.yearCtrl,
                  hint: 'YYYY',
                  label: 'Year',
                  maxLength: 4,
                  maxValue: DateTime.now().year,
                  minValue: 1900,
                  palette: p,
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _isComplete && !_saving ? _save : null,
              style: FilledButton.styleFrom(
                backgroundColor: p.primaryLight,
                disabledBackgroundColor: p.primaryLight.withValues(alpha: 0.3),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: _saving
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text(
                      'Save Birthdate',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// Simple themed text field for the bottom sheet
class _SheetDateField extends StatelessWidget {
  const _SheetDateField({
    required this.controller,
    required this.hint,
    required this.label,
    required this.maxLength,
    required this.maxValue,
    required this.palette,
    required this.onChanged,
    this.minValue,
  });

  final TextEditingController controller;
  final String hint;
  final String label;
  final int maxLength;
  final int maxValue;
  final int? minValue;
  final AppColorPalette palette;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 10,
                color: palette.textMuted,
                letterSpacing: 1,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          maxLength: maxLength,
          onChanged: (val) {
            final n = int.tryParse(val);
            if (n != null) {
              final isComplete = val.length == maxLength;
              final isTooHigh = n > maxValue;

              if (isTooHigh || isComplete) {
                final clamped = n.clamp(minValue ?? 1, maxValue);
                final s = maxLength == 4
                    ? clamped.toString()
                    : clamped.toString().padLeft(2, '0');

                if (s != val) {
                  controller.value = TextEditingValue(
                    text: s,
                    selection: TextSelection.collapsed(offset: s.length),
                  );
                }
              }
            }
            onChanged(controller.text);
          },
          style: TextStyle(
            color: palette.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: palette.textMuted, fontSize: 14),
            counterText: '',
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: palette.primaryLight, width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          ),
        ),
      ],
    );
  }
}
