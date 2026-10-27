import 'package:flutter/material.dart';

import '../../core/breakpoints.dart';
import '../../theme/app_colors.dart';
import '../common/section_container.dart';
import '../common/section_heading.dart';
import '../motion/reveal.dart';
import 'lead_form.dart';

/// Seção 5 — Formulário de interesse (a mais importante da página).
class LeadFormSection extends StatelessWidget {
  const LeadFormSection({super.key, required this.onOpenPrivacy});

  static const String agentImage = 'assets/images/agente_apontando.webp';

  final VoidCallback onOpenPrivacy;

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFF3F3), Color(0xFFFFFAFA)],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final desktop = w >= 960;
          final mobile = Breakpoints.isMobile(Breakpoints.widthOf(context));

          const heading = Reveal(
            child: SectionHeading(
              eyebrow: 'Formulário de interesse',
              title: 'Vamos conversar sobre o seu negócio?',
              subtitle:
                  'Preencha os dados abaixo para demonstrar seu interesse e iniciar um atendimento.',
            ),
          );

          final card = Reveal(
            delay: const Duration(milliseconds: 150),
            duration: const Duration(milliseconds: 900),
            child: _StackedPaper(
              child: _FormCard(
                mobile: mobile,
                child: LeadForm(onOpenPrivacy: onOpenPrivacy),
              ),
            ),
          );

          if (desktop) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 10,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        heading,
                        const SizedBox(height: 28),
                        const Reveal(
                          delay: Duration(milliseconds: 120),
                          child: _Assurances(),
                        ),
                        const SizedBox(height: 28),
                        const Reveal(
                          style: RevealStyle.pop,
                          delay: Duration(milliseconds: 260),
                          child: _AgentPhoto(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 48),
                Expanded(flex: 11, child: card),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              heading,
              const SizedBox(height: 20),
              const Reveal(
                delay: Duration(milliseconds: 120),
                child: _Assurances(),
              ),
              SizedBox(height: mobile ? 24 : 32),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: card,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Duas folhas levemente giradas atrás do cartão, dando profundidade.
class _StackedPaper extends StatelessWidget {
  const _StackedPaper({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget sheet(double angle, double dx, double dy, Color color) {
      return Positioned.fill(
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.translationValues(dx, dy, 0)
            ..multiply(Matrix4.rotationZ(angle)),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.redTintStrong),
            ),
          ),
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        sheet(0.035, 10, 10, const Color(0xFFFBE3E4)),
        sheet(-0.022, -6, 6, const Color(0xFFFFF0F0)),
        child,
      ],
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({required this.child, required this.mobile});

  final Widget child;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(mobile ? 20 : 34),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.redTintStrong, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1AE11B22),
            blurRadius: 48,
            offset: Offset(0, 24),
          ),
          BoxShadow(
            color: AppColors.shadowSoft,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.assignment_outlined,
                  color: AppColors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Seus dados para atendimento',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textStrong,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _Assurances extends StatelessWidget {
  const _Assurances();

  static const _items = [
    (
      icon: Icons.format_list_numbered_rounded,
      text: 'Leva cerca de 1 minuto: só telefone, município e atividade.',
    ),
    (
      icon: Icons.shield_outlined,
      text: 'Sem CPF, documentos ou dados bancários nesta etapa.',
    ),
    (
      icon: Icons.visibility_outlined,
      text: 'Você confere a mensagem no WhatsApp antes de enviar.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in _items)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, size: 18, color: AppColors.red),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      item.text,
                      style: const TextStyle(
                        fontSize: 15.5,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textStrong,
                      ),
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

/// Foto de um agente apontando para o formulário (somente em telas largas).
class _AgentPhoto extends StatelessWidget {
  const _AgentPhoto();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              left: 24,
              right: 24,
              bottom: 0,
              child: Container(
                height: 150,
                decoration: const BoxDecoration(
                  color: AppColors.redTintStrong,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(200),
                    bottom: Radius.circular(24),
                  ),
                ),
              ),
            ),
            Image.asset(
              LeadFormSection.agentImage,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
              semanticLabel:
                  'Agente de atendimento sorrindo e apontando para o formulário.',
            ),
          ],
        ),
      ),
    );
  }
}
