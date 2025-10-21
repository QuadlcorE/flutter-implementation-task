import 'package:flutter_implementation_task/common_libs.dart';

export 'colors.dart';

class AppStyle {
  AppStyle({Size? screenSize}) {
    if (screenSize == null) {
      scale = 1;
      return;
    }
    final shortestSide = screenSize.shortestSide;
    const tabletXl = 1000;
    const tabletLg = 800;
    if (shortestSide > tabletXl) {
      scale = 1.2;
    } else if (shortestSide > tabletLg) {
      scale = 1.1;
    } else {
      scale = 1;
    }
  }

  late final double scale;

  final AppColors colors = AppColors();

  late final _Text text = _Text(scale);

  late final _Insets insets = _Insets(scale: scale);

  late final _Corners corners = _Corners();

  late final _Shadows shadows = _Shadows();
}

class _Text {
  _Text(this._scale);
  final double _scale;

  final Map<String, TextStyle> _titleFonts = {
    'en': const TextStyle(fontFamily: 'Satoshi'),
    'es': const TextStyle(fontFamily: 'Satoshi'),
  };

  final Map<String, TextStyle> _monoFonts = {
    'en': const TextStyle(fontFamily: 'RobotoMono'),
  };

  TextStyle _titleFont([String locale = 'en']) =>
      _titleFonts[locale] ?? _titleFonts['en']!;

  TextStyle _monoFont([String locale = 'en']) =>
      _monoFonts[locale] ?? _monoFonts['en']!;

  late final TextStyle title1 = _createFont(
    _titleFont(),
    sizePx: 64,
    heightPx: 72,
    weight: FontWeight.w700,
  );

  late final TextStyle title2 = _createFont(
    _titleFont(),
    sizePx: 48,
    heightPx: 56,
    weight: FontWeight.w700,
  );

  late final TextStyle title3 = _createFont(
    _titleFont(),
    sizePx: 32,
    heightPx: 40,
    weight: FontWeight.w600,
  );

  /// Heading styles
  late final TextStyle h1 = _createFont(
    _titleFont(),
    sizePx: 28,
    heightPx: 36,
    weight: FontWeight.w600,
  );

  late final TextStyle h2 = _createFont(
    _titleFont(),
    sizePx: 24,
    heightPx: 32,
    weight: FontWeight.w600,
  );

  late final TextStyle h3 = _createFont(
    _titleFont(),
    sizePx: 20,
    heightPx: 28,
    weight: FontWeight.w600,
  );

  /// Body text styles
  late final TextStyle body = _createFont(
    _titleFont(),
    sizePx: 16,
    heightPx: 24,
    weight: FontWeight.w400,
  );

  late final TextStyle bodyBold = _createFont(
    _titleFont(),
    sizePx: 16,
    heightPx: 24,
    weight: FontWeight.w600,
  );

  late final TextStyle bodySmall = _createFont(
    _titleFont(),
    sizePx: 14,
    heightPx: 20,
    weight: FontWeight.w400,
  );

  /// Caption and label styles
  late final TextStyle caption = _createFont(
    _titleFont(),
    sizePx: 12,
    heightPx: 16,
    weight: FontWeight.w400,
  );

  late final TextStyle captionBold = _createFont(
    _titleFont(),
    sizePx: 12,
    heightPx: 16,
    weight: FontWeight.w600,
  );

  /// Button text style
  late final TextStyle button = _createFont(
    _titleFont(),
    sizePx: 16,
    heightPx: 20,
    weight: FontWeight.w600,
    spacingPc: 5,
  );

  /// Monospace text style
  late final TextStyle mono = _createFont(
    _monoFont(),
    sizePx: 14,
    heightPx: 20,
    weight: FontWeight.w400,
  );
  TextStyle _createFont(
    TextStyle style, {
    required double sizePx,
    double? heightPx,
    double? spacingPc,
    FontWeight? weight,
  }) {
    sizePx *= _scale;
    if (heightPx != null) {
      heightPx *= _scale;
    }
    return style.copyWith(
      fontSize: sizePx,
      height: heightPx != null ? (heightPx / sizePx) : style.height,
      letterSpacing: spacingPc != null
          ? sizePx * spacingPc * 0.01
          : style.letterSpacing,
      fontWeight: weight,
    );
  }
}

class _Insets {
  _Insets({required double scale}) : _scale = scale;

  final double _scale;

  late final double xxs = 4 * _scale;
  late final double xs = 8 * _scale;
  late final double sm = 12 * _scale;
  late final double md = 16 * _scale;
  late final double lg = 24 * _scale;
  late final double xl = 32 * _scale;
  late final double xxl = 48 * _scale;
  late final double xxxl = 64 * _scale;
}

/// Corner radius values
class _Corners {
  late final double xs = 4;
  late final double sm = 8;
  late final double md = 12;
  late final double lg = 16;
  late final double xl = 24;
  late final double full = 999;
}

/// Shadow configurations
class _Shadows {
  late final List<BoxShadow> small = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  late final List<BoxShadow> medium = [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  late final List<BoxShadow> large = [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
}
