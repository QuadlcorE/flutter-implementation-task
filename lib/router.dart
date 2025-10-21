import 'package:flutter/cupertino.dart';
import 'package:flutter_implementation_task/common_libs.dart';
import 'package:flutter_implementation_task/ui/screens/home/app_home_screen.dart';
import 'package:flutter_implementation_task/ui/screens/login/login_screen.dart';
import 'package:flutter_implementation_task/ui/screens/signup/signup_screen.dart';

/// Screen path constants
class ScreenPaths {
  static String splash = '/';
  static String login = '/login';
  static String signup = '/signup';
  static String home = '/home';
  
  // Add more paths as needed
  // static String profile = '/profile';
  // static String settings = '/settings';
}

/// Store initial deeplink for redirect after bootstrap
String? get initialDeeplink => _initialDeeplink;
String? _initialDeeplink;

/// Global router instance
final appRouter = GoRouter(
  redirect: _handleRedirect,
  debugLogDiagnostics: true, // CHANGED: Always show debug logs for now
  
  // Error page builder
  errorPageBuilder: (context, state) => CupertinoPage(
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        backgroundColor: $styles.colors.error,
        foregroundColor: $styles.colors.white,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all($styles.insets.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: $styles.colors.error,
              ),
              SizedBox(height: $styles.insets.lg),
              Text(
                'Oops! Page not found',
                style: $styles.text.h2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: $styles.insets.md),
              Text(
                'The page "${state.uri}" does not exist.',
                style: $styles.text.bodySmall.copyWith(
                  color: $styles.colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: $styles.insets.xl),
              ElevatedButton(
                onPressed: () => context.go(ScreenPaths.home),
                style: ElevatedButton.styleFrom(
                  backgroundColor: $styles.colors.primary,
                  foregroundColor: $styles.colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: $styles.insets.lg,
                    vertical: $styles.insets.md,
                  ),
                ),
                child: Text('Go Home', style: $styles.text.button),
              ),
            ],
          ),
        ),
      ),
    ),
  ),

  // Route definitions
  routes: [
    // Splash screen - root route - FIXED: Show actual splash screen
    AppRoute(
      ScreenPaths.splash,
      (_) => Container(color: $styles.colors.white,), // CHANGED: Show real splash screen
    ),

    // Auth routes
    AppRoute(
      ScreenPaths.login,
      (_) => const LoginScreen(),
    ),
    AppRoute(
      ScreenPaths.signup,
      (_) => const SignupScreen(),
    ),

    // Home screen with nested routes
    AppRoute(
      ScreenPaths.home,
      (_) => const HomeScreen(),
      // (_) => Container(color: $styles.colors.primary),
      routes: [
        // Add nested routes here as your app grows
        // Example:
        // AppRoute('profile', (_) => ProfileScreen()),
        // AppRoute('settings', (_) => SettingsScreen()),
      ],
    ),
  ],
);

/// Custom GoRoute sub-class to make the router declaration easier to read
class AppRoute extends GoRoute {
  AppRoute(
    String path,
    Widget Function(GoRouterState s) builder, {
    List<GoRoute> routes = const [],
    this.useFade = false,
  }) : super(
          path: path,
          routes: routes,
          pageBuilder: (context, state) {
            final pageContent = Scaffold(
              body: builder(state),
              resizeToAvoidBottomInset: false,
            );
            
            if (useFade) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: pageContent,
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              );
            }
            
            return CupertinoPage(child: pageContent);
          },
        );
  
  final bool useFade;
}

/// Handle redirects for splash screen and authentication
String? _handleRedirect(BuildContext context, GoRouterState state) {
  // Get auth logic
  final authLogic = GetIt.I.get<AuthLogic>();
  
  debugPrint('🔀 REDIRECT CHECK:');
  debugPrint('   Current path: ${state.uri.path}');
  debugPrint('   Bootstrap complete: ${appLogic.isBootstrapComplete}');
  debugPrint('   User authenticated: ${authLogic.isAuthenticated}');
  
  // PHASE 1: Prevent anyone from navigating away from `/` if app is starting up
  if (!appLogic.isBootstrapComplete && state.uri.path != ScreenPaths.splash) {
    debugPrint('   ➡️ REDIRECT TO SPLASH (bootstrap not complete)');
    // Store the initial deeplink to redirect after bootstrap
    _initialDeeplink ??= state.uri.toString();
    return ScreenPaths.splash;
  }
  
  // PHASE 2: Once bootstrap is complete, redirect from splash to appropriate screen
  if (appLogic.isBootstrapComplete && state.uri.path == ScreenPaths.splash) {
    debugPrint('   ✅ Bootstrap complete!');
    
    // Check if there's a stored deeplink to navigate to
    if (_initialDeeplink != null) {
      final deeplink = _initialDeeplink;
      _initialDeeplink = null; // Clear it after use
      debugPrint('   ➡️ REDIRECT TO DEEPLINK: $deeplink');
      return deeplink;
    }
    
    // Check authentication status
    if (!authLogic.isAuthenticated) {
      debugPrint('   ➡️ REDIRECT TO LOGIN (not authenticated)');
      return ScreenPaths.login;
    }
    
    debugPrint('   ➡️ REDIRECT TO HOME (authenticated)');
    return ScreenPaths.home;
  }
  
  // PHASE 3: Protect routes that require authentication
  final publicRoutes = [ScreenPaths.splash, ScreenPaths.login, ScreenPaths.signup];
  if (!authLogic.isAuthenticated && !publicRoutes.contains(state.uri.path)) {
    debugPrint('   ➡️ REDIRECT TO LOGIN (protected route, not authenticated)');
    _initialDeeplink = state.uri.toString();
    return ScreenPaths.login;
  }
  
  debugPrint('   ✅ NO REDIRECT NEEDED');
  return null; // No redirect needed
}

/// Helper extension for easier navigation
extension GoRouterExtension on BuildContext {
  /// Navigate to splash screen
  void goToSplash() => go(ScreenPaths.splash);
  
  /// Navigate to login screen
  void goToLogin() => go(ScreenPaths.login);
  
  /// Navigate to signup screen
  void goToSignup() => go(ScreenPaths.signup);
  
  /// Navigate to home screen
  void goToHome() => go(ScreenPaths.home);
}