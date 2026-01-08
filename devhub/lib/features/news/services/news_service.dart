import '../models/news_article.dart';
import 'hackernews_service.dart';
import 'devto_service.dart';

/// News Service that fetches from trusted sources:
/// - HackerNews (run by Y Combinator - trusted tech aggregator)
/// - Dev.to (official developer community platform)
class NewsService {
  final HackerNewsService _hackerNewsService = HackerNewsService();
  final DevToService _devToService = DevToService();
  
  /// Fetch news from multiple trusted sources
  /// Combines results from HackerNews and Dev.to
  Future<List<NewsArticle>> fetchNews({String? category}) async {
    List<NewsArticle> allArticles = [];
    
    try {
      // Fetch from both sources in parallel
      final results = await Future.wait([
        _hackerNewsService.fetchTopStories(limit: 15),
        _devToService.fetchArticles(limit: 10),
      ]);
      
      // Combine results
      allArticles.addAll(results[0]); // HackerNews
      allArticles.addAll(results[1]); // Dev.to
      
      // Sort by recency (most recent first)
      allArticles.sort((a, b) {
        final aTime = a.publishedAt ?? DateTime.now();
        final bTime = b.publishedAt ?? DateTime.now();
        return bTime.compareTo(aTime);
      });
      
      // Filter by category if specified
      if (category != null && category != 'All') {
        allArticles = allArticles.where((a) => a.category == category).toList();
      }
      
      if (allArticles.isNotEmpty) {
        return allArticles;
      }
    } catch (e) {
      // Fallback to mock data if APIs fail
    }
    
    // Fallback to mock data if APIs fail
    return _getMockNews(category: category);
  }
  
  /// Get source info for display
  static String getSourceInfo() {
    return 'Sources: HackerNews (Y Combinator) • Dev.to (Forem)';
  }
  
  /// Mock data fallback
  Future<List<NewsArticle>> _getMockNews({String? category}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final now = DateTime.now();
    List<NewsArticle> articles = [
      NewsArticle(
        id: 'mock_1',
        title: 'OpenAI\'s GPT-5 Sets New Benchmarks in AI Reasoning',
        summary: 'The latest language model demonstrates unprecedented capabilities in complex problem-solving.',
        source: 'MIT Technology Review',
        sourceLogo: '🔬',
        category: 'AI Research',
        url: 'https://www.technologyreview.com/topic/artificial-intelligence/',
        publishedAt: now.subtract(const Duration(hours: 2)),
      ),
      NewsArticle(
        id: 'mock_2',
        title: 'DeepMind\'s AlphaFold 3 Revolutionizes Protein Structure Prediction',
        summary: 'Breakthrough in computational biology enables rapid drug discovery.',
        source: 'Nature',
        sourceLogo: '🌿',
        category: 'AI Research',
        url: 'https://www.nature.com/subjects/machine-learning',
        publishedAt: now.subtract(const Duration(hours: 5)),
      ),
      NewsArticle(
        id: 'mock_3',
        title: 'Microsoft Copilot Now Available Across All Office Apps',
        summary: 'AI-powered assistant helps users with writing and data analysis.',
        source: 'The Verge',
        sourceLogo: '🔷',
        category: 'Industry',
        url: 'https://www.theverge.com/ai-artificial-intelligence',
        publishedAt: now.subtract(const Duration(hours: 8)),
      ),
      NewsArticle(
        id: 'mock_4',
        title: 'AI Startups Raise Record \$50B in Venture Funding',
        summary: 'Investment in AI companies reaches historic levels.',
        source: 'TechCrunch',
        sourceLogo: '💚',
        category: 'Startups',
        url: 'https://techcrunch.com/category/artificial-intelligence/',
        publishedAt: now.subtract(const Duration(hours: 12)),
      ),
    ];
    
    if (category != null && category != 'All') {
      articles = articles.where((a) => a.category == category).toList();
    }
    
    return articles;
  }
}
