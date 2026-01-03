import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool isDark;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.2),
                    AppTheme.secondaryColor.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Pre-configured empty states
class NoCoursesFound extends StatelessWidget {
  final bool isDark;
  final VoidCallback? onReset;
  
  const NoCoursesFound({super.key, required this.isDark, this.onReset});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.school_outlined,
      title: 'No Courses Found',
      message: 'No courses match your current filter.\nTry selecting a different category.',
      actionLabel: onReset != null ? 'Reset Filter' : null,
      onAction: onReset,
      isDark: isDark,
    );
  }
}

class NoNewsFound extends StatelessWidget {
  final bool isDark;
  final VoidCallback? onRefresh;
  
  const NoNewsFound({super.key, required this.isDark, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.newspaper_outlined,
      title: 'No News Available',
      message: 'Unable to load news articles.\nPlease check your connection and try again.',
      actionLabel: 'Refresh',
      onAction: onRefresh,
      isDark: isDark,
    );
  }
}

class NoBookmarks extends StatelessWidget {
  final bool isDark;
  
  const NoBookmarks({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.bookmark_outline,
      title: 'No Bookmarks Yet',
      message: 'Save courses and articles you want to revisit later by tapping the bookmark icon.',
      isDark: isDark,
    );
  }
}
