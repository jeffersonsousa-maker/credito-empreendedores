/// Configurações centrais do site.
///
/// Altere aqui o número de atendimento, o nome exibido e os dados do
/// responsável pelo Aviso de Privacidade. Nenhuma chave de API ou segredo
/// deve ser colocado neste arquivo (ele vai para o navegador do visitante).
class AppConfig {
  AppConfig._();

  /// Nome textual exibido no cabeçalho e no rodapé.
  static const String siteName = 'Crédito para Empreendedores';

  /// Número de atendimento no formato internacional, só dígitos.
  static const String whatsappNumber = '5589981120109';

  /// Número formatado para exibição.
  static const String whatsappDisplay = '+55 (89) 98112-0109';

  /// Mensagem usada pelos botões de WhatsApp que não passam pelo formulário.
  static const String genericWhatsappMessage =
      'Olá! Gostaria de conhecer as possibilidades de crédito para o meu negócio.';

  /// Responsável pelo tratamento dos dados (controlador, na LGPD).
  static const String privacyControllerName = 'Jefferson De Sousa';

  /// Canal para o titular exercer seus direitos (LGPD, art. 18).
  static const String privacyContact = 'WhatsApp $whatsappDisplay';

  /// Data de vigência exibida no Aviso de Privacidade.
  static const String privacyLastUpdate = '27 de outubro de 2026';
}
