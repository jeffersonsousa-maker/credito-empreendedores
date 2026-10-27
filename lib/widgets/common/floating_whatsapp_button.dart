import 'package:flutter/material.dart';

import '../../core/breakpoints.dart';
import '../../theme/app_colors.dart';
import '../motion/ambient.dart';
import 'whatsapp_glyph.dart';

/// Botão flutuante do WhatsApp (canto inferior direito).
///
/// Some enquanto o formulário está na tela para não cobrir campos e o botão
/// de envio.
class FloatingWhatsAppButton extends StatelessWidget {
  const FloatingWhatsAppButton({
    super.key,
    required this.onPressed,
    required this.visible,
  });

  final VoidCallback onPressed;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    final mobile = Breakpoints.isMobile(Breakpoints.widthOf(context));

    final button = mobile
        ? FloatingActionButton(
            heroTag: 'whatsapp-fab',
            onPressed: onPressed,
            tooltip: 'Falar pelo WhatsApp',
            backgroundColor: AppColors.whatsapp,
            foregroundColor: AppColors.white,
            elevation: 4,
            shape: const CircleBorder(),
            child: const WhatsAppGlyph(size: 28, color: AppColors.white),
          )
        : FloatingActionButton.extended(
            heroTag: 'whatsapp-fab',
            onPressed: onPressed,
            tooltip: 'Falar pelo WhatsApp',
            backgroundColor: AppColors.whatsapp,
            foregroundColor: AppColors.white,
            elevation: 4,
            shape: const StadiumBorder(),
            icon: const WhatsAppGlyph(size: 24, color: AppColors.white),
            label: const Text(
              'WhatsApp',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          );

    return IgnorePointer(
      ignoring: !visible,
      child: ExcludeSemantics(
        excluding: !visible,
        child: AnimatedSlide(
          offset: visible ? Offset.zero : const Offset(0, 1.6),
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          child: AnimatedOpacity(
            opacity: visible ? 1 : 0,
            duration: const Duration(milliseconds: 180),
            child: PulseRing(color: AppColors.whatsapp, child: button),
          ),
        ),
      ),
    );
  }
}
