/// Opções fixas dos campos de seleção do formulário.
class FormOptions {
  FormOptions._();

  static const String otherPiauiMunicipality = 'Outros municípios do Piauí';
  static const String otherActivity = 'Outro tipo de atividade';

  /// Somente estas opções são aceitas (área de atendimento definida no
  /// projeto). Municípios de outros estados não aparecem na lista.
  static const List<String> municipalities = [
    'São Raimundo Nonato — PI',
    'Remanso — BA',
    'Pilão Arcado — BA',
    'Campo Alegre de Lourdes — BA',
    otherPiauiMunicipality,
  ];

  static const List<String> activities = [
    'Comércio de alimentos',
    'Loja de roupas e calçados',
    'Beleza e estética',
    'Lanchonete ou restaurante',
    'Prestação de serviços',
    'Oficina ou assistência técnica',
    'Agricultura ou produção rural',
    'Vendas autônomas',
    otherActivity,
  ];
}
