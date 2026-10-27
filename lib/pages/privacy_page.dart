import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../core/breakpoints.dart';
import '../theme/app_colors.dart';

/// Aviso de Privacidade (versão inicial, LGPD — Lei 13.709/2018).
///
/// Revise o texto com o responsável pelo tratamento antes de publicar e
/// preencha os dados em `AppConfig`.
class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  static const String routeName = '/privacidade';

  static const List<({String title, List<String> paragraphs})> _sections = [
    (
      title: '1. Quem é o responsável pelos dados',
      paragraphs: [
        'O responsável pelo tratamento dos dados informados neste site é: '
            '${AppConfig.privacyControllerName}.',
        'Contato para assuntos de privacidade: ${AppConfig.privacyContact}.',
      ],
    ),
    (
      title: '2. Quais dados são solicitados',
      paragraphs: [
        'O formulário pede apenas: número de telefone celular, município e '
            'atividade comercial (e, se você escolher "outro", o nome do '
            'município ou a descrição da atividade).',
        'Nesta etapa inicial não são solicitados CPF, documentos, dados '
            'bancários, senhas ou informações financeiras.',
      ],
    ),
    (
      title: '3. Para que os dados são usados',
      paragraphs: [
        'Os dados servem exclusivamente para iniciar o atendimento sobre o seu '
            'interesse em crédito e para retornar o contato pelo número '
            'informado.',
        'Preencher o formulário não garante a concessão de crédito. As '
            'condições dependem da análise e dos critérios aplicáveis.',
      ],
    ),
    (
      title: '4. Base legal',
      paragraphs: [
        'O tratamento se baseia no seu consentimento (art. 7º, I, da LGPD), '
            'manifestado ao marcar a caixa de autorização, e em procedimentos '
            'preliminares solicitados por você (art. 7º, V).',
      ],
    ),
    (
      title: '5. Como os dados circulam',
      paragraphs: [
        'Este site não grava os dados do formulário em banco de dados e não '
            'os envia a servidores próprios. As informações ficam apenas no '
            'seu navegador e são usadas para montar uma mensagem.',
        'Ao tocar em "Quero receber atendimento", o WhatsApp é aberto com a '
            'mensagem pronta. Ela só é enviada se você tocar em Enviar na '
            'conversa. A partir daí, a comunicação ocorre pelo WhatsApp, '
            'serviço da Meta, sujeito aos termos e à política de privacidade '
            'dele.',
        'O provedor de hospedagem do site pode registrar dados técnicos de '
            'acesso (como endereço IP e data/hora), conforme exigido pela '
            'legislação, para segurança e funcionamento do serviço.',
      ],
    ),
    (
      title: '6. Cookies e rastreamento',
      paragraphs: [
        'Este site não utiliza cookies de rastreamento, pixels de anúncios '
            'ou ferramentas de publicidade. Caso isso mude, este aviso será '
            'atualizado antes, com as informações necessárias.',
      ],
    ),
    (
      title: '7. Por quanto tempo os dados são mantidos',
      paragraphs: [
        'As mensagens recebidas pelo WhatsApp são mantidas pelo tempo '
            'necessário ao atendimento e ao cumprimento de obrigações legais. '
            'Você pode pedir a exclusão a qualquer momento.',
      ],
    ),
    (
      title: '8. Seus direitos',
      paragraphs: [
        'Você pode solicitar, a qualquer momento: confirmação e acesso aos '
            'dados, correção, anonimização ou eliminação, informação sobre '
            'compartilhamento e revogação do consentimento (art. 18 da LGPD).',
        'Para isso, entre em contato pelo ${AppConfig.privacyContact}. Você '
            'também pode apresentar reclamação à Autoridade Nacional de '
            'Proteção de Dados (ANPD).',
      ],
    ),
    (
      title: '9. Segurança',
      paragraphs: [
        'O site é publicado com conexão segura (HTTPS). Nunca informe senhas '
            'ou códigos de verificação em conversas.',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = Breakpoints.widthOf(context);
    final h = Breakpoints.horizontalPadding(width);

    return Title(
      title: 'Aviso de Privacidade — ${AppConfig.siteName}',
      color: AppColors.red,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          foregroundColor: AppColors.textStrong,
          elevation: 0,
          scrolledUnderElevation: 1,
          shape: const Border(bottom: BorderSide(color: AppColors.border)),
          leading: IconButton(
            tooltip: 'Voltar',
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => _back(context),
          ),
          title: const Text(
            'Aviso de Privacidade',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(h, 40, h, 64),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      'Aviso de Privacidade',
                      style: theme.textTheme.headlineLarge,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Última atualização: ${AppConfig.privacyLastUpdate}',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Este aviso explica, de forma simples, como são tratados os '
                    'dados informados no formulário de interesse em crédito '
                    'do site ${AppConfig.siteName}, em conformidade com a Lei '
                    'Geral de Proteção de Dados (Lei nº 13.709/2018).',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 12),
                  for (final section in _sections) ...[
                    const SizedBox(height: 24),
                    Semantics(
                      header: true,
                      child: Text(
                        section.title,
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(height: 10),
                    for (final p in section.paragraphs)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(p, style: theme.textTheme.bodyMedium),
                      ),
                  ],
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: () => _back(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Voltar para o site'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _back(BuildContext context) {
    final nav = Navigator.of(context);
    if (nav.canPop()) {
      nav.pop();
    } else {
      // Acesso direto pelo link /#/privacidade: volta para a página inicial.
      nav.pushReplacementNamed('/');
    }
  }
}
