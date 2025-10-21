import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_implementation_task/config/app_config.dart';

/// News API Service - handles API calls to news provider
class NewsApiService {
  // Get your free API key from https://newsapi.org/register
  static const String _baseUrl = 'https://newsapi.org/v2';
  final String _apiKey = AppConfig.news_API_key;
  
  /// Fetch top headlines
  Future<List<NewsArticle>> fetchTopHeadlines({
    String country = 'us',
    String? category,
    int pageSize = 20,
  }) async {
    try {
      final queryParams = {
        'country': country,
        'pageSize': pageSize.toString(),
        'apiKey': _apiKey,
      };
      
      if (category != null) {
        queryParams['category'] = category;
      }
      
      final uri = Uri.parse('$_baseUrl/top-headlines')
          .replace(queryParameters: queryParams);
      
      debugPrint('📰 Fetching news from: $uri');
      
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = (data['articles'] as List)
            .map((json) => NewsArticle.fromJson(json))
            .toList();
        
        debugPrint('✅ Fetched ${articles.length} articles');
        return articles;
      } else {
        debugPrint('❌ API Error: ${response.statusCode}');
        throw NewsApiException('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ News fetch error: $e');
      rethrow;
    }
  }
  
  /// Search for news articles
  Future<List<NewsArticle>> searchNews({
    required String query,
    String? language = 'en',
    String? sortBy = 'publishedAt',
    int pageSize = 20,
  }) async {
    try {
      final queryParams = {
        'q': query,
        'language': language ?? 'en',
        'sortBy': sortBy ?? 'publishedAt',
        'pageSize': pageSize.toString(),
        'apiKey': _apiKey,
      };
      
      final uri = Uri.parse('$_baseUrl/everything')
          .replace(queryParameters: queryParams);
      
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = (data['articles'] as List)
            .map((json) => NewsArticle.fromJson(json))
            .toList();
        
        return articles;
      } else {
        throw NewsApiException('Failed to search news: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ News search error: $e');
      rethrow;
    }
  }
}

/// News Article Model
class NewsArticle {
  final String? author;
  final String title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final DateTime publishedAt;
  final String? content;
  final String? sourceName;
  
  NewsArticle({
    this.author,
    required this.title,
    this.description,
    this.url,
    this.urlToImage,
    required this.publishedAt,
    this.content,
    this.sourceName,
  });
  
  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      author: json['author'] as String?,
      title: json['title'] as String? ?? 'No Title',
      description: json['description'] as String?,
      url: json['url'] as String?,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      content: json['content'] as String?,
      sourceName: json['source']?['name'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt.toIso8601String(),
      'content': content,
      'source': {'name': sourceName},
    };
  }
}

/// Custom exception for News API errors
class NewsApiException implements Exception {
  final String message;
  NewsApiException(this.message);
  
  @override
  String toString() => 'NewsApiException: $message';
}