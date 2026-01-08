// AI Feedback Service - Connected to Google Gemini API
//
// This service uses real AI to analyze code and provide educational guidance.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AIFeedbackService {
  // Gemini API configuration
  static const String _apiKey = 'AIzaSyDw7wzRvWarT3fXUgi-uY_5LJnKyV7RdvU';
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';
  static const Duration _timeout = Duration(seconds: 30);

  /// Analyzes code using Gemini AI and provides educational guidance
  Future<String> analyzeCode(String code, String language) async {
    try {
      if (code.trim().isEmpty) {
        return '🎯 **Ready to Code!**\n\nYour editor is empty. Write some $language code and I\'ll help you improve it!\n\n💡 Try writing a simple program to get started.';
      }

      final response = await _callGeminiAPI(code, language);
      return response;
    } on SocketException {
      return '📡 **No Internet Connection**\n\nPlease check your network connection and try again.\n\n💡 Tip: Make sure you\'re connected to WiFi or mobile data.';
    } on TimeoutException {
      return '⏱️ **Request Timed Out**\n\nThe AI service is taking too long to respond.\n\n💡 Please try again in a moment.';
    } on http.ClientException {
      return '🔌 **Connection Error**\n\nUnable to reach the AI service.\n\n💡 Please check your internet connection and try again.';
    } catch (e) {
      final errorStr = e.toString();
      
      // Check for specific API errors
      if (errorStr.contains('429') || errorStr.contains('quota') || errorStr.contains('RESOURCE_EXHAUSTED')) {
        return '⏳ **AI Service Busy**\n\nThe AI has reached its rate limit. Please wait a moment and try again.\n\n💡 Free tier has limited requests per minute.';
      }
      
      if (errorStr.contains('API_KEY_INVALID') || errorStr.contains('401')) {
        return '🔑 **API Key Error**\n\nThere\'s an issue with the AI configuration.\n\n💡 Please contact the developer.';
      }
      
      return '❌ **Error**\n\n$e\n\n💡 Please try again later.';
    }
  }

  Future<String> _callGeminiAPI(String code, String language) async {
    final prompt = '''You are an expert programming tutor helping a beginner learn $language. 
Analyze the following code and provide educational feedback.

IMPORTANT GUIDELINES:
1. Be encouraging and supportive - this is a learning environment
2. Focus on TEACHING, not just fixing - explain WHY things should be done a certain way
3. Point out what's GOOD about the code first
4. Then suggest improvements with clear explanations
5. Use emojis to make feedback friendly (✅ for good, 💡 for tips, ⚠️ for issues)
6. Keep responses concise but informative
7. If there are syntax errors, explain them clearly
8. Suggest best practices relevant to $language

CODE TO ANALYZE:
```$language
$code
```

Provide your feedback in a structured, easy-to-read format.''';

    final url = Uri.parse('$_baseUrl?key=$_apiKey');
    
    final requestBody = {
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.7,
        'maxOutputTokens': 1024,
      }
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    ).timeout(_timeout);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
      
      if (text != null) {
        return text;
      } else {
        return '⚠️ Received empty response from AI. Please try again.';
      }
    } else if (response.statusCode == 429) {
      throw Exception('Rate limit exceeded. Please wait and try again.');
    } else {
      final error = jsonDecode(response.body);
      final message = error['error']?['message'] ?? 'Unknown error';
      throw Exception('API Error (${response.statusCode}): $message');
    }
  }
}
