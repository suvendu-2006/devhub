import 'dart:math';
import '../models/news_article.dart';

class NewsService {
  final Random _random = Random();
  
  // Trusted AI news sources with real URLs
  final List<Map<String, dynamic>> _newsPool = [
    // MIT Technology Review
    {'title': 'OpenAI\'s GPT-5 Sets New Benchmarks in AI Reasoning', 'summary': 'The latest language model demonstrates unprecedented capabilities in complex problem-solving and logical reasoning tasks.', 'source': 'MIT Technology Review', 'category': 'AI Research', 'url': 'https://www.technologyreview.com/topic/artificial-intelligence/'},
    
    // Nature
    {'title': 'DeepMind\'s AlphaFold 3 Revolutionizes Protein Structure Prediction', 'summary': 'Breakthrough in computational biology enables rapid drug discovery and disease research.', 'source': 'Nature', 'category': 'AI Research', 'url': 'https://www.nature.com/subjects/machine-learning'},
    
    // The Verge
    {'title': 'Microsoft Copilot Now Available Across All Office Apps', 'summary': 'AI-powered assistant helps users with writing, data analysis, and presentation creation.', 'source': 'The Verge', 'category': 'Industry', 'url': 'https://www.theverge.com/ai-artificial-intelligence'},
    
    // Reuters
    {'title': 'European Union Finalizes Comprehensive AI Regulation', 'summary': 'Landmark legislation establishes global standards for AI development and deployment.', 'source': 'Reuters', 'category': 'Industry', 'url': 'https://www.reuters.com/technology/artificial-intelligence/'},
    
    // Wired
    {'title': 'Anthropic\'s Claude 3.5 Achieves Human-Level Reasoning', 'summary': 'AI assistant demonstrates advanced capabilities in nuanced conversations and complex analysis.', 'source': 'Wired', 'category': 'AI Research', 'url': 'https://www.wired.com/tag/artificial-intelligence/'},
    
    // TechCrunch
    {'title': 'AI Startups Raise Record \$50B in Venture Funding', 'summary': 'Investment in artificial intelligence companies reaches historic levels amid generative AI boom.', 'source': 'TechCrunch', 'category': 'Startups', 'url': 'https://techcrunch.com/category/artificial-intelligence/'},
    
    // Ars Technica
    {'title': 'Google Gemini Ultra Outperforms GPT-4 in Key Benchmarks', 'summary': 'Multimodal AI model shows superior performance in reasoning and image understanding tasks.', 'source': 'Ars Technica', 'category': 'AI Research', 'url': 'https://arstechnica.com/ai/'},
    
    // VentureBeat
    {'title': 'Hugging Face Launches Enterprise ML Platform', 'summary': 'Open-source AI leader expands offerings for large-scale enterprise deployment.', 'source': 'VentureBeat', 'category': 'Startups', 'url': 'https://venturebeat.com/ai/'},
    
    // IEEE Spectrum
    {'title': 'Nvidia H200 GPU Doubles AI Training Performance', 'summary': 'New chip architecture enables faster and more efficient large language model training.', 'source': 'IEEE Spectrum', 'category': 'Industry', 'url': 'https://spectrum.ieee.org/artificial-intelligence'},
    
    // Science
    {'title': 'AI Discovers New Antibiotic Candidates', 'summary': 'Machine learning identifies potential treatments for antibiotic-resistant bacteria.', 'source': 'Science', 'category': 'AI Research', 'url': 'https://www.science.org/topic/category/technology'},
    
    // Bloomberg
    {'title': 'Apple Unveils On-Device AI Engine for Privacy', 'summary': 'New approach keeps AI processing local, protecting user data from cloud transmission.', 'source': 'Bloomberg', 'category': 'Industry', 'url': 'https://www.bloomberg.com/technology'},
    
    // Perplexity/AI News
    {'title': 'Perplexity AI Raises \$500M at \$9B Valuation', 'summary': 'AI search startup continues rapid growth as alternative to traditional search engines.', 'source': 'Perplexity News', 'category': 'Startups', 'url': 'https://www.perplexity.ai/'},
    
    // Stanford HAI
    {'title': 'Stanford Research Shows AI Bias Can Be Systematically Reduced', 'summary': 'New techniques enable more equitable AI systems across diverse populations.', 'source': 'Stanford HAI', 'category': 'AI Research', 'url': 'https://hai.stanford.edu/news'},
    
    // OpenAI Blog
    {'title': 'OpenAI Introduces Advanced Safety Measures for GPT Models', 'summary': 'New guardrails and alignment techniques improve AI system reliability and trustworthiness.', 'source': 'OpenAI Blog', 'category': 'AI Research', 'url': 'https://openai.com/blog/'},
  ];

  // Tech-related image URLs using reliable CDN
  final List<String> _techImages = [
    'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=800&h=400&fit=crop', // AI brain
    'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=800&h=400&fit=crop', // Robot
    'https://images.unsplash.com/photo-1518770660439-4636190af475?w=800&h=400&fit=crop', // Circuit
    'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=800&h=400&fit=crop', // Code
    'https://images.unsplash.com/photo-1620712943543-bcc4688e7485?w=800&h=400&fit=crop', // AI chip
    'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=800&h=400&fit=crop', // Data
    'https://images.unsplash.com/photo-1531746790731-6c087fecd65a?w=800&h=400&fit=crop', // Neural
    'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800&h=400&fit=crop', // Global tech
  ];
  
  Future<List<NewsArticle>> fetchNews({String? category}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Shuffle and pick random news
    final shuffled = List<Map<String, dynamic>>.from(_newsPool)..shuffle(_random);
    final selected = shuffled.take(8).toList();
    
    final now = DateTime.now();
    List<NewsArticle> articles = [];
    
    for (int i = 0; i < selected.length; i++) {
      final news = selected[i];
      articles.add(NewsArticle(
        id: '${_random.nextInt(10000)}',
        title: news['title'],
        summary: news['summary'],
        source: news['source'],
        sourceLogo: _getSourceLogo(news['source']),
        category: news['category'],
        imageUrl: _techImages[i % _techImages.length],
        url: news['url'],
        publishedAt: now.subtract(Duration(hours: i * 3 + _random.nextInt(6))),
        isBreaking: i == 0,
      ));
    }
    
    if (category != null && category != 'All') {
      articles = articles.where((a) => a.category == category).toList();
    }
    
    return articles;
  }
  
  String _getSourceLogo(String source) {
    switch (source) {
      case 'MIT Technology Review': return '🔬';
      case 'Nature': return '🌿';
      case 'The Verge': return '🔷';
      case 'Reuters': return '📰';
      case 'Wired': return '⚡';
      case 'TechCrunch': return '💚';
      case 'Ars Technica': return '🔶';
      case 'VentureBeat': return '🚀';
      case 'IEEE Spectrum': return '📡';
      case 'Science': return '🧬';
      case 'Bloomberg': return '💹';
      case 'Perplexity News': return '🔮';
      case 'Stanford HAI': return '🎓';
      case 'OpenAI Blog': return '🤖';
      default: return '📰';
    }
  }
}
