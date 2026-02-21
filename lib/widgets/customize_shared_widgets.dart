import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ══════════════════════════════════════════════════════════════
// SHARED WIDGETS FOR ALL CUSTOMIZATION SCREENS
// ══════════════════════════════════════════════════════════════

/// Breadcrumb navigation row, e.g. Life Calendar › The Flow › Customize
class CustomizeBreadcrumb extends StatelessWidget {
  const CustomizeBreadcrumb(
      {super.key, required this.parts, required this.palette});

  final List<String> parts;
  final AppColorPalette palette;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    for (int i = 0; i < parts.length; i++) {
      if (i > 0) {
        children.add(Icon(Icons.chevron_right_rounded,
            size: 14, color: palette.textMuted));
      }
      children.add(Text(
        parts[i],
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: i == parts.length - 1 ? palette.textMuted : palette.primaryLight,
        ),
      ));
    }
    return Row(children: children);
  }
}

/// DD / MM / YYYY numeric input field with a labelled header.
class DateInputField extends StatelessWidget {
  const DateInputField({
    super.key,
    required this.controller,
    required this.hint,
    required this.label,
    required this.maxLength,
    required this.palette,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final String label;
  final int maxLength;
  final AppColorPalette palette;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
            color: palette.textMuted,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white.withValues(alpha: 0.05),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            maxLength: maxLength,
            textAlign: TextAlign.center,
            onChanged: onChanged,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
              letterSpacing: 1.5,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 16,
                color: palette.textMuted,
                fontWeight: FontWeight.w400,
              ),
              counterText: '',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 8,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The primary "Generate Wallpaper" CTA button.
class GenerateWallpaperButton extends StatelessWidget {
  const GenerateWallpaperButton({
    super.key,
    required this.enabled,
    required this.palette,
    required this.onTap,
  });

  final bool enabled;
  final AppColorPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: enabled ? 1.0 : 0.45,
      duration: const Duration(milliseconds: 200),
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              palette.primary,
              palette.primaryLight,
              palette.accent,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: palette.primaryLight.withValues(alpha: 0.30),
                    blurRadius: 24,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: enabled ? onTap : null,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
                SizedBox(width: 10),
                Text(
                  'Generate Wallpaper',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.3,
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

/// Icon + title row header used inside GlassCard sections.
class CardSectionHeader extends StatelessWidget {
  const CardSectionHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.palette,
  });

  final IconData icon;
  final String title;
  final AppColorPalette palette;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: palette.primary.withValues(alpha: 0.25),
          ),
          child: Icon(icon, color: palette.primaryLight, size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: palette.textPrimary,
          ),
        ),
      ],
    );
  }
}
