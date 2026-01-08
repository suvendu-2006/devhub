import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_article.dart';

class HackerNewsService {
  static const String _baseUrl = 'https://hacker-news.firebaseio.com/v0';
  
  // Fetch top stories from HackerNews
  Future<List<NewsArticle>> fetchTopStories({int limit = 20}) async {
    try {
      // Get top story IDs with timeout
      final response = await http.get(Uri.parse('$_baseUrl/topstories.json'))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch stories');
      }
      
      final List<dynamic> storyIds = json.decode(response.body);
      final limitedIds = storyIds.take(limit).toList();
      
      // Fetch story details in parallel
      final futures = limitedIds.map((id) => _fetchStory(id));
      final stories = await Future.wait(futures);
      
      // Filter out nulls and non-story items
      return stories.whereType<NewsArticle>().toList();
    } catch (e) {
      // Log error silently in production
      return [];
    }
  }
  
  Future<NewsArticle?> _fetchStory(int id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/item/$id.json'));
      if (response.statusCode != 200) return null;
      
      final data = json.decode(response.body);
      if (data == null || data['type'] != 'story') return null;
      
      // Extract domain from URL
      String source = 'HackerNews';
      String? url = data['url'];
      if (url != null && url.isNotEmpty) {
        try {
          final uri = Uri.parse(url);
          source = uri.host.replaceFirst('www.', '');
        } catch (_) {}
      }
      
      // Determine category based on title/source
      String category = _categorizeStory(data['title'] ?? '', source);
      
      // Calculate time ago
      final timestamp = data['time'] as int?;
      String timeAgo = 'Recently';
      if (timestamp != null) {
        final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
        timeAgo = _formatTimeAgo(date);
      }
      
      return NewsArticle(
        id: id.toString(),
        title: data['title'] ?? 'Untitled',
        summary: 'Posted by ${data['by'] ?? 'anonymous'} • ${data['score'] ?? 0} points • ${data['descendants'] ?? 0} comments',
        source: source,
        category: category,
        publishedAtString: timeAgo,
        url: url ?? 'https://news.ycombinator.com/item?id=$id',
        imageUrl: _getPlaceholderImage(category),
      );
    } catch (e) {
      return null;
    }
  }
  
  String _categorizeStory(String title, String source) {
    final lowerTitle = title.toLowerCase();
    
    if (lowerTitle.contains('ai') || 
        lowerTitle.contains('gpt') || 
        lowerTitle.contains('llm') ||
        lowerTitle.contains('machine learning') ||
        lowerTitle.contains('neural') ||
        lowerTitle.contains('openai') ||
        lowerTitle.contains('anthropic')) {
      return 'AI Research';
    }
    
    if (lowerTitle.contains('startup') || 
        lowerTitle.contains('funding') ||
        lowerTitle.contains('acquired') ||
        lowerTitle.contains('ipo') ||
        lowerTitle.contains('valuation')) {
      return 'Startups';
    }
    
    if (lowerTitle.contains('google') || 
        lowerTitle.contains('apple') ||
        lowerTitle.contains('microsoft') ||
        lowerTitle.contains('amazon') ||
        lowerTitle.contains('meta') ||
        lowerTitle.contains('facebook')) {
      return 'Industry';
    }
    
    return 'All';
  }
  
  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }
  
  String _getPlaceholderImage(String category) {
    // Return category-based gradient colors encoded as a simple identifier
    // We'll use colored containers instead of actual images
    switch (category) {
      case 'AI Research':
        return 'ai';
      case 'Startups':
        return 'startup';
      case 'Industry':
        return 'industry';
      default:
        return 'tech';
    }
  }
}
