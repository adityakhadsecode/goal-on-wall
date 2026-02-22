import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../screens/home_screen.dart';
import '../screens/edit_screen.dart';
import '../screens/life_calendar_screen.dart';
import '../screens/year_calendar_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/goal_calendar_screen.dart';
import '../screens/wallpaper_type_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    EditScreen(),
    SizedBox(), // placeholder for center button
    LifeCalendarScreen(),
    SettingsScreen(),
  ];

  void _onTabTapped(int index) {
    if (index == 2) {
      _showAddSheet();
      return;
    }
    setState(() => _currentIndex = index);
  }

  void _showAddSheet() {
    final palette = context.read<ThemeProvider>().palette;
    showModalBottomSheet(
      context: context,
      backgroundColor: palette.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'CREATE NEW',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3,
                  color: palette.textMuted,
                ),
              ),
              const SizedBox(height: 20),
              _buildAddOption(
                icon: Icons.calendar_view_week_rounded,
                label: 'Year Calendar',
                subtitle: 'Track the current year\'s progress',
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const YearCalendarScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildAddOption(
                icon: Icons.grid_view_rounded,
                label: 'Life Calendar',
                subtitle: 'Visualize your life in weeks',
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _currentIndex = 3);
                },
              ),
              const SizedBox(height: 12),
              _buildAddOption(
                icon: Icons.flag_rounded,
                label: 'Goal Calendar',
                subtitle: 'Countdown to your deadline',
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GoalCalendarScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildAddOption(
                icon: Icons.rocket_launch_rounded,
                label: 'Product Launch',
                subtitle: 'Countdown to your big launch day',
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WallpaperTypeScreen(), // Navigate to type screen first or direct?
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildAddOption(
                icon: Icons.fitness_center_rounded,
                label: 'Fitness Goal',
                subtitle: 'Track your training journey',
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WallpaperTypeScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddOption({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final palette = context.read<ThemeProvider>().palette;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            color: Colors.white.withValues(alpha: 0.03),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: palette.primary.withValues(alpha: 0.2),
                ),
                child: Icon(icon, color: palette.primaryLight, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<ThemeProvider>().palette;

    return Scaffold(
      backgroundColor: palette.deepBackground,
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex == 2 ? 0 : _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNav(palette),
    );
  }

  Widget _buildBottomNav(dynamic palette) {
    return Container(
      decoration: BoxDecoration(
        color: palette.navBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(0, Icons.home_rounded, 'Home'),
              _buildNavItem(1, Icons.eco_rounded, 'Edit'),
              _buildCenterButton(),
              _buildNavItem(3, Icons.grid_view_rounded, 'Life'),
              _buildNavItem(4, Icons.settings_rounded, 'Set'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final palette = context.watch<ThemeProvider>().palette;
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Icon(
                  icon,
                  size: 26,
                  color: isActive ? palette.accent : palette.textMuted,
                ),
                if (isActive)
                  Positioned(
                    bottom: -6,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: palette.accent,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: isActive
                    ? palette.accent
                    : palette.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton() {
    final palette = context.watch<ThemeProvider>().palette;
    return GestureDetector(
      onTap: () => _onTabTapped(2),
      child: Transform.translate(
        offset: const Offset(0, -20),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Color.lerp(palette.cardBackground, palette.primary, 0.3),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 30,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.add_rounded,
            size: 30,
            color: palette.textPrimary,
          ),
        ),
      ),
    );
  }
}
