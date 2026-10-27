import 'package:flutter/material.dart';

import '../../config/app_config.dart';
import '../../core/breakpoints.dart';
import '../../models/page_section.dart';
import '../../theme/app_colors.dart';
import '../common/app_buttons.dart';

typedef SectionNavigator = void Function(PageSection section);

/// Cabeçalho fixo: nome textual, menu e botão "Quero saber mais".
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({
    super.key,
    required this.onNavigate,
    required this.elevated,
  });

  final SectionNavigator onNavigate;
  final bool elevated;

  static const double heightDesktop = 76;
  static const double heightMobile = 66;

  @override
  Size get preferredSize => const Size.fromHeight(heightDesktop);

  @override
  Widget build(BuildContext context) {
    final width = Breakpoints.widthOf(context);
    // Menu completo só quando há espaço de sobra; abaixo disso, menu compacto.
    final desktop = width >= 1140;
    final mobile = Breakpoints.isMobile(width);
    final h = Breakpoints.horizontalPadding(width);

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: (mobile ? heightMobile : heightDesktop) +
            MediaQuery.paddingOf(context).top,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: const Border(
            bottom: BorderSide(color: AppColors.border, width: 1),
          ),
          boxShadow: elevated
              ? const [
                  BoxShadow(
                    color: AppColors.shadowSoft,
                    blurRadius: 18,
                    offset: Offset(0, 6),
                  ),
                ]
              : const [],
        ),
        padding: EdgeInsets.symmetric(horizontal: h),
        child: SafeArea(
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _Brand(
                        compact: mobile,
                        onTap: () => onNavigate(PageSection.inicio),
                      ),
                    ),
                  ),
                  if (desktop) ...[
                    for (final s in PageSection.menu)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: TextButton(
                          onPressed: () => onNavigate(s),
                          child: Text(s.label),
                        ),
                      ),
                    const SizedBox(width: 14),
                  ],
                  if (!mobile)
                    PrimaryButton(
                      label: 'Quero saber mais',
                      onPressed: () => onNavigate(PageSection.formulario),
                    ),
                  if (!desktop) ...[
                    const SizedBox(width: 8),
                    Builder(
                      builder: (ctx) => IconButton(
                        tooltip: 'Abrir menu',
                        iconSize: 28,
                        style: IconButton.styleFrom(
                          minimumSize: const Size(48, 48),
                          foregroundColor: AppColors.textStrong,
                        ),
                        onPressed: () => Scaffold.of(ctx).openEndDrawer(),
                        icon: const Icon(Icons.menu_rounded),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand({required this.compact, required this.onTap});

  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${AppConfig.siteName}, voltar ao início',
      excludeSemantics: true,
      onTap: onTap,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: compact ? 38 : 42,
                height: compact ? 38 : 42,
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  Icons.storefront_rounded,
                  color: AppColors.white,
                  size: compact ? 22 : 24,
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Crédito',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: compact ? 16.5 : 18,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textStrong,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Text(
                      'para Empreendedores',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: compact ? 12.5 : 13,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                        color: AppColors.redDark,
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

/// Menu lateral para celulares e tablets.
class MobileMenuDrawer extends StatelessWidget {
  const MobileMenuDrawer({super.key, required this.onNavigate});

  final SectionNavigator onNavigate;

  @override
  Widget build(BuildContext context) {
    void go(PageSection s) {
      Navigator.of(context).pop();
      onNavigate(s);
    }

    return Drawer(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      width: 300,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textStrong,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Fechar menu',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              for (final s in PageSection.menu)
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: Text(
                    s.label,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textStrong,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textMuted,
                  ),
                  onTap: () => go(s),
                ),
              const Spacer(),
              PrimaryButton(
                label: 'Quero saber mais',
                expand: true,
                onPressed: () => go(PageSection.formulario),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
