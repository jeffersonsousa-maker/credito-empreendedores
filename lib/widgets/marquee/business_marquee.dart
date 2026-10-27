import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../motion/ambient.dart';

/// Faixa vermelha com tipos de negócio passando em loop.
class BusinessMarquee extends StatelessWidget {
  const BusinessMarquee({super.key});

  static const _items = [
    (icon: Icons.local_grocery_store_rounded, text: 'Mercadinhos'),
    (icon: Icons.content_cut_rounded, text: 'Salões e barbearias'),
    (icon: Icons.lunch_dining_rounded, text: 'Lanchonetes'),
    (icon: Icons.build_rounded, text: 'Oficinas'),
    (icon: Icons.checkroom_rounded, text: 'Lojas de roupas'),
    (icon: Icons.storefront_rounded, text: 'Feirantes'),
    (icon: Icons.agriculture_rounded, text: 'Produção rural'),
    (icon: Icons.shopping_bag_rounded, text: 'Vendedores autônomos'),
    (icon: Icons.handyman_rounded, text: 'Prestadores de serviço'),
  ];

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Tipos de negócio atendidos: '
          '${_items.map((i) => i.text).join(', ')}.',
      excludeSemantics: true,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.redDark, AppColors.red, AppColors.redDark],
          ),
        ),
        child: Marquee(
          height: 60,
          gap: 28,
          pixelsPerSecond: 45,
          children: [
            for (final item in _items)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(item.icon, color: AppColors.white, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    item.text,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(width: 28),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0x80FFFFFF),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
