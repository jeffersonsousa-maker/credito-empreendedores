import '../config/app_config.dart';
import '../models/lead_form_data.dart';

/// Monta mensagens e links do WhatsApp (formato https://wa.me/<número>).
class WhatsAppService {
  WhatsAppService._();

  static const String _baseUrl = 'https://wa.me/';

  /// Mensagem pré-preenchida a partir dos dados do formulário.
  static String buildLeadMessage(LeadFormData data) {
    return 'Olá! Tenho interesse em conhecer as possibilidades de crédito para meu negócio.\n'
        '\n'
        'Telefone: ${data.phone}\n'
        'Município: ${data.municipalityLabel}\n'
        'Atividade comercial: ${data.activityLabel}\n'
        '\n'
        'Gostaria de receber mais informações sobre o atendimento.';
  }

  /// Link do WhatsApp com texto opcional, codificado para URL
  /// (espaços viram %20 e quebras de linha %0A).
  static Uri buildUri({String? message, String phone = AppConfig.whatsappNumber}) {
    final number = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (message == null || message.trim().isEmpty) {
      return Uri.parse('$_baseUrl$number');
    }
    return Uri.parse('$_baseUrl$number?text=${Uri.encodeComponent(message)}');
  }

  /// Link para os botões gerais de contato (sem dados do formulário).
  static Uri genericContactUri() =>
      buildUri(message: AppConfig.genericWhatsappMessage);

  /// Link a partir do formulário validado.
  static Uri leadUri(LeadFormData data) =>
      buildUri(message: buildLeadMessage(data));
}
