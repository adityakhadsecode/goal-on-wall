import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Elevated dark surface card: solid translucent fill + hairline border.
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double blurAmount; // kept for API compat, no longer used

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = AppRadius.xl,
    this.padding,
    this.blurAmount = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}
