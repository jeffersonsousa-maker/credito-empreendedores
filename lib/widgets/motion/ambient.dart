import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'motion.dart';

/// Faz o conteúdo flutuar suavemente para cima e para baixo, sem parar.
class FloatingBob extends StatefulWidget {
  const FloatingBob({
    super.key,
    required this.child,
    this.amplitude = 8,
    this.period = const Duration(milliseconds: 3600),
    this.phase = 0,
    this.rotate = 0.02,
  });

  final Widget child;
  final double amplitude;
  final Duration period;

  /// Deslocamento do ciclo (0 a 1) para elementos não andarem juntos.
  final double phase;

  /// Leve rotação 3D durante o ciclo, em radianos.
  final double rotate;

  @override
  State<FloatingBob> createState() => _FloatingBobState();
}

class _FloatingBobState extends State<FloatingBob>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.period);
  bool _running = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final enabled = MotionScope.enabledOf(context);
    if (enabled && !_running) {
      _running = true;
      _controller.repeat();
    } else if (!enabled && _running) {
      _running = false;
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_running) return widget.child;
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final a = (_controller.value + widget.phase) * 2 * math.pi;
        return Transform(
          alignment: Alignment.center,
          transform: perspective3D(
            translateY: math.sin(a) * widget.amplitude,
            rotateX: math.cos(a) * widget.rotate,
            rotateY: math.sin(a) * widget.rotate,
          ),
          child: child,
        );
      },
    );
  }
}

/// Anel que pulsa em volta de um botão para chamar atenção.
class PulseRing extends StatefulWidget {
  const PulseRing({
    super.key,
    required this.child,
    required this.color,
    this.borderRadius = const BorderRadius.all(Radius.circular(999)),
  });

  final Widget child;
  final Color color;
  final BorderRadius borderRadius;

  @override
  State<PulseRing> createState() => _PulseRingState();
}

class _PulseRingState extends State<PulseRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );
  bool _running = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final enabled = MotionScope.enabledOf(context);
    if (enabled && !_running) {
      _running = true;
      _controller.repeat();
    } else if (!enabled && _running) {
      _running = false;
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_running) return widget.child;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final v = Curves.easeOut.transform(_controller.value);
                return Transform.scale(
                  scale: 1 + v * 0.45,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: widget.borderRadius,
                      border: Border.all(
                        color: widget.color.withAlpha(
                          ((1 - v) * 160).round().clamp(0, 255),
                        ),
                        width: 3,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}

/// Faixa com itens rolando na horizontal, em loop.
class Marquee extends StatefulWidget {
  const Marquee({
    super.key,
    required this.children,
    this.height = 56,
    this.pixelsPerSecond = 40,
    this.gap = 32,
  });

  final List<Widget> children;
  final double height;
  final double pixelsPerSecond;
  final double gap;

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  final GlobalKey _firstCopy = GlobalKey();
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 30));
  double _copyWidth = 0;
  bool _enabled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _enabled = MotionScope.enabledOf(context);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  void _measure() {
    if (!mounted) return;
    final box = _firstCopy.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    final width = box.size.width;
    if (width <= 0) return;
    if (width != _copyWidth) {
      setState(() => _copyWidth = width);
    }
    if (_enabled) {
      final ms = (width / widget.pixelsPerSecond * 1000).round();
      _controller.duration = Duration(milliseconds: ms);
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _copy({Key? key}) {
    return Row(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final c in widget.children) ...[
          c,
          SizedBox(width: widget.gap),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.centerLeft,
          minWidth: 0,
          maxWidth: double.infinity,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Transform.translate(
              offset: Offset(-_controller.value * _copyWidth, 0),
              child: child,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _copy(key: _firstCopy),
                ExcludeSemantics(child: _copy()),
                ExcludeSemantics(child: _copy()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
