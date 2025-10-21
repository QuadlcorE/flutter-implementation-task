import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_implementation_task/services/storage_service.dart';

/// Settings Logic Controller
/// Manages app settings like theme, locale, etc.
class SettingsLogic extends ChangeNotifier {
  final StorageService _storage = GetIt.I.get<StorageService>();
  
  String? _currentLocale;
  String? get currentLocale => _currentLocale;
  
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;
  
  /// Load settings from storage
  Future<void> load() async {
    try {
      debugPrint('⚙️ Loading settings...');
      
      // Simulate loading time
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Load locale preference
      _currentLocale = _storage.getString('locale') ?? 'en';
      
      // Load theme preference
      _isDarkMode = _storage.getBool('dark_mode') ?? false;
      
      debugPrint('✅ Settings loaded: locale=$_currentLocale, darkMode=$_isDarkMode');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading settings: $e');
    }
  }
  
  /// Change app locale
  Future<void> changeLocale(String locale) async {
    _currentLocale = locale;
    await _storage.saveString('locale', locale);
    notifyListeners();
  }
  
  /// Toggle dark mode
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _storage.saveBool('dark_mode', _isDarkMode);
    notifyListeners();
  }
  
  /// Reset settings to default
  Future<void> reset() async {
    _currentLocale = 'en';
    _isDarkMode = false;
    await _storage.saveString('locale', 'en');
    await _storage.saveBool('dark_mode', false);
    notifyListeners();
  }
}