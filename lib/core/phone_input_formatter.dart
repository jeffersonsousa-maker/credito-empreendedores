import 'package:flutter/services.dart';

/// Máscara de celular brasileiro: (89) 99999-9999.
///
/// Aceita só dígitos, limita a 11 (DDD + 9 dígitos) e mantém o cursor na
/// posição correta mesmo quando o usuário edita no meio do número.
class BrazilianPhoneInputFormatter extends TextInputFormatter {
  static const int maxDigits = 11;

  static String digitsOnly(String value) =>
      value.replaceAll(RegExp(r'[^0-9]'), '');

  /// Formata uma sequência de dígitos (até 11) com a máscara.
  static String format(String rawDigits) {
    final d = rawDigits.length > maxDigits
        ? rawDigits.substring(0, maxDigits)
        : rawDigits;
    if (d.isEmpty) return '';
    if (d.length <= 2) return '($d';
    final ddd = d.substring(0, 2);
    final rest = d.substring(2);
    if (rest.length <= 5) return '($ddd) $rest';
    return '($ddd) ${rest.substring(0, 5)}-${rest.substring(5)}';
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = digitsOnly(newValue.text);

    // Apagar um separador (ex.: o "-") sem apagar dígito não teria efeito;
    // nesse caso removemos o dígito anterior ao cursor.
    final deletedOnlySeparator = newValue.text.length < oldValue.text.length &&
        digits == digitsOnly(oldValue.text);
    var cursorDigits = _digitsBefore(newValue.text, newValue.selection.end);
    if (deletedOnlySeparator && cursorDigits > 0) {
      digits = digits.substring(0, cursorDigits - 1) +
          digits.substring(cursorDigits);
      cursorDigits -= 1;
    }

    // DDD nunca começa com 0 (prefixo de operadora) e um número colado com
    // código do país (+55) deve perder esse prefixo.
    while (digits.startsWith('0')) {
      digits = digits.substring(1);
      if (cursorDigits > 0) cursorDigits -= 1;
    }
    final pasted = newValue.text.length - oldValue.text.length > 1;
    if (pasted && digits.length > maxDigits && digits.startsWith('55')) {
      digits = digits.substring(2);
      cursorDigits = cursorDigits >= 2 ? cursorDigits - 2 : 0;
    }
    if (digits.length > maxDigits) {
      digits = digits.substring(0, maxDigits);
    }
    if (cursorDigits > digits.length) cursorDigits = digits.length;

    final formatted = format(digits);
    final offset = _offsetForDigitCount(formatted, cursorDigits);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: offset),
    );
  }

  static int _digitsBefore(String text, int end) {
    if (end < 0) return digitsOnly(text).length;
    final safeEnd = end > text.length ? text.length : end;
    return digitsOnly(text.substring(0, safeEnd)).length;
  }

  static int _offsetForDigitCount(String formatted, int count) {
    if (count <= 0) return formatted.isEmpty ? 0 : 1;
    var seen = 0;
    for (var i = 0; i < formatted.length; i++) {
      final c = formatted.codeUnitAt(i);
      if (c >= 48 && c <= 57) {
        seen++;
        if (seen == count) return i + 1;
      }
    }
    return formatted.length;
  }
}
