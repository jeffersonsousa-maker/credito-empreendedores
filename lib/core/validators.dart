import 'phone_input_formatter.dart';

/// Validações dos campos do formulário. Todas retornam `null` quando o valor
/// é válido ou a mensagem de erro a ser exibida.
class Validators {
  Validators._();

  /// DDDs em uso no Brasil (Anatel).
  static const Set<int> validDdds = {
    11, 12, 13, 14, 15, 16, 17, 18, 19, //
    21, 22, 24, 27, 28, //
    31, 32, 33, 34, 35, 37, 38, //
    41, 42, 43, 44, 45, 46, 47, 48, 49, //
    51, 53, 54, 55, //
    61, 62, 63, 64, 65, 66, 67, 68, 69, //
    71, 73, 74, 75, 77, 79, //
    81, 82, 83, 84, 85, 86, 87, 88, 89, //
    91, 92, 93, 94, 95, 96, 97, 98, 99,
  };

  /// Celular com DDD: 11 dígitos, DDD válido e começando com 9.
  static String? mobilePhone(String? value) {
    final digits = BrazilianPhoneInputFormatter.digitsOnly(value ?? '');
    if (digits.isEmpty) {
      return 'Informe seu número de celular com DDD.';
    }
    if (digits.length != 11) {
      return 'Número incompleto. Use o formato (89) 99999-9999.';
    }
    final ddd = int.parse(digits.substring(0, 2));
    if (!validDdds.contains(ddd)) {
      return 'O DDD $ddd não é válido. Confira o número.';
    }
    if (digits[2] != '9') {
      return 'Informe um número de celular (começa com 9 depois do DDD).';
    }
    if (RegExp(r'^(\d)\1+$').hasMatch(digits.substring(2))) {
      return 'Confira o número informado.';
    }
    return null;
  }

  static String? requiredSelection(String? value, String message) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static final RegExp _namePattern =
      RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ][A-Za-zÀ-ÖØ-öø-ÿ'’\- ]*$");

  /// Nome de município (quando "Outros municípios do Piauí").
  static String? municipalityName(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Informe o nome do seu município no Piauí.';
    if (v.length < 3) return 'Nome do município muito curto.';
    if (v.length > 60) return 'Use no máximo 60 caracteres.';
    if (!_namePattern.hasMatch(v)) {
      return 'Use apenas letras, espaços e hífen.';
    }
    return null;
  }

  /// Descrição da atividade (quando "Outro tipo de atividade").
  static String? activityDescription(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Conte qual é a sua atividade.';
    if (v.length < 3) return 'Descreva com um pouco mais de detalhe.';
    if (v.length > 60) return 'Use no máximo 60 caracteres.';
    if (RegExp(r'[<>{}\[\]\\|^~`]').hasMatch(v)) {
      return 'Remova caracteres especiais.';
    }
    if (RegExp(r'\d{6,}').hasMatch(v)) {
      return 'Não informe números de documentos ou contas aqui.';
    }
    return null;
  }

  static String? consent(bool? value) {
    if (value == true) return null;
    return 'Para continuar, marque a autorização de contato.';
  }
}
