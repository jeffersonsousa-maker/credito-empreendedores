import 'package:flutter/material.dart';

import '../../config/app_config.dart';
import '../../core/breakpoints.dart';
import '../../theme/app_colors.dart';
import '../common/whatsapp_glyph.dart';

/// Seção 10 — Rodapé.
class AppFooter extends StatelessWidget {
  const AppFooter({
    super.key,
    required this.onWhatsApp,
    required this.onOpenPrivacy,
  });

  final VoidCallback onWhatsApp;
  final VoidCallback onOpenPrivacy;

  @override
  Widget build(BuildContext context) {
    final width = Breakpoints.widthOf(context);
    final h = Breakpoints.horizontalPadding(width);
    final wide = width >= 860;
    final year = DateTime.now().year;

    const linkStyle = TextStyle(
      color: AppColors.white,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
      decorationColor: AppColors.footerText,
    );

    final brand = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.storefront_rounded,
                color: AppColors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            const Flexible(
              child: Text(
                AppConfig.siteName,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Text(
          'Atendimento para quem empreende, comercializa ou trabalha por conta própria.',
          style: TextStyle(color: AppColors.footerText, fontSize: 15, height: 1.5),
        ),
      ],
    );

    final links = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contato e informações',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        _FooterLink(
          onTap: onWhatsApp,
          semanticsLabel: 'Falar pelo WhatsApp, ${AppConfig.whatsappDisplay}',
          leading: const WhatsAppGlyph(size: 18, color: AppColors.white),
          child: const Text(
            'WhatsApp: ${AppConfig.whatsappDisplay}',
            style: linkStyle,
          ),
        ),
        _FooterLink(
          onTap: onOpenPrivacy,
          semanticsLabel: 'Abrir o Aviso de Privacidade',
          leading: const Icon(
            Icons.privacy_tip_outlined,
            size: 18,
            color: AppColors.white,
          ),
          child: const Text('Aviso de Privacidade', style: linkStyle),
        ),
      ],
    );

    const disclaimerStyle = TextStyle(
      color: AppColors.footerText,
      fontSize: 13.5,
      height: 1.55,
    );

    return Container(
      width: double.infinity,
      color: AppColors.footer,
      // Espaço extra embaixo para o botão flutuante não cobrir o conteúdo.
      padding: EdgeInsets.fromLTRB(h, 56, h, 104),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
          child: Semantics(
            container: true,
            label: 'Rodapé',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (wide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: brand),
                      const SizedBox(width: 48),
                      Expanded(flex: 2, child: links),
                    ],
                  )
                else ...[
                  brand,
                  const SizedBox(height: 28),
                  links,
                ],
                const SizedBox(height: 32),
                const Divider(color: Color(0xFF2E2E35)),
                const SizedBox(height: 24),
                const Text(
                  'O preenchimento do formulário não garante a concessão de crédito. '
                  'As condições dependem da análise aplicável.',
                  style: disclaimerStyle,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Este site não é um canal oficial de instituição financeira e '
                  'não solicita senhas nem dados bancários.',
                  style: disclaimerStyle,
                ),
                const SizedBox(height: 16),
                Text(
                  '© $year ${AppConfig.siteName}',
                  style: disclaimerStyle.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({
    required this.onTap,
    required this.child,
    required this.leading,
    required this.semanticsLabel,
  });

  final VoidCallback onTap;
  final Widget child;
  final Widget leading;
  final String semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      label: semanticsLabel,
      excludeSemantics: true,
      onTap: onTap,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              leading,
              const SizedBox(width: 10),
              Flexible(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
