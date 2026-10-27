import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../motion/tilt_3d.dart';

/// Cartão de benefício: ícone, título, descrição e um exemplo prático.
/// Inclina em 3D com reflexo de luz ao passar o mouse.
class BenefitCard extends StatefulWidget {
  const BenefitCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.example,
  });

  final IconData icon;
  final String title;
  final String description;
  final String example;

  @override
  State<BenefitCard> createState() => _BenefitCardState();
}

class _BenefitCardState extends State<BenefitCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const radius = BorderRadius.all(Radius.circular(20));

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Tilt3D.child(
        maxAngle: 0.16,
        hoverScale: 1.02,
        glare: true,
        borderRadius: radius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: radius,
            border: Border.all(
              color: _hover ? AppColors.redTintStrong : AppColors.border,
            ),
            boxShadow: [
              BoxShadow(
                color: _hover ? AppColors.shadowMedium : AppColors.shadowSoft,
                blurRadius: _hover ? 32 : 18,
                offset: Offset(0, _hover ? 18 : 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _hover ? AppColors.red : AppColors.redTint,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: _hover
                      ? const [
                          BoxShadow(
                            color: AppColors.redShadow,
                            blurRadius: 16,
                            offset: Offset(0, 8),
                          ),
                        ]
                      : const [],
                ),
                child: Icon(
                  widget.icon,
                  color: _hover ? AppColors.white : AppColors.red,
                  size: 28,
                ),
              ),
              const SizedBox(height: 20),
              Semantics(
                header: true,
                child: Text(widget.title, style: theme.textTheme.titleLarge),
              ),
              const SizedBox(height: 10),
              Text(widget.description, style: theme.textTheme.bodyMedium),
              const Spacer(),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceGray,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lightbulb_outline_rounded,
                      size: 18,
                      color: AppColors.redDark,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.example,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.45,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textStrong,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
