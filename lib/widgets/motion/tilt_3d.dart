import 'package:flutter/material.dart';

import 'motion.dart';

typedef TiltBuilder = Widget Function(BuildContext context, Offset tilt);

/// Inclina o conteúdo em 3D seguindo o mouse.
///
/// [tilt] vai de -1 a 1 em cada eixo e é repassado ao [builder] para que as
/// camadas internas se desloquem em profundidades diferentes (paralaxe).
/// Em telas de toque ou com movimento reduzido, o conteúdo fica parado.
class Tilt3D extends StatefulWidget {
  const Tilt3D({
    super.key,
    required this.builder,
    this.maxAngle = 0.12,
    this.hoverScale = 1.0,
    this.glare = false,
    this.borderRadius = BorderRadius.zero,
  });

  /// Atalho para conteúdo sem camadas.
  Tilt3D.child({
    super.key,
    required Widget child,
    this.maxAngle = 0.12,
    this.hoverScale = 1.0,
    this.glare = false,
    this.borderRadius = BorderRadius.zero,
  }) : builder = ((_, __) => child);

  final TiltBuilder builder;

  /// Ângulo máximo em radianos (0,12 ≈ 7°).
  final double maxAngle;
  final double hoverScale;
  final bool glare;
  final BorderRadius borderRadius;

  @override
  State<Tilt3D> createState() => _Tilt3DState();
}

class _Tilt3DState extends State<Tilt3D> {
  Offset _target = Offset.zero;
  bool _hover = false;

  void _update(Offset local) {
    final size = context.size;
    if (size == null || size.isEmpty) return;
    final dx = (local.dx / size.width) * 2 - 1;
    final dy = (local.dy / size.height) * 2 - 1;
    setState(() {
      _hover = true;
      _target = Offset(dx.clamp(-1.0, 1.0), dy.clamp(-1.0, 1.0));
    });
  }

  void _reset() => setState(() {
        _hover = false;
        _target = Offset.zero;
      });

  @override
  Widget build(BuildContext context) {
    if (!MotionScope.enabledOf(context)) {
      return widget.builder(context, Offset.zero);
    }

    return MouseRegion(
      onHover: (e) => _update(e.localPosition),
      onExit: (_) => _reset(),
      child: TweenAnimationBuilder<Offset>(
        tween: Tween<Offset>(end: _target),
        duration: Duration(milliseconds: _hover ? 160 : 520),
        curve: _hover ? Curves.easeOut : Curves.easeOutBack,
        builder: (context, tilt, _) {
          final scale = 1 + (widget.hoverScale - 1) * tilt.distance.clamp(0.0, 1.0);
          Widget content = widget.builder(context, tilt);
          if (widget.glare) {
            content = Stack(
              fit: StackFit.passthrough,
              children: [
                content,
                Positioned.fill(
                  child: IgnorePointer(
                    child: ClipRRect(
                      borderRadius: widget.borderRadius,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment(tilt.dx, tilt.dy),
                            radius: 1.1,
                            colors: [
                              Color.fromRGBO(
                                255,
                                255,
                                255,
                                0.22 * tilt.distance.clamp(0.0, 1.0),
                              ),
                              const Color(0x00FFFFFF),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return Transform(
            alignment: Alignment.center,
            transform: perspective3D(
              rotateX: -tilt.dy * widget.maxAngle,
              rotateY: tilt.dx * widget.maxAngle,
              scale: scale,
            ),
            child: content,
          );
        },
      ),
    );
  }
}
