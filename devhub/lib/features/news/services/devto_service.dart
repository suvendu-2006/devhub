import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_article.dart';

/// Service to fetch articles from Dev.to - a trusted developer community
/// Dev.to is owned by Forem and is a well-known, reputable source for tech articles
class DevToService {
  static const String _baseUrl = 'https://dev.to/api';
  
  /// Fetch top articles from Dev.to
  /// Returns articles tagged with AI, machine learning, or general programming
  Future<List<NewsArticle>> fetchArticles({int limit = 20, String? tag}) async {
    try {
      String url = '$_baseUrl/articles?per_page=$limit';
      if (tag != null && tag.isNotEmpty) {
        url += '&tag=$tag';
      }
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch Dev.to articles');
      }
      
      final List<dynamic> data = json.decode(response.body);
      
      return data.map((article) => _parseArticle(article)).toList();
    } catch (e) {
      // Log error silently in production
      return [];
    }
  }
  
  NewsArticle _parseArticle(Map<String, dynamic> data) {
    // Determine category based on tags
    final tags = (data['tag_list'] as List<dynamic>?)?.cast<String>() ?? [];
    String category = _categorizeFromTags(tags);
    
    // Parse published date
    String? publishedAtString;
    DateTime? publishedAt;
    
    if (data['published_at'] != null) {
      try {
        publishedAt = DateTime.parse(data['published_at']);
        publishedAtString = _formatTimeAgo(publishedAt);
      } catch (_) {
        publishedAtString = data['readable_publish_date'] ?? 'Recently';
      }
    }
    
    return NewsArticle(
      id: 'devto_${data['id']}',
      title: data['title'] ?? 'Untitled',
      summary: data['description'] ?? '',
      source: 'Dev.to',
      sourceLogo: '👨‍💻',
      category: category,
      imageUrl: data['cover_image'] ?? data['social_image'],
      url: data['url'] ?? 'https://dev.to',
      publishedAt: publishedAt,
      publishedAtString: publishedAtString,
      isBreaking: (data['positive_reactions_count'] ?? 0) > 100,
    );
  }
  
  String _categorizeFromTags(List<String> tags) {
    final lowerTags = tags.map((t) => t.toLowerCase()).toList();
    
    if (lowerTags.any((t) => ['ai', 'machinelearning', 'artificialintelligence', 'gpt', 'llm', 'openai', 'chatgpt'].contains(t))) {
      return 'AI Research';
    }
    
    if (lowerTags.any((t) => ['startup', 'entrepreneurship', 'business', 'career'].contains(t))) {
      return 'Startups';
    }
    
    if (lowerTags.any((t) => ['news', 'industry', 'tech', 'google', 'microsoft', 'apple'].contains(t))) {
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
}
