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
          child,
        ],
      ),
    );
  }
}
