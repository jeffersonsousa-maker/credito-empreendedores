import 'package:flutter/material.dart';

import '../../core/breakpoints.dart';
import '../../theme/app_colors.dart';
import '../common/app_buttons.dart';
import '../common/section_container.dart';
import '../common/section_heading.dart';
import '../motion/ambient.dart';
import '../motion/reveal.dart';
import '../motion/tilt_3d.dart';

/// Banner principal com título, textos, botões e a foto da equipe em 3D.
class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    required this.onWantToKnowMore,
    required this.onWhatsApp,
  });

  static const String teamImage = 'assets/images/equipe.webp';

  final VoidCallback onWantToKnowMore;
  final VoidCallback onWhatsApp;

  @override
  Widget build(BuildContext context) {
    final width = Breakpoints.widthOf(context);
    final desktop = Breakpoints.isDesktop(width);
    final mobile = Breakpoints.isMobile(width);

    final text = _HeroText(
      mobile: mobile,
      onWantToKnowMore: onWantToKnowMore,
      onWhatsApp: onWhatsApp,
    );
    const visual = Reveal(
      style: RevealStyle.pop,
      delay: Duration(milliseconds: 250),
      duration: Duration(milliseconds: 900),
      child: _HeroVisual(),
    );

    return SectionContainer(
      verticalPadding: desktop ? 56 : 32,
      bottomPadding: desktop ? 96 : 64,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.white, Color(0xFFFFF3F3)],
        ),
      ),
      child: desktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 11, child: text),
                const SizedBox(width: 56),
                const Expanded(flex: 10, child: visual),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                text,
                SizedBox(height: mobile ? 48 : 64),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child: visual,
                  ),
                ),
              ],
            ),
    );
  }
}

class _HeroText extends StatelessWidget {
  const _HeroText({
    required this.mobile,
    required this.onWantToKnowMore,
    required this.onWhatsApp,
  });

  final bool mobile;
  final VoidCallback onWantToKnowMore;
  final VoidCallback onWhatsApp;

  static Duration _step(int i) => Duration(milliseconds: 80 + i * 90);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.displayMedium?.copyWith(
      fontSize: mobile ? 38 : 56,
      letterSpacing: mobile ? -0.8 : -1.5,
    );

    final buttons = mobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PrimaryButton(
                label: 'QUERO SABER MAIS',
                icon: Icons.arrow_downward_rounded,
                large: true,
                expand: true,
                onPressed: onWantToKnowMore,
              ),
              const SizedBox(height: 14),
              WhatsAppButton(
                label: 'Falar pelo WhatsApp',
                variant: WhatsAppButtonVariant.outlined,
                large: true,
                expand: true,
                onPressed: onWhatsApp,
              ),
            ],
          )
        : Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              PrimaryButton(
                label: 'QUERO SABER MAIS',
                icon: Icons.arrow_downward_rounded,
                large: true,
                onPressed: onWantToKnowMore,
              ),
              WhatsAppButton(
                label: 'Falar pelo WhatsApp',
                variant: WhatsAppButtonVariant.outlined,
                large: true,
                onPressed: onWhatsApp,
              ),
            ],
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Reveal(
          delay: _step(0),
          child: const Eyebrow(text: 'Crédito para pequenos negócios'),
        ),
        const SizedBox(height: 20),
        Reveal(
          delay: _step(1),
          child: Semantics(
            header: true,
            child: Text.rich(
              const TextSpan(
                children: [
                  TextSpan(text: 'Seu negócio pode ir '),
                  TextSpan(
                    text: 'mais longe!',
                    style: TextStyle(color: AppColors.red),
                  ),
                ],
              ),
              style: titleStyle,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Reveal(
          delay: _step(2),
          child: Text(
            'Conheça as possibilidades de crédito para investir no seu '
            'negócio, fortalecer seu estoque e conquistar novas oportunidades.',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: mobile ? 18 : 19.5,
              color: AppColors.textStrong,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Reveal(
          delay: _step(3),
          child: Text(
            'Se você é empreendedor, comerciante ou trabalha por conta própria, '
            'dê o próximo passo para o crescimento do seu negócio.',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: mobile ? 16 : 17,
              color: AppColors.textMuted,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Reveal(delay: _step(4), child: buttons),
        const SizedBox(height: 26),
        Reveal(
          delay: _step(5),
          child: const Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              _TrustItem(text: 'Atendimento pelo WhatsApp'),
              _TrustItem(text: 'Sem CPF ou documentos nesta etapa'),
              _TrustItem(text: 'Conversar não gera compromisso'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Reveal(
          delay: _step(6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_rounded,
                size: 18,
                color: AppColors.redDark,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Atendimento em São Raimundo Nonato (PI), Remanso (BA), '
                  'Pilão Arcado (BA), Campo Alegre de Lourdes (BA) e outros municípios '
                  'do Piauí.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrustItem extends StatelessWidget {
  const _TrustItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.check_circle_rounded,
          size: 20,
          color: AppColors.red,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
        ),
      ],
    );
  }
}

/// Foto da equipe sobre um cartão vermelho. Com o mouse, tudo inclina em 3D
/// e cada camada se move numa profundidade diferente (paralaxe).
class _HeroVisual extends StatelessWidget {
  const _HeroVisual();

  static const double _imageAspect = 1100 / 744;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final imageH = w / _imageAspect;
        final cardTop = imageH * 0.22;
        final small = w < 460;

        return Tilt3D(
          maxAngle: 0.10,
          builder: (context, tilt) {
            Offset layer(double depth) => Offset(tilt.dx * depth, tilt.dy * depth);

            return SizedBox(
              width: w,
              height: imageH,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Camada de trás: cartão vermelho.
                  Positioned(
                    left: 0,
                    right: 0,
                    top: cardTop,
                    bottom: 0,
                    child: Transform.translate(
                      offset: layer(-10),
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(28)),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.red, AppColors.redDeep],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.redShadow,
                              blurRadius: 44,
                              offset: Offset(0, 22),
                            ),
                          ],
                        ),
                        child: _CardPattern(),
                      ),
                    ),
                  ),
                  // Camada do meio: a equipe.
                  Positioned.fill(
                    child: Transform.translate(
                      offset: layer(6),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(28),
                        ),
                        child: Image.asset(
                          HeroSection.teamImage,
                          fit: BoxFit.contain,
                          alignment: Alignment.bottomCenter,
                          filterQuality: FilterQuality.medium,
                          semanticLabel:
                              'Três agentes de atendimento sorrindo; um deles '
                              'aponta para uma maquininha de cartão.',
                        ),
                      ),
                    ),
                  ),
                  // Camada da frente: selos flutuantes.
                  Positioned(
                    left: small ? -10 : -24,
                    top: imageH * 0.34,
                    child: Transform.translate(
                      offset: layer(22),
                      child: FloatingBob(
                        phase: 0.1,
                        child: _FloatChip(
                          icon: Icons.inventory_2_rounded,
                          label: 'Mais estoque',
                          compact: small,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: small ? -10 : -24,
                    top: imageH * 0.50,
                    child: Transform.translate(
                      offset: layer(26),
                      child: FloatingBob(
                        phase: 0.55,
                        child: _FloatChip(
                          icon: Icons.construction_rounded,
                          label: 'Novos equipamentos',
                          compact: small,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: small ? 8 : 16,
                    bottom: small ? 12 : 22,
                    child: Transform.translate(
                      offset: layer(18),
                      child: FloatingBob(
                        phase: 0.3,
                        amplitude: 5,
                        child: _FloatingBadge(compact: small),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _CardPattern extends StatelessWidget {
  const _CardPattern();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(28)),
      child: Stack(
        children: [
          Positioned(
            right: -60,
            top: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x14FFFFFF),
              ),
            ),
          ),
          Positioned(
            left: -40,
            bottom: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x10FFFFFF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatChip extends StatelessWidget {
  const _FloatChip({
    required this.icon,
    required this.label,
    required this.compact,
  });

  final IconData icon;
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 14,
        vertical: compact ? 7 : 9,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.redTintStrong),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 16 : 18, color: AppColors.red),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: compact ? 12 : 13.5,
              fontWeight: FontWeight.w800,
              color: AppColors.textStrong,
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingBadge extends StatelessWidget {
  const _FloatingBadge({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 16,
        vertical: compact ? 10 : 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 34 : 40,
            height: compact ? 34 : 40,
            decoration: const BoxDecoration(
              color: AppColors.redTint,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.support_agent_rounded,
              color: AppColors.redDark,
              size: compact ? 20 : 22,
            ),
          ),
          SizedBox(width: compact ? 8 : 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Atendimento humano',
                style: TextStyle(
                  fontSize: compact ? 13.5 : 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textStrong,
                ),
              ),
              Text(
                'Converse com a nossa equipe',
                style: TextStyle(
                  fontSize: compact ? 12 : 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
