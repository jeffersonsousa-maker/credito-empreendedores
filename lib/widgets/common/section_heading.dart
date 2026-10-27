import 'package:flutter/material.dart';

import '../../core/breakpoints.dart';
import '../../theme/app_colors.dart';

/// Título de seção com chamada curta (eyebrow) e texto de apoio opcionais.
class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    this.eyebrow,
    this.subtitle,
    this.center = false,
    this.light = false,
    this.maxWidth = 720,
  });

  final String title;
  final String? eyebrow;
  final String? subtitle;
  final bool center;
  final bool light;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = Breakpoints.widthOf(context);
    final mobile = Breakpoints.isMobile(width);
    final align = center ? TextAlign.center : TextAlign.start;
    final cross = center ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    final titleStyle =
        (mobile ? theme.textTheme.headlineMedium : theme.textTheme.headlineLarge)
            ?.copyWith(color: light ? AppColors.white : AppColors.textStrong);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Column(
        crossAxisAlignment: cross,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (eyebrow != null) ...[
            Eyebrow(text: eyebrow!, light: light),
            const SizedBox(height: 14),
          ],
          Semantics(
            header: true,
            child: Text(title, textAlign: align, style: titleStyle),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 14),
            Text(
              subtitle!,
              textAlign: align,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: light ? AppColors.whiteSoft : AppColors.text,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Etiqueta curta acima dos títulos.
class Eyebrow extends StatelessWidget {
  const Eyebrow({super.key, required this.text, this.light = false});

  final String text;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: light ? AppColors.whiteTranslucent : AppColors.redTint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
          color: light ? AppColors.white : AppColors.redDark,
        ),
      ),
    );
  }
}
