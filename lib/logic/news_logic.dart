import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_implementation_task/services/news_api_service.dart';

/// News Logic Controller
/// Manages news data and state
class NewsLogic extends ChangeNotifier {
  final NewsApiService _newsService = GetIt.I.get<NewsApiService>();
  
  List<NewsArticle> _articles = [];
  List<NewsArticle> get articles => _articles;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  
  String _selectedCategory = 'general';
  String get selectedCategory => _selectedCategory;
  
  // Available categories
  final List<String> categories = [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ];
  
  /// Fetch top headlines
  Future<void> fetchTopHeadlines({String? category}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      debugPrint('📰 Fetching top headlines...');
      
      _articles = await _newsService.fetchTopHeadlines(
        country: 'us',
        category: category ?? _selectedCategory,
      );
      
      debugPrint('✅ Loaded ${_articles.length} articles');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error fetching news: $e');
      _errorMessage = 'Failed to load news. Please try again.';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Search news by query
  Future<void> searchNews(String query) async {
    if (query.isEmpty) {
      await fetchTopHeadlines();
      return;
    }
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      debugPrint('🔍 Searching news for: $query');
      
      _articles = await _newsService.searchNews(query: query);
      
      debugPrint('✅ Found ${_articles.length} articles');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error searching news: $e');
      _errorMessage = 'Failed to search news. Please try again.';
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Change selected category
  Future<void> changeCategory(String category) async {
    _selectedCategory = category;
    notifyListeners();
    await fetchTopHeadlines();
  }
  
  /// Refresh news
  Future<void> refresh() async {
    await fetchTopHeadlines();
  }
  
  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}