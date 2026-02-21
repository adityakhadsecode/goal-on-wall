import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class OrganicBackground extends StatelessWidget {
  final Widget child;

  const OrganicBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<ThemeProvider>().palette;
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0.6, -0.6),
          radius: 1.2,
          colors: [
            palette.surfaceColor,
            palette.cardBackground,
            palette.deepBackground,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Decorative blur circles
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: -MediaQuery.of(context).size.width * 0.2,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: palette.primary.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.2,
            right: -MediaQuery.of(context).size.width * 0.2,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: palette.accent.withValues(alpha: 0.05),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
