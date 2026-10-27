import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../common/section_container.dart';
import '../common/section_heading.dart';
import '../motion/reveal.dart';

/// Seção 8 — Perguntas frequentes (expande e recolhe).
class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

  static const faqs = [
    (
      q: 'Quem pode demonstrar interesse?',
      a: 'Empreendedores, comerciantes e trabalhadores por conta própria que desejam conhecer as possibilidades de crédito para seus negócios.',
    ),
    (
      q: 'Preencher o formulário garante a aprovação?',
      a: 'Não. O formulário serve para iniciar o atendimento. A concessão do crédito depende dos critérios e da análise aplicáveis.',
    ),
    (
      q: 'Preciso ter um negócio em funcionamento?',
      a: 'Os requisitos dependem da modalidade de crédito disponível. Durante o atendimento, você poderá esclarecer quais condições se aplicam à sua atividade.',
    ),
    (
      q: 'Como entro em contato?',
      a: 'Você pode preencher o formulário ou clicar no botão do WhatsApp para iniciar uma conversa.',
    ),
    (
      q: 'Quais municípios são atendidos?',
      a: 'São Raimundo Nonato e outros municípios do Piauí, além de Remanso, Pilão Arcado e Campo Alegre de Lourdes, na Bahia, conforme a área de atendimento definida neste projeto.',
    ),
    (
      q: 'Quais documentos vou precisar?',
      a: 'Nesta primeira etapa, nenhum. Se você decidir seguir com uma solicitação, o atendente informa quais documentos a modalidade escolhida exige.',
    ),
    (
      q: 'Preciso ser MEI ou ter CNPJ?',
      a: 'Depende da modalidade. No atendimento, você descobre quais requisitos se aplicam ao seu caso, tenha você CNPJ ou não.',
    ),
    (
      q: 'Tenho que pagar alguma coisa para conversar?',
      a: 'Não. Conversar pelo WhatsApp para tirar dúvidas é gratuito e não gera compromisso. Desconfie de qualquer pedido de pagamento antecipado para liberar crédito.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      background: AppColors.surfaceGray,
      maxWidth: 860,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(
            child: Reveal(
              child: SectionHeading(
                eyebrow: 'Dúvidas',
                title: 'Perguntas frequentes',
                center: true,
              ),
            ),
          ),
          const SizedBox(height: 40),
          for (var i = 0; i < faqs.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Reveal(
                delay: Duration(milliseconds: 70 * i),
                duration: const Duration(milliseconds: 600),
                child: FaqItem(
                  question: faqs[i].q,
                  answer: faqs[i].a,
                  initiallyExpanded: i == 0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class FaqItem extends StatelessWidget {
  const FaqItem({
    super.key,
    required this.question,
    required this.answer,
    this.initiallyExpanded = false,
  });

  final String question;
  final String answer;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );
    // Material (e não Container) para o efeito de toque do ExpansionTile
    // aparecer sobre o fundo branco.
    return Material(
      color: AppColors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Theme(
        // Remove as linhas divisórias padrão do ExpansionTile.
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          shape: shape,
          collapsedShape: shape,
          tilePadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
          childrenPadding: const EdgeInsets.fromLTRB(22, 0, 22, 20),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          iconColor: AppColors.red,
          collapsedIconColor: AppColors.textMuted,
          textColor: AppColors.textStrong,
          collapsedTextColor: AppColors.textStrong,
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 17,
              height: 1.35,
              fontWeight: FontWeight.w700,
            ),
          ),
          children: [
            Text(answer, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
