import 'package:flutter_implementation_task/common_libs.dart';

class AppColors {
  // Common
  final Color primary = Color(0xFF3C25B3);
  final Color secondary = Color(0xFF071A27);
  final Color greyStrong = const Color(0xFF272625);
  final Color greyMedium = const Color(0xFF9D9995);
  final Color white = Colors.white;
  final Color black = const Color(0xFF1E1B18);

  final Color success = const Color(0xFF4CAF50);
  final Color warning = const Color(0xFFFF9800);
  final Color error = const Color(0xFFF44336);
  final Color info = const Color(0xFF2196F3);

  final isDark = false;

  ThemeData toThemeData() {
    /// Create a TextTheme and ColorScheme, that we can use to generate ThemeData
    TextTheme txtTheme =
        (isDark ? ThemeData.dark() : ThemeData.light()).textTheme;
    Color txtColor = white;
    ColorScheme colorScheme = ColorScheme(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: primary,
      secondary: secondary,
      surface: white,
      onSurface: txtColor,
      onError: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      error: Colors.red.shade400,
    );

    /// Now that we have ColorScheme and TextTheme, we can create the ThemeData
    /// Also add on some extra properties that ColorScheme seems to miss
    var t = ThemeData.from(textTheme: txtTheme, colorScheme: colorScheme)
        .copyWith(
          textSelectionTheme: TextSelectionThemeData(cursorColor: white),
        );
      return t;
  }
}
