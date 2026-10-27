import 'form_options.dart';

/// Dados preenchidos no formulário. Ficam apenas na memória do navegador
/// enquanto a página está aberta e servem só para montar a mensagem do
/// WhatsApp — nada é gravado nem enviado a servidores pelo site.
class LeadFormData {
  const LeadFormData({
    required this.phone,
    required this.municipality,
    required this.activity,
    this.otherMunicipality,
    this.otherActivity,
  });

  /// Telefone já formatado: (89) 99999-9999.
  final String phone;

  /// Opção escolhida na lista de municípios.
  final String municipality;

  /// Opção escolhida na lista de atividades.
  final String activity;

  /// Nome digitado quando a opção é "Outros municípios do Piauí".
  final String? otherMunicipality;

  /// Descrição digitada quando a opção é "Outro tipo de atividade".
  final String? otherActivity;

  /// Município como deve aparecer na mensagem.
  String get municipalityLabel {
    if (municipality == FormOptions.otherPiauiMunicipality) {
      return '${_clean(otherMunicipality)} — PI';
    }
    return municipality;
  }

  /// Atividade como deve aparecer na mensagem.
  String get activityLabel {
    if (activity == FormOptions.otherActivity) {
      return 'Outro: ${_clean(otherActivity)}';
    }
    return activity;
  }

  static String _clean(String? value) =>
      (value ?? '').trim().replaceAll(RegExp(r'\s+'), ' ');
}
