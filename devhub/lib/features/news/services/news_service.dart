import 'dart:math';
import '../models/news_article.dart';
import 'hackernews_service.dart';

class NewsService {
  final HackerNewsService _hackerNewsService = HackerNewsService();
  final Random _random = Random();
  
  // Try HackerNews API first, fallback to mock data
  Future<List<NewsArticle>> fetchNews({String? category}) async {
    try {
      // Fetch from HackerNews
      final articles = await _hackerNewsService.fetchTopStories(limit: 25);
      
      if (articles.isNotEmpty) {
        // Filter by category if specified
        if (category != null && category != 'All') {
          return articles.where((a) => a.category == category).toList();
        }
        return articles;
      }
    } catch (e) {
      print('HackerNews fetch failed, using mock data: $e');
    }
    
    // Fallback to mock data
    return _getMockNews(category: category);
  }
  
  // Mock data fallback
  Future<List<NewsArticle>> _getMockNews({String? category}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final now = DateTime.now();
    List<NewsArticle> articles = [
      NewsArticle(
        id: '1',
        title: 'OpenAI\'s GPT-5 Sets New Benchmarks in AI Reasoning',
        summary: 'The latest language model demonstrates unprecedented capabilities in complex problem-solving.',
        source: 'MIT Technology Review',
        category: 'AI Research',
        url: 'https://www.technologyreview.com/topic/artificial-intelligence/',
        publishedAt: now.subtract(const Duration(hours: 2)),
      ),
      NewsArticle(
        id: '2',
        title: 'DeepMind\'s AlphaFold 3 Revolutionizes Protein Structure Prediction',
        summary: 'Breakthrough in computational biology enables rapid drug discovery.',
        source: 'Nature',
        category: 'AI Research',
        url: 'https://www.nature.com/subjects/machine-learning',
        publishedAt: now.subtract(const Duration(hours: 5)),
      ),
      NewsArticle(
        id: '3',
        title: 'Microsoft Copilot Now Available Across All Office Apps',
        summary: 'AI-powered assistant helps users with writing and data analysis.',
        source: 'The Verge',
        category: 'Industry',
        url: 'https://www.theverge.com/ai-artificial-intelligence',
        publishedAt: now.subtract(const Duration(hours: 8)),
      ),
      NewsArticle(
        id: '4',
        title: 'AI Startups Raise Record \$50B in Venture Funding',
        summary: 'Investment in AI companies reaches historic levels.',
        source: 'TechCrunch',
        category: 'Startups',
        url: 'https://techcrunch.com/category/artificial-intelligence/',
        publishedAt: now.subtract(const Duration(hours: 12)),
      ),
      NewsArticle(
        id: '5',
        title: 'European Union Finalizes Comprehensive AI Regulation',
        summary: 'Landmark legislation establishes global standards for AI.',
        source: 'Reuters',
        category: 'Industry',
        url: 'https://www.reuters.com/technology/artificial-intelligence/',
        publishedAt: now.subtract(const Duration(days: 1)),
      ),
      NewsArticle(
        id: '6',
        title: 'Perplexity AI Raises \$500M at \$9B Valuation',
        summary: 'AI search startup continues rapid growth.',
        source: 'VentureBeat',
        category: 'Startups',
        url: 'https://venturebeat.com/ai/',
        publishedAt: now.subtract(const Duration(days: 2)),
      ),
    ];
    
    if (category != null && category != 'All') {
      articles = articles.where((a) => a.category == category).toList();
    }
    
    return articles;
  }
}
