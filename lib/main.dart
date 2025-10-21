import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_implementation_task/common_libs.dart';
import 'package:flutter_implementation_task/services/storage_service.dart';
import 'package:flutter_implementation_task/services/news_api_service.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  
  // Keep native splash screen up until app is finished bootstrapping
  if (!kIsWeb) {
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  }

  // Enable GoRouter URL reflection
  GoRouter.optionURLReflectsImperativeAPIs = true;

  // Register all singletons
  await registerSingletons();

  // Run app
  runApp(const MyApp());
  
  // Bootstrap app logic (load data, check auth, etc.)
  await appLogic.bootstrap();
  
  // Remove native splash screen when bootstrap is complete
  if (!kIsWeb) {
    FlutterNativeSplash.remove();
  }
}

/// Register all singleton services and logic controllers
Future<void> registerSingletons() async {
  // Services (must be initialized first)
  GetIt.I.registerLazySingleton<StorageService>(() => StorageService());
  GetIt.I.registerLazySingleton<NewsApiService>(() => NewsApiService());
  
  // Initialize storage service
  await GetIt.I.get<StorageService>().init();
  
  // Logic controllers
  GetIt.I.registerLazySingleton<AppLogic>(() => AppLogic());
  GetIt.I.registerLazySingleton<SettingsLogic>(() => SettingsLogic());
  GetIt.I.registerLazySingleton<AuthLogic>(() => AuthLogic());
  GetIt.I.registerLazySingleton<NewsLogic>(() => NewsLogic());
}

// Global accessors for logic controllers
AppLogic get appLogic => GetIt.I.get<AppLogic>();
SettingsLogic get settingsLogic => GetIt.I.get<SettingsLogic>();
AuthLogic get authLogic => GetIt.I.get<AuthLogic>();
NewsLogic get newsLogic => GetIt.I.get<NewsLogic>();

// Global accessors for services
StorageService get storageService => GetIt.I.get<StorageService>();

// Global style accessor - initialized when app builds
late AppStyle $styles;

/// Main app widget using GoRouter
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      
      // Router configuration
      routeInformationProvider: appRouter.routeInformationProvider,
      routeInformationParser: appRouter.routeInformationParser,
      routerDelegate: appRouter.routerDelegate,
      
      // Theme configuration
      theme: ThemeData(
        fontFamily: 'Roboto',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1976D2),
        ),
      ),
      
      // Initialize styles when the first screen builds
      builder: (context, child) {
        // Initialize styles with screen size
        final size = MediaQuery.of(context).size;
        $styles = AppStyle();
        
        return child ?? const SizedBox.shrink();
      },
    );
  }
}