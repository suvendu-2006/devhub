import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/url_helper.dart';
import '../models/news_article.dart';

class NewsCard extends StatelessWidget {
  final NewsArticle article;

  const NewsCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    
    // Wrap in RepaintBoundary for better scroll performance
    return RepaintBoundary(
      child: GestureDetector(
        onTap: () => UrlHelper.openUrl(article.url),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.cardColor : Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // News Image - simplified, no shadows
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: Stack(
                  children: [
                    Image.network(
                      article.imageUrl ?? '',
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      // Use cacheWidth for better performance
                      cacheHeight: 240,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          height: 120,
                          color: isDark ? AppTheme.surfaceColor : Colors.grey.shade200,
                          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        );
                      },
                      errorBuilder: (_, __, ___) => Container(
                        height: 120,
                        color: isDark ? AppTheme.surfaceColor : Colors.grey.shade200,
                        child: const Center(child: Icon(Icons.newspaper, size: 32, color: Colors.grey)),
                      ),
                    ),
                    // Source badge
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(article.source, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w500)),
                      ),
                    ),
                    if (article.isBreaking)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(color: AppTheme.errorColor, borderRadius: BorderRadius.circular(3)),
                          child: const Text('NEW', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: TextStyle(
                        color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      article.summary,
                      style: TextStyle(
                        color: isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                        fontSize: 11,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(article.category, style: TextStyle(color: AppTheme.primaryColor, fontSize: 9)),
                        ),
                        const SizedBox(width: 6),
                        Text(article.timeAgo, style: TextStyle(color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary, fontSize: 9)),
                        const Spacer(),
                        Icon(Icons.open_in_new, color: AppTheme.primaryColor, size: 12),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
