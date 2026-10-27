import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config/app_config.dart';
import '../../services/link_service.dart';
import '../../services/whatsapp_service.dart';
import '../../theme/app_colors.dart';

/// Ações de contato compartilhadas pelos botões do site.
class ContactActions {
  ContactActions._();

  /// Abre a conversa geral (botões do topo, banner, chamada final e botão
  /// flutuante). Não inclui dados do visitante.
  static Future<bool> openGenericWhatsApp(BuildContext context) {
    return openWhatsApp(
      context,
      uri: WhatsAppService.genericContactUri(),
      message: AppConfig.genericWhatsappMessage,
    );
  }

  /// Abre um link do WhatsApp. Se o navegador não conseguir abrir, mostra
  /// orientações e a opção de copiar a mensagem.
  static Future<bool> openWhatsApp(
    BuildContext context, {
    required Uri uri,
    required String message,
  }) async {
    final links = AppServices.linksOf(context);
    final opened = await links.open(uri);
    if (!opened && context.mounted) {
      await showWhatsAppFallback(context, uri: uri, message: message);
    }
    return opened;
  }

  static Future<void> showWhatsAppFallback(
    BuildContext context, {
    required Uri uri,
    required String message,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => _WhatsAppFallbackDialog(
        uri: uri,
        message: message,
      ),
    );
  }
}

class _WhatsAppFallbackDialog extends StatefulWidget {
  const _WhatsAppFallbackDialog({required this.uri, required this.message});

  final Uri uri;
  final String message;

  @override
  State<_WhatsAppFallbackDialog> createState() =>
      _WhatsAppFallbackDialogState();
}

class _WhatsAppFallbackDialogState extends State<_WhatsAppFallbackDialog> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.message));
    if (!mounted) return;
    setState(() => _copied = true);
  }

  Future<void> _retry() async {
    final opened = await AppServices.linksOf(context).open(widget.uri);
    if (opened && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      icon: const Icon(Icons.info_outline, color: AppColors.redDark, size: 32),
      title: const Text(
        'Não conseguimos abrir o WhatsApp',
        textAlign: TextAlign.center,
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Seus dados não foram enviados. Para iniciar o atendimento, você pode:',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              const _Step(
                n: '1',
                text:
                    'Verificar se o navegador bloqueou a abertura de uma nova janela e permitir pop-ups para este site.',
              ),
              const _Step(
                n: '2',
                text:
                    'Ou salvar o número ${AppConfig.whatsappDisplay} no seu celular e enviar a mensagem pelo WhatsApp.',
              ),
              const _Step(
                n: '3',
                text:
                    'Use o botão "Copiar mensagem" abaixo e cole na conversa.',
              ),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowButtonSpacing: 8,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
        OutlinedButton.icon(
          onPressed: _copy,
          icon: Icon(
            _copied ? Icons.check_rounded : Icons.copy_rounded,
            size: 18,
          ),
          label: Text(_copied ? 'Mensagem copiada' : 'Copiar mensagem'),
        ),
        FilledButton(
          onPressed: _retry,
          child: const Text('Tentar novamente'),
        ),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.n, required this.text});

  final String n;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.redTint,
              shape: BoxShape.circle,
            ),
            child: Text(
              n,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: AppColors.redDark,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
