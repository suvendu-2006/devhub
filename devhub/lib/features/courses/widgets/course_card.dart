import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/bookmark_service.dart';
import '../models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final bookmarkService = context.watch<BookmarkService>();
    final isBookmarked = bookmarkService.isCourseBookmarked(course.id);
    
    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _launchUrl(course.url),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Provider logo
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.surfaceColor : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(course.providerLogo, style: const TextStyle(fontSize: 20)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.title,
                              style: TextStyle(
                                color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              course.provider,
                              style: TextStyle(color: AppTheme.primaryColor, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      if (course.isFree)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.successColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('FREE', style: TextStyle(color: AppTheme.successColor, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.description,
                    style: TextStyle(
                      color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // Duration
                      _buildInfoChip(Icons.access_time, course.duration, isDark),
                      const SizedBox(width: 8),
                      // Level
                      _buildInfoChip(Icons.signal_cellular_alt, course.level, isDark),
                      const Spacer(),
                      // Bookmark button
                      GestureDetector(
                        onTap: () => bookmarkService.toggleCourseBookmark(course.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isBookmarked 
                                ? AppTheme.primaryColor.withOpacity(0.15)
                                : (isDark ? AppTheme.surfaceColor : Colors.grey.shade100),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                            color: isBookmarked ? AppTheme.primaryColor : (isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary),
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Share button
                      GestureDetector(
                        onTap: () => _shareCourse(),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.surfaceColor : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.share_outlined,
                            color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Open link
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.open_in_new, color: Colors.white, size: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surfaceColor : const Color(0xFFE0E0E8), // Darker for light mode
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: isDark ? AppTheme.textMuted : const Color(0xFF4A4A5A)),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: isDark ? AppTheme.textMuted : const Color(0xFF4A4A5A), fontSize: 10, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _shareCourse() {
    Share.share(
      '${course.title}\n\nCheck out this course on ${course.provider}!\n${course.url}',
      subject: course.title,
    );
  }
}
