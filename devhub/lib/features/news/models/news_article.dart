class NewsArticle {
  final String id;
  final String title;
  final String summary;
  final String source;
  final String sourceLogo;
  final String category;
  final String? imageUrl;
  final String url;
  final DateTime publishedAt;
  final bool isBreaking;

  NewsArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.source,
    required this.sourceLogo,
    required this.category,
    this.imageUrl,
    required this.url,
    required this.publishedAt,
    this.isBreaking = false,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);
    
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
