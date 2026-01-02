import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../models/course.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    
    // Wrap in RepaintBoundary for better scroll performance
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
              child: Row(
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
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 11, color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary),
                            const SizedBox(width: 3),
                            Text(course.duration, style: TextStyle(color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary, fontSize: 10)),
                            const SizedBox(width: 10),
                            Icon(Icons.signal_cellular_alt, size: 11, color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary),
                            const SizedBox(width: 3),
                            Text(course.level, style: TextStyle(color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary, fontSize: 10)),
                          ],
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
                  const SizedBox(width: 6),
                  Icon(Icons.arrow_forward_ios, color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary, size: 14),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
