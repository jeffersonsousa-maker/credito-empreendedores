import 'package:flutter/widgets.dart';

/// Liga/desliga os efeitos de movimento do site.
///
/// Os efeitos ficam desligados quando o visitante pede "reduzir movimento"
/// no sistema (acessibilidade) ou quando o app é criado com
/// `enableMotion: false` (usado nos testes automatizados).
class MotionScope extends InheritedWidget {
  const MotionScope({super.key, required this.enabled, required super.child});

  final bool enabled;

  static bool enabledOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<MotionScope>();
    final allowed = scope?.enabled ?? true;
    return allowed && !MediaQuery.disableAnimationsOf(context);
  }

  @override
  bool updateShouldNotify(MotionScope oldWidget) => enabled != oldWidget.enabled;
}

/// Matriz com perspectiva para rotações 3D.
Matrix4 perspective3D({
  double rotateX = 0,
  double rotateY = 0,
  double translateY = 0,
  double scale = 1,
  double depth = 0.0012,
}) {
  return Matrix4.identity()
    ..setEntry(3, 2, depth)
    ..multiply(Matrix4.translationValues(0, translateY, 0))
    ..multiply(Matrix4.rotationX(rotateX))
    ..multiply(Matrix4.rotationY(rotateY))
    ..multiply(Matrix4.diagonal3Values(scale, scale, 1));
}
