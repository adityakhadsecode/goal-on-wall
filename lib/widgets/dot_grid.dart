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
        return Wrap(
          spacing: dotSpacing,
          runSpacing: dotSpacing,
          children: List.generate(totalDots, (index) {
            final isCompleted = index < completedDots;
            return Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? palette.primaryLight
                    : Colors.white.withValues(alpha: 0.08),
                boxShadow: isCompleted
                    ? [
                        BoxShadow(
                          color: (palette.primaryLight)
                              .withValues(alpha: 0.3),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
            );
          }),
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
              Wrap(
                spacing: dotSpacing,
                runSpacing: dotSpacing,
                children: List.generate(groupSize, (i) {
                  final currentDot = startIndex + i;
                  final isCompleted = currentDot < completedDots;
                  return Container(
                    width: dotSize,
                    height: dotSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? palette.primaryLight
                          : Colors.white.withValues(alpha: 0.08),
                      boxShadow: isCompleted
                          ? [
                              BoxShadow(
                                color: (palette.primaryLight)
                                    .withValues(alpha: 0.3),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ]
                          : null,
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      }),
    );
  }
}
