import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../common/section_container.dart';
import '../common/section_heading.dart';
import '../motion/reveal.dart';

/// Seção 7 — Como funciona (três etapas).
class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  static const _steps = [
    (
      icon: Icons.edit_note_rounded,
      title: 'Informe seus dados',
      text:
          'Preencha o formulário com seu telefone, município e atividade comercial.',
    ),
    (
      icon: Icons.chat_outlined,
      title: 'Inicie o atendimento',
      text: 'Abra o WhatsApp e envie a mensagem para iniciar a conversa.',
    ),
    (
      icon: Icons.lightbulb_outline_rounded,
      title: 'Conheça as possibilidades',
      text:
          'Receba orientações sobre os requisitos, as condições disponíveis e as próximas etapas de uma eventual solicitação de crédito.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      background: AppColors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontal = constraints.maxWidth >= 860;
          final steps = <Widget>[
            for (var i = 0; i < _steps.length; i++)
              Reveal(
                style: horizontal ? RevealStyle.flip : RevealStyle.slideLeft,
                delay: Duration(milliseconds: 160 * i),
                duration: const Duration(milliseconds: 800),
                child: _StepCard(
                  number: i + 1,
                  icon: _steps[i].icon,
                  title: _steps[i].title,
                  text: _steps[i].text,
                  last: i == _steps.length - 1,
                  horizontal: horizontal,
                ),
              ),
          ];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Reveal(
                  child: SectionHeading(
                    eyebrow: 'Passo a passo',
                    title: 'Como funciona?',
                    subtitle:
                        'Um caminho simples para começar a conversa. A contratação não é automática: ela depende da análise e dos critérios aplicáveis.',
                    center: true,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              if (horizontal)
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < steps.length; i++) ...[
                        if (i > 0) const SizedBox(width: 20),
                        Expanded(child: steps[i]),
                      ],
                    ],
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: steps,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.number,
    required this.icon,
    required this.title,
    required this.text,
    required this.last,
    required this.horizontal,
  });

  final int number;
  final IconData icon;
  final String title;
  final String text;
  final bool last;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badge = Container(
      width: 52,
      height: 52,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.red,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.redShadow,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        '$number',
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
    );

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.redDark, size: 22),
            const SizedBox(width: 8),
            Text(
              'Etapa $number',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                color: AppColors.redDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Semantics(
          header: true,
          child: Text(title, style: theme.textTheme.titleLarge),
        ),
        const SizedBox(height: 8),
        Text(text, style: theme.textTheme.bodyMedium),
      ],
    );

    if (horizontal) {
      return Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.surfaceGray,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                badge,
                if (!last) ...[
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Divider(
                      color: AppColors.redTintStrong,
                      thickness: 2,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
            body,
          ],
        ),
      );
    }

    // Layout vertical (celular/tablet): linha do tempo à esquerda.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              badge,
              if (!last)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: AppColors.redTintStrong,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 4, bottom: last ? 0 : 32),
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}
