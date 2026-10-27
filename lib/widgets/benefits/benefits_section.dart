import 'package:flutter/material.dart';

import '../../core/breakpoints.dart';
import '../../theme/app_colors.dart';
import '../common/responsive_grid.dart';
import '../common/section_container.dart';
import '../common/section_heading.dart';
import '../motion/reveal.dart';
import 'benefit_card.dart';

/// Seção 3 — Benefícios do crédito, com exemplos do dia a dia.
class BenefitsSection extends StatelessWidget {
  const BenefitsSection({super.key});

  static const _items = [
    (
      icon: Icons.inventory_2_outlined,
      title: 'Fortaleça seu estoque',
      text:
          'Tenha a oportunidade de buscar recursos para ampliar a variedade de produtos do seu comércio.',
      example: 'Ex.: reforçar a mercadoria antes das festas e datas de mais movimento.',
    ),
    (
      icon: Icons.storefront_outlined,
      title: 'Invista no seu negócio',
      text:
          'Conheça possibilidades para melhorar a estrutura e as condições de funcionamento da sua atividade.',
      example: 'Ex.: um freezer novo, uma máquina de costura ou a reforma do ponto.',
    ),
    (
      icon: Icons.trending_up_rounded,
      title: 'Amplie suas oportunidades',
      text:
          'Avalie alternativas para fortalecer seu empreendimento e buscar novos clientes.',
      example: 'Ex.: começar a vender em uma nova feira ou bairro.',
    ),
    (
      icon: Icons.support_agent_rounded,
      title: 'Conte com orientação',
      text:
          'Receba informações sobre as possibilidades de crédito e entenda as próximas etapas para solicitar uma avaliação.',
      example: 'Ex.: tirar dúvidas sobre requisitos antes de decidir.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      background: AppColors.surfaceGray,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final columns = w >= 980 ? 4 : (w >= 560 ? 2 : 1);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: Reveal(
                  child: SectionHeading(
                    eyebrow: 'Benefícios',
                    title: 'Invista no crescimento do seu negócio',
                    subtitle:
                        'Um crédito pensado para quem tem um pequeno negócio e quer dar o próximo passo.',
                    center: true,
                  ),
                ),
              ),
              SizedBox(height: Breakpoints.isMobile(w) ? 36 : 52),
              ResponsiveGrid(
                columns: columns,
                children: [
                  for (var i = 0; i < _items.length; i++)
                    Reveal(
                      delay: Duration(milliseconds: 90 * (i % columns)),
                      child: BenefitCard(
                        icon: _items[i].icon,
                        title: _items[i].title,
                        description: _items[i].text,
                        example: _items[i].example,
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
