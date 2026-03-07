import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../providers/wallpaper_provider.dart';
import '../models/wallpaper_config.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import 'life_customize_screen.dart';
import 'year_customize_screen.dart';
import 'goal_customize_screen.dart';
import 'product_launch_customize_screen.dart';
import 'fitness_goal_customize_screen.dart';


class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  bool _isSearching = false;
  String _searchQuery = '';
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _navigateToCustomize(BuildContext context, WallpaperData data) {
    Widget screen;
    switch (data.calendarType) {
      case CalendarType.life:
        screen = LifeCustomizeScreen(
            wallpaperTheme: data.wallpaperTheme, initialData: data);
        break;
      case CalendarType.year:
        screen = YearCustomizeScreen(
            wallpaperTheme: data.wallpaperTheme, initialData: data);
        break;
      case CalendarType.goal:
        screen = GoalCustomizeScreen(
            wallpaperTheme: data.wallpaperTheme, initialData: data);
        break;
      case CalendarType.productLaunch:
        screen = ProductLaunchCustomizeScreen(
            wallpaperTheme: data.wallpaperTheme, initialData: data);
        break;
      case CalendarType.fitnessGoal:
        screen = FitnessGoalCustomizeScreen(
            wallpaperTheme: data.wallpaperTheme, initialData: data);
        break;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  String _getTitleForType(CalendarType type) {
    switch (type) {
      case CalendarType.life: return 'Life Calendar';
      case CalendarType.year: return 'Year Calendar';
      case CalendarType.goal: return 'Goal Calendar';
      case CalendarType.productLaunch: return 'Product Launch';
      case CalendarType.fitnessGoal: return 'Fitness Goal';
    }
  }

  IconData _getIconForType(CalendarType type) {
    switch (type) {
      case CalendarType.life: return Icons.grid_view_rounded;
      case CalendarType.year: return Icons.calendar_view_day_rounded;
      case CalendarType.goal: return Icons.flag_rounded;
      case CalendarType.productLaunch: return Icons.rocket_launch_rounded;
      case CalendarType.fitnessGoal: return Icons.fitness_center_rounded;
    }
  }

  bool _matchesSearch(WallpaperData data) {
    if (_searchQuery.isEmpty) return true;
    final query = _searchQuery.toLowerCase();
    final title = (data.label ?? _getTitleForType(data.calendarType)).toLowerCase();
    final caption = data.caption.toLowerCase();
    final typeName = _getTitleForType(data.calendarType).toLowerCase();
    return title.contains(query) || caption.contains(query) || typeName.contains(query);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<ThemeProvider>().palette;

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
                  if (!_isSearching) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Calendars',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: palette.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'MANAGE & EDIT',
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
                  if (_isSearching)
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onChanged: (val) => setState(() => _searchQuery = val),
                        style: TextStyle(
                          color: palette.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search calendars...',
                          hintStyle: TextStyle(
                            color: palette.textMuted,
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 4,
                          ),
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_isSearching) {
                          _isSearching = false;
                          _searchQuery = '';
                          _searchController.clear();
                        } else {
                          _isSearching = true;
                          // Focus the search field after it builds
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _searchFocusNode.requestFocus();
                          });
                        }
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isSearching
                            ? palette.primary.withValues(alpha: 0.3)
                            : Colors.white.withValues(alpha: 0.05),
                        border: Border.all(
                          color: _isSearching
                              ? palette.primaryLight.withValues(alpha: 0.3)
                              : Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      child: Icon(
                        _isSearching ? Icons.close_rounded : Icons.search_rounded,
                        color: _isSearching ? palette.primaryLight : palette.textSecondary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Calendar cards
            Expanded(
              child: Consumer<WallpaperProvider>(
                builder: (context, provider, child) {
                  final savedWallpapers = provider.savedWallpapers;
                  
                  if (savedWallpapers.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history_rounded,
                            size: 64,
                            color: palette.textMuted.withValues(alpha: 0.2),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No saved wallpapers yet',
                            style: TextStyle(
                              fontSize: 16,
                              color: palette.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create one to see it here',
                            style: TextStyle(
                              fontSize: 12,
                              color: palette.textMuted.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final filtered = savedWallpapers.where(_matchesSearch).toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: palette.textMuted.withValues(alpha: 0.2),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No matching calendars',
                            style: TextStyle(
                              fontSize: 16,
                              color: palette.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final data = filtered[index];
                      return _buildCalendarCard(
                        context,
                        icon: _getIconForType(data.calendarType),
                        title: data.label ?? _getTitleForType(data.calendarType),
                        subtitle: data.caption,
                        progress: data.progress,
                        palette: palette,
                        onTap: () => _navigateToCustomize(context, data),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required double progress,
    required dynamic palette,
    required VoidCallback onTap,
  }) {
    return GlassCard(
      borderRadius: 20,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: palette.primary.withValues(alpha: 0.2),
                  ),
                  child: Icon(icon, color: palette.primaryLight, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: palette.textMuted,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor:
                              Colors.white.withValues(alpha: 0.08),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            palette.primaryLight,
                          ),
                          minHeight: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    Text(
                      '${(progress * 100).round()}%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: palette.primaryLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  color: palette.textMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
