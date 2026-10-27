import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

/// Abre links externos. A interface existe para que os testes possam
/// substituir a abertura real por uma versão simulada.
abstract class LinkService {
  /// Retorna `true` se o navegador/sistema aceitou abrir o link.
  Future<bool> open(Uri uri);
}

/// Implementação real, compatível com Flutter Web, Android e iOS.
class UrlLauncherLinkService implements LinkService {
  const UrlLauncherLinkService();

  @override
  Future<bool> open(Uri uri) async {
    try {
      // Em navegadores, abre em nova aba (o link wa.me encaminha para o app
      // ou para o WhatsApp Web). Chamado direto no toque do botão para não
      // ser barrado pelo bloqueador de pop-ups.
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );
    } catch (_) {
      return false;
    }
  }
}

/// Disponibiliza os serviços para a árvore de widgets.
class AppServices extends InheritedWidget {
  const AppServices({
    super.key,
    required this.links,
    required super.child,
  });

  final LinkService links;

  static LinkService linksOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppServices>();
    assert(scope != null, 'AppServices não encontrado na árvore de widgets.');
    return scope!.links;
  }

  @override
  bool updateShouldNotify(AppServices oldWidget) => links != oldWidget.links;
}
