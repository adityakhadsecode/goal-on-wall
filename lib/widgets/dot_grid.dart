import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class DotGrid extends StatelessWidget {
  final int totalDots;
  final int completedDots;
  final double dotSize;
  final double dotSpacing;
  final int? dotsPerRow;
  final List<String>? groupLabels;
  final List<int>? groupSizes;

  const DotGrid({
    super.key,
    required this.totalDots,
    required this.completedDots,
    this.dotSize = 6,
    this.dotSpacing = 3,
    this.dotsPerRow,
    this.groupLabels,
    this.groupSizes,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<ThemeProvider>().palette;

    if (groupLabels != null && groupSizes != null) {
      return _buildGroupedGrid(palette);
    }
    return _buildFlatGrid(palette);
  }

  Widget _buildFlatGrid(dynamic palette) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = (constraints.maxWidth / (dotSize + dotSpacing)).floor();
        final rows = (totalDots / cols).ceil();
        final gridHeight = rows * (dotSize + dotSpacing);
        return SizedBox(
          height: gridHeight,
          child: CustomPaint(
            size: Size(constraints.maxWidth, gridHeight),
            painter: _DotGridPainter(
              totalDots: totalDots,
              completedDots: completedDots,
              dotSize: dotSize,
              dotSpacing: dotSpacing,
              cols: cols,
              completedColor: palette.primaryLight as Color,
              emptyColor: Colors.white.withValues(alpha: 0.08),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGroupedGrid(dynamic palette) {
    int dotIndex = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(groupLabels!.length, (groupIndex) {
        final groupSize = groupSizes![groupIndex];
        final startIndex = dotIndex;
        dotIndex += groupSize;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  groupLabels![groupIndex],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: palette.textMuted,
                  ),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  final cols =
                      (constraints.maxWidth / (dotSize + dotSpacing)).floor();
                  final rows = (groupSize / cols).ceil();
                  final gridHeight = rows * (dotSize + dotSpacing);
                  return SizedBox(
                    height: gridHeight,
                    child: CustomPaint(
                      size: Size(constraints.maxWidth, gridHeight),
                      painter: _DotGridPainter(
                        totalDots: groupSize,
                        completedDots:
                            (completedDots - startIndex).clamp(0, groupSize),
                        dotSize: dotSize,
                        dotSpacing: dotSpacing,
                        cols: cols,
                        completedColor: palette.primaryLight as Color,
                        emptyColor: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  final int totalDots;
  final int completedDots;
  final double dotSize;
  final double dotSpacing;
  final int cols;
  final Color completedColor;
  final Color emptyColor;

  _DotGridPainter({
    required this.totalDots,
    required this.completedDots,
    required this.dotSize,
    required this.dotSpacing,
    required this.cols,
    required this.completedColor,
    required this.emptyColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final completedPaint = Paint()..color = completedColor;
    final emptyPaint = Paint()..color = emptyColor;
    final radius = dotSize / 2;
    final cellSize = dotSize + dotSpacing;

    for (int i = 0; i < totalDots; i++) {
      final col = i % cols;
      final row = i ~/ cols;
      final x = col * cellSize + radius;
      final y = row * cellSize + radius;
      canvas.drawCircle(
        Offset(x, y),
        radius,
        i < completedDots ? completedPaint : emptyPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DotGridPainter old) =>
      old.totalDots != totalDots ||
      old.completedDots != completedDots ||
      old.completedColor != completedColor;
}
