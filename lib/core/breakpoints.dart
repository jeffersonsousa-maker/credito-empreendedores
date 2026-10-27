import 'package:flutter/widgets.dart';

/// Pontos de quebra do layout (mobile-first).
class Breakpoints {
  Breakpoints._();

  static const double tablet = 640;
  static const double desktop = 1024;
  static const double wide = 1200;

  /// Largura máxima do conteúdo centralizado.
  static const double maxContentWidth = 1180;

  static bool isMobile(double width) => width < tablet;
  static bool isTablet(double width) => width >= tablet && width < desktop;
  static bool isDesktop(double width) => width >= desktop;

  /// Margem lateral conforme a largura disponível.
  static double horizontalPadding(double width) {
    if (width >= desktop) return 40;
    if (width >= tablet) return 32;
    return 20;
  }

  /// Espaço vertical padrão entre seções.
  static double sectionSpacing(double width) {
    if (width >= desktop) return 96;
    if (width >= tablet) return 80;
    return 64;
  }

  static double widthOf(BuildContext context) => MediaQuery.sizeOf(context).width;
}
