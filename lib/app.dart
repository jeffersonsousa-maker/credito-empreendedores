import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/app_config.dart';
import 'pages/home_page.dart';
import 'pages/privacy_page.dart';
import 'services/link_service.dart';
import 'theme/app_theme.dart';
import 'widgets/motion/motion.dart';

class MicrocreditoApp extends StatelessWidget {
  const MicrocreditoApp({
    super.key,
    this.links = const UrlLauncherLinkService(),
    this.enableMotion = true,
  });

  /// Serviço de abertura de links (substituído nos testes).
  final LinkService links;

  /// Efeitos 3D e animações. Desligados nos testes; também são desligados
  /// automaticamente quando o visitante pede "reduzir movimento".
  final bool enableMotion;

  @override
  Widget build(BuildContext context) {
    return AppServices(
      links: links,
      child: MotionScope(
        enabled: enableMotion,
        child: MaterialApp(
          title: AppConfig.siteName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          locale: const Locale('pt', 'BR'),
          supportedLocales: const [Locale('pt', 'BR')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          initialRoute: HomePage.routeName,
          routes: {
            HomePage.routeName: (_) => const HomePage(),
            PrivacyPage.routeName: (_) => const PrivacyPage(),
          },
          onUnknownRoute: (_) => MaterialPageRoute<void>(
            builder: (_) => const HomePage(),
          ),
        ),
      ),
    );
  }
}
