import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/url_helper.dart';
import '../../../core/services/bookmark_service.dart';
import '../models/news_article.dart';

class NewsCard extends StatelessWidget {
  final NewsArticle article;

  const NewsCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final bookmarkService = context.watch<BookmarkService>();
    final isBookmarked = bookmarkService.isArticleBookmarked(article.id);
    
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
              // News Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: Stack(
                  children: [
                    _buildImage(isDark),
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
                    const SizedBox(height: 8),
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
                        // Bookmark button
                        GestureDetector(
                          onTap: () => bookmarkService.toggleArticleBookmark(article.id),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isBookmarked 
                                  ? AppTheme.primaryColor.withOpacity(0.15)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                              color: isBookmarked ? AppTheme.primaryColor : (isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary),
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Share button
                        GestureDetector(
                          onTap: () => _shareArticle(),
                          child: Icon(
                            Icons.share_outlined,
                            color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.open_in_new, color: AppTheme.primaryColor, size: 14),
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

  Widget _buildImage(bool isDark) {
    // Check if it's a placeholder image from HackerNews
    if (article.imageUrl == null || 
        article.imageUrl == 'ai' || 
        article.imageUrl == 'startup' || 
        article.imageUrl == 'industry' || 
        article.imageUrl == 'tech') {
      return _buildGradientPlaceholder(isDark);
    }
    
    // Try to load actual image
    return Image.network(
      article.imageUrl!,
      height: 120,
      width: double.infinity,
      fit: BoxFit.cover,
      cacheHeight: 240,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          height: 120,
          color: isDark ? AppTheme.surfaceColor : Colors.grey.shade200,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
      errorBuilder: (_, __, ___) => _buildGradientPlaceholder(isDark),
    );
  }

  Widget _buildGradientPlaceholder(bool isDark) {
    final gradients = {
      'ai': [const Color(0xFF6C63FF), const Color(0xFF00D9FF)],
      'startup': [const Color(0xFF10B981), const Color(0xFF34D399)],
      'industry': [const Color(0xFFF59E0B), const Color(0xFFFBBF24)],
      'tech': [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
    };
    
    final category = article.imageUrl ?? 'tech';
    final colors = gradients[category] ?? gradients['tech']!;
    
    final icons = {
      'ai': Icons.psychology,
      'startup': Icons.rocket_launch,
      'industry': Icons.business,
      'tech': Icons.code,
    };
    
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          icons[category] ?? Icons.article,
          size: 40,
          color: Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }

  void _shareArticle() {
    Share.share(
      '${article.title}\n\nRead more: ${article.url}',
      subject: article.title,
    );
  }
}
