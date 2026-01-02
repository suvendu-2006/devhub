import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../models/news_article.dart';
import '../services/news_service.dart';
import '../widgets/news_card.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsService _newsService = NewsService();
  String _selectedCategory = 'All';
  List<NewsArticle> _articles = [];
  bool _isLoading = true;
  
  final List<String> _categories = ['All', 'AI Research', 'Industry', 'Startups'];

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() => _isLoading = true);
    
    final articles = await _newsService.fetchNews(
      category: _selectedCategory == 'All' ? null : _selectedCategory,
    );
    
    if (mounted) {
      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    
    return Container(
      color: isDark ? AppTheme.backgroundColor : AppTheme.lightBackground,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.newspaper_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AI News', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary)),
                      Text('Trusted sources • Tap to read', style: TextStyle(color: isDark ? AppTheme.textMuted : AppTheme.lightTextSecondary, fontSize: 11)),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _loadNews,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _isLoading
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            
            // Category filter - simple, no animations
            SizedBox(
              height: 34,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const ClampingScrollPhysics(),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedCategory = category);
                        _loadNews();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          gradient: isSelected ? AppTheme.primaryGradient : null,
                          color: isSelected ? null : (isDark ? AppTheme.surfaceColor : Colors.white),
                          borderRadius: BorderRadius.circular(17),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : (isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary),
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 12),
            
            // News list
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const ClampingScrollPhysics(),
                      itemCount: _articles.length,
                      itemBuilder: (context, index) => NewsCard(article: _articles[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
