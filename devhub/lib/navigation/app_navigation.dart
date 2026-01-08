import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../features/editor/screens/code_editor_screen.dart';
import '../features/courses/screens/courses_screen.dart';
import '../features/community/screens/community_screen.dart';
import '../features/news/screens/news_screen.dart';
import '../features/progress/screens/progress_screen.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.code, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Text('DevHub', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => themeProvider.toggleTheme(),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      // Use RepaintBoundary for each screen to prevent full repaints
      body: RepaintBoundary(
        child: IndexedStack(
          index: _currentIndex,
          children: const [
            CodeEditorScreen(),
            CoursesScreen(),
            CommunityScreen(),
            NewsScreen(),
            ProgressScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavBarItem(
              icon: Icons.code,
              label: 'Editor',
              isSelected: _currentIndex == 0,
              onTap: () {
                HapticFeedback.mediumImpact();
                setState(() => _currentIndex = 0);
              },
              isDark: isDark,
            ),
            _NavBarItem(
              icon: Icons.school,
              label: 'Courses',
              isSelected: _currentIndex == 1,
              onTap: () {
                HapticFeedback.mediumImpact();
                setState(() => _currentIndex = 1);
              },
              isDark: isDark,
            ),
            _NavBarItem(
              icon: Icons.people,
              label: 'Community',
              isSelected: _currentIndex == 2,
              onTap: () {
                HapticFeedback.mediumImpact();
                setState(() => _currentIndex = 2);
              },
              isDark: isDark,
            ),
            _NavBarItem(
              icon: Icons.newspaper,
              label: 'News',
              isSelected: _currentIndex == 3,
              onTap: () {
                HapticFeedback.mediumImpact();
                setState(() => _currentIndex = 3);
              },
              isDark: isDark,
            ),
            _NavBarItem(
              icon: Icons.trending_up,
              label: 'Progress',
              isSelected: _currentIndex == 4,
              onTap: () {
                HapticFeedback.mediumImpact();
                setState(() => _currentIndex = 4);
              },
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 8, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? (AppTheme.primaryColor.withOpacity(0.15)) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.elasticOut,
              child: Icon(
                icon,
                color: isSelected 
                    ? AppTheme.primaryColor 
                    : (isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary),
                size: 22,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
