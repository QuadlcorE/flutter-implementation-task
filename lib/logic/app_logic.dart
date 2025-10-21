import 'package:flutter_implementation_task/common_libs.dart';

/// Top-level app controller that handles app initialization and state
class AppLogic {
  /// Flag to track if the app has completed bootstrapping
  bool _isBootstrapComplete = false;
  bool get isBootstrapComplete => _isBootstrapComplete;

  /// For compatibility with some patterns (same as isBootstrapComplete)
  bool get isBootstrapped => _isBootstrapComplete;

  /// Bootstrap the application
  /// This runs after the app starts but before the user can interact
  Future<void> bootstrap() async {
    try {
      debugPrint('🚀 Starting app bootstrap...');

      // Simulate checking app version or remote config
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Load settings (theme, locale, etc.)
      debugPrint('📱 Loading settings...');
      final settingsLogic = GetIt.I.get<SettingsLogic>();
      await settingsLogic.load();
      
      // Check authentication status
      debugPrint('🔐 Checking authentication...');
      final authLogic = GetIt.I.get<AuthLogic>();
      await authLogic.checkAuthStatus();
      
      // Initialize any services that need async setup
      // await databaseService.init();
      // await analyticsService.init();
      
      // Load any critical data
      // await dataService.loadInitialData();
      
      // Simulate minimum loading time for smoother UX
      await Future.delayed(const Duration(milliseconds: 3000));
      
      debugPrint('✅ Bootstrap complete!');
      debugPrint('   - User authenticated: ${authLogic.isAuthenticated}');
      if (authLogic.isAuthenticated) {
        debugPrint('   - User email: ${authLogic.userEmail}');
      }
      
      // Mark bootstrap as complete
      _isBootstrapComplete = true;

      // Manually trigger navigation
    // final authLogic = GetIt.I.get<AuthLogic>();
    if (authLogic.isAuthenticated) {
      appRouter.go(ScreenPaths.home);
    } else {
      appRouter.go(ScreenPaths.login);
    }
      
    } catch (e, stackTrace) {
      debugPrint('❌ Bootstrap error: $e');
      debugPrint('Stack trace: $stackTrace');
      
      // Even on error, mark as complete to prevent app from being stuck
      _isBootstrapComplete = true;
      
      // Optionally rethrow or handle the error
      // rethrow;
    }
  }

  /// Reset the app state (useful for logout or testing)
  void reset() {
    _isBootstrapComplete = false;
    // Reset other state as needed
  }
}