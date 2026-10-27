import 'package:flutter/material.dart';

import '../../core/breakpoints.dart';
import '../../theme/app_colors.dart';
import '../common/app_buttons.dart';
import '../motion/ambient.dart';
import '../motion/reveal.dart';

/// Seção 9 — Chamada final em fundo vermelho, com círculos de luz
/// flutuando em profundidades diferentes.
class FinalCtaSection extends StatelessWidget {
  const FinalCtaSection({super.key, required this.onWhatsApp});

  static const String agentImage = 'assets/images/agente_bracos_cruzados.webp';

  final VoidCallback onWhatsApp;

  @override
  Widget build(BuildContext context) {
    final width = Breakpoints.widthOf(context);
    final h = Breakpoints.horizontalPadding(width);
    final mobile = Breakpoints.isMobile(width);
    final showPhoto = width >= 760;

    final text = Column(
      crossAxisAlignment:
          showPhoto ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          header: true,
          child: Text(
            'Seu próximo passo começa com uma conversa.',
            textAlign: showPhoto ? TextAlign.start : TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.white,
                  fontSize: mobile ? 30 : 40,
                ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Conte um pouco sobre o seu negócio e conheça as possibilidades de '
          'crédito disponíveis para sua atividade.',
          textAlign: showPhoto ? TextAlign.start : TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.whiteSoft,
              ),
        ),
        const SizedBox(height: 30),
        WhatsAppButton(
          label: 'FALAR COM UM ATENDENTE',
          variant: WhatsAppButtonVariant.onRed,
          large: true,
          expand: mobile,
          onPressed: onWhatsApp,
        ),
      ],
    );

    final content = showPhoto
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 13,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 80),
                  child: Reveal(child: text),
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Reveal(
                    style: RevealStyle.slideLeft,
                    duration: const Duration(milliseconds: 900),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 440),
                      child: Image.asset(
                        agentImage,
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomCenter,
                        filterQuality: FilterQuality.medium,
                        semanticLabel:
                            'Agente de atendimento sorrindo, de braços cruzados.',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Padding(
            padding: EdgeInsets.symmetric(vertical: mobile ? 64 : 80),
            child: Reveal(child: text),
          );

    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.red, AppColors.redDark],
        ),
      ),
      child: Stack(
        children: [
          const Positioned(
            left: -80,
            top: -90,
            child: FloatingBob(
              amplitude: 14,
              period: Duration(milliseconds: 6000),
              child: _Orb(size: 260, opacity: 0x1A),
            ),
          ),
          const Positioned(
            right: -60,
            bottom: -120,
            child: FloatingBob(
              amplitude: 18,
              period: Duration(milliseconds: 7200),
              phase: 0.4,
              child: _Orb(size: 320, opacity: 0x14),
            ),
          ),
          const Positioned(
            right: 120,
            top: 40,
            child: FloatingBob(
              amplitude: 10,
              period: Duration(milliseconds: 5200),
              phase: 0.7,
              child: _Orb(size: 70, opacity: 0x22),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: h),
            child: Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
                child: content,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Círculo de luz translúcido.
class _Orb extends StatelessWidget {
  const _Orb({required this.size, required this.opacity});

  final double size;
  final int opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Color.fromARGB(opacity, 255, 255, 255),
            const Color(0x00FFFFFF),
          ],
        ),
        border: Border.all(color: Color.fromARGB(opacity, 255, 255, 255)),
      ),
    );
  }
}
