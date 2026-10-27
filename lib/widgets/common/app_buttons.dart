import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../motion/motion.dart';
import 'whatsapp_glyph.dart';

/// Botão principal vermelho, com profundidade 3D (afunda ao tocar).
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = false,
    this.large = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      minimumSize: Size(expand ? double.infinity : 48, large ? 58 : 52),
      textStyle: TextStyle(
        fontFamily: AppTheme.fontFamily,
        fontSize: large ? 16.5 : 15.5,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.4,
      ),
    ).copyWith(
      elevation: const WidgetStatePropertyAll<double>(0),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) return AppColors.redDeep;
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return AppColors.redDark;
        }
        return null;
      }),
    );

    final text = Text(label, textAlign: TextAlign.center);
    final button = icon == null
        ? FilledButton(onPressed: onPressed, style: style, child: text)
        : FilledButton.icon(
            onPressed: onPressed,
            style: style,
            icon: Icon(icon, size: 20),
            label: text,
          );

    return Depth3D(
      edgeColor: AppColors.redDeep,
      glowColor: AppColors.redShadow,
      child: button,
    );
  }
}

enum WhatsAppButtonVariant { filled, outlined, onRed }

/// Botão de contato pelo WhatsApp.
class WhatsAppButton extends StatelessWidget {
  const WhatsAppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = WhatsAppButtonVariant.filled,
    this.expand = false,
    this.large = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final WhatsAppButtonVariant variant;
  final bool expand;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final minSize = Size(expand ? double.infinity : 48, large ? 58 : 52);
    final textStyle = TextStyle(
      fontFamily: AppTheme.fontFamily,
      fontSize: large ? 16.5 : 15.5,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.3,
    );

    switch (variant) {
      case WhatsAppButtonVariant.filled:
        return Depth3D(
          edgeColor: const Color(0xFF05532F),
          glowColor: const Color(0x330B8043),
          child: FilledButton.icon(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.whatsapp,
              foregroundColor: AppColors.white,
              minimumSize: minSize,
              textStyle: textStyle,
            ).copyWith(
              overlayColor: const WidgetStatePropertyAll<Color>(
                AppColors.whatsappDark,
              ),
            ),
            icon: const WhatsAppGlyph(size: 22, color: AppColors.white),
            label: Text(label, textAlign: TextAlign.center),
          ),
        );
      case WhatsAppButtonVariant.outlined:
        return Depth3D(
          edgeColor: const Color(0xFFD3D3DA),
          glowColor: AppColors.shadowSoft,
          child: OutlinedButton.icon(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              minimumSize: minSize,
              textStyle: textStyle,
              backgroundColor: AppColors.white,
            ),
            icon: const WhatsAppGlyph(size: 22, color: AppColors.whatsapp),
            label: Text(label, textAlign: TextAlign.center),
          ),
        );
      case WhatsAppButtonVariant.onRed:
        return Depth3D(
          edgeColor: const Color(0xFFF0B3B6),
          glowColor: const Color(0x40000000),
          child: FilledButton.icon(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.redDark,
              minimumSize: minSize,
              textStyle: textStyle,
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            ).copyWith(
              overlayColor: const WidgetStatePropertyAll<Color>(
                AppColors.redTint,
              ),
            ),
            icon: const WhatsAppGlyph(size: 22, color: AppColors.whatsapp),
            label: Text(label, textAlign: TextAlign.center),
          ),
        );
    }
  }
}

/// Dá aos botões uma "borda de baixo" sólida, como uma tecla: sobe um pouco
/// ao passar o mouse e afunda ao tocar.
class Depth3D extends StatefulWidget {
  const Depth3D({
    super.key,
    required this.child,
    required this.edgeColor,
    required this.glowColor,
    this.radius = 12,
  });

  final Widget child;
  final Color edgeColor;
  final Color glowColor;
  final double radius;

  @override
  State<Depth3D> createState() => _Depth3DState();
}

class _Depth3DState extends State<Depth3D> {
  bool _hover = false;
  bool _pressed = false;

  void _setPressed(bool v) {
    if (_pressed != v) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final animate = MotionScope.enabledOf(context);
    final lift = _pressed ? 4.0 : (_hover ? -2.0 : 0.0);
    final edge = _pressed ? 1.0 : (_hover ? 7.0 : 5.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _pressed = false;
      }),
      child: Listener(
        onPointerDown: (_) => _setPressed(true),
        onPointerUp: (_) => _setPressed(false),
        onPointerCancel: (_) => _setPressed(false),
        child: AnimatedContainer(
          duration:
              animate ? const Duration(milliseconds: 120) : Duration.zero,
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(0, lift, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            boxShadow: [
              BoxShadow(color: widget.edgeColor, offset: Offset(0, edge)),
              BoxShadow(
                color: widget.glowColor,
                blurRadius: _hover ? 26 : 16,
                offset: Offset(0, edge + 8),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
