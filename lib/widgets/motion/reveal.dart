import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'motion.dart';

enum RevealStyle {
  /// Sobe e "deita" para a frente (rotação no eixo X).
  rise,

  /// Gira no eixo Y, como um cartão virando.
  flip,

  /// Entra deslizando da direita.
  slideLeft,

  /// Cresce a partir do centro.
  pop,
}

/// Anima o conteúdo quando ele entra na tela durante a rolagem.
///
/// Com movimento reduzido (ou nos testes), mostra o conteúdo direto.
class Reveal extends StatefulWidget {
  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.style = RevealStyle.rise,
    this.duration = const Duration(milliseconds: 750),
  });

  final Widget child;
  final Duration delay;
  final RevealStyle style;
  final Duration duration;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration);
  ScrollPosition? _position;
  Timer? _delayTimer;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!MotionScope.enabledOf(context)) {
      _controller.value = 1;
      _detach();
      return;
    }
    final position = Scrollable.maybeOf(context)?.position;
    if (position != _position) {
      _detach();
      _position = position;
      _position?.addListener(_check);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _detach() {
    _position?.removeListener(_check);
    _position = null;
  }

  void _check() {
    if (_started || !mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final viewport = MediaQuery.sizeOf(context).height;
    if (top < viewport * 0.92) {
      _started = true;
      _detach();
      if (widget.delay == Duration.zero) {
        _controller.forward();
      } else {
        _delayTimer = Timer(widget.delay, () {
          if (mounted) _controller.forward();
        });
      }
    }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _detach();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final v = _controller.value;
        if (v >= 1) return child!;
        final t = Curves.easeOutCubic.transform(v);
        final remaining = 1 - t;
        final Matrix4 transform;
        switch (widget.style) {
          case RevealStyle.rise:
            transform = perspective3D(
              rotateX: remaining * 0.45,
              translateY: remaining * 42,
            );
          case RevealStyle.flip:
            transform = perspective3D(
              rotateY: remaining * math.pi / 2.4,
              translateY: remaining * 18,
            );
          case RevealStyle.slideLeft:
            transform = Matrix4.translationValues(remaining * 60, 0, 0)
              ..multiply(perspective3D(rotateY: -remaining * 0.35));
          case RevealStyle.pop:
            transform = perspective3D(scale: 0.86 + 0.14 * t);
        }
        return Opacity(
          opacity: Curves.easeOut.transform(v),
          child: Transform(
            alignment: Alignment.center,
            transform: transform,
            child: child,
          ),
        );
      },
    );
  }
}
