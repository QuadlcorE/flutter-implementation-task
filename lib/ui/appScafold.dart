import 'package:flutter_implementation_task/common_libs.dart';

class CustomAppScafold extends StatelessWidget {
  const CustomAppScafold({super.key, required this.child});
  final Widget child;
  static AppStyle get style => _style;
  static final AppStyle _style = AppStyle();

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(child: Theme(data: $styles.colors.toThemeData(), child: child));
  }
}
