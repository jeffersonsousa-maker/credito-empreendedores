import 'package:flutter/material.dart';

import '../../core/breakpoints.dart';
import '../../models/form_options.dart';
import '../../theme/app_colors.dart';
import '../common/responsive_grid.dart';
import '../common/section_container.dart';
import '../common/section_heading.dart';
import '../motion/motion.dart';
import '../motion/reveal.dart';

/// Seção 4 — Quem pode demonstrar interesse, com a área de atendimento.
class AudienceSection extends StatelessWidget {
  const AudienceSection({super.key});

  static const _activities = [
    (icon: Icons.local_grocery_store_outlined, text: 'Mercadinhos e mercearias'),
    (icon: Icons.checkroom_outlined, text: 'Lojas de roupas e calçados'),
    (icon: Icons.content_cut_rounded, text: 'Salões de beleza e barbearias'),
    (icon: Icons.restaurant_outlined, text: 'Lanchonetes e pequenos restaurantes'),
    (icon: Icons.shopping_bag_outlined, text: 'Vendedores autônomos'),
    (icon: Icons.build_outlined, text: 'Oficinas e prestadores de serviços'),
    (icon: Icons.agriculture_outlined, text: 'Pequenos produtores e comerciantes'),
    (icon: Icons.add_business_outlined, text: 'Outros pequenos negócios'),
  ];

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      background: AppColors.white,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final desktop = w >= 960;
          final columns = w >= 520 ? 2 : 1;

          final intro = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Reveal(
                child: SectionHeading(
                  eyebrow: 'Quem pode demonstrar interesse?',
                  title: 'Você trabalha por conta própria?',
                  subtitle:
                      'O atendimento é voltado a empreendedores que desejam conhecer as possibilidades de crédito para suas atividades comerciais.',
                ),
              ),
              const SizedBox(height: 28),
              Reveal(
                delay: const Duration(milliseconds: 120),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceGray,
                    borderRadius: BorderRadius.circular(14),
                    border: const Border(
                      left: BorderSide(color: AppColors.red, width: 4),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.redDark,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'A disponibilidade do crédito e as condições de contratação dependem da análise e dos critérios aplicáveis à operação.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: AppColors.textStrong,
                                fontSize: 15,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Reveal(
                delay: Duration(milliseconds: 200),
                child: _ServiceArea(),
              ),
            ],
          );

          final grid = ResponsiveGrid(
            columns: columns,
            spacing: 14,
            runSpacing: 14,
            children: [
              for (var i = 0; i < _activities.length; i++)
                Reveal(
                  style: RevealStyle.pop,
                  delay: Duration(milliseconds: 60 * i),
                  duration: const Duration(milliseconds: 550),
                  child: _ActivityTile(
                    icon: _activities[i].icon,
                    text: _activities[i].text,
                  ),
                ),
            ],
          );

          if (desktop) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 10, child: intro),
                const SizedBox(width: 56),
                Expanded(flex: 11, child: grid),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              intro,
              SizedBox(height: Breakpoints.isMobile(w) ? 32 : 40),
              grid,
            ],
          );
        },
      ),
    );
  }
}

/// Área de atendimento definida no projeto.
class _ServiceArea extends StatelessWidget {
  const _ServiceArea();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ÁREA DE ATENDIMENTO',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final m in FormOptions.municipalities)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.redTint,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: AppColors.redDark,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        m,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textStrong,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _ActivityTile extends StatefulWidget {
  const _ActivityTile({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  State<_ActivityTile> createState() => _ActivityTileState();
}

class _ActivityTileState extends State<_ActivityTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final animate = MotionScope.enabledOf(context);
    final duration =
        animate ? const Duration(milliseconds: 200) : Duration.zero;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: duration,
        curve: Curves.easeOut,
        transform: perspective3D(
          translateY: _hover ? -4 : 0,
          rotateX: _hover ? 0.08 : 0,
        ),
        transformAlignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hover ? AppColors.redTintStrong : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: _hover ? AppColors.shadowMedium : const Color(0x00000000),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: duration,
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _hover ? AppColors.red : AppColors.redTint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                widget.icon,
                color: _hover ? AppColors.white : AppColors.red,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                widget.text,
                style: const TextStyle(
                  fontSize: 15.5,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textStrong,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
