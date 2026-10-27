import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:microcredito_empreendedores/core/phone_input_formatter.dart';

TextEditingValue _type(String previous, String next) {
  final f = BrazilianPhoneInputFormatter();
  return f.formatEditUpdate(
    TextEditingValue(
      text: previous,
      selection: TextSelection.collapsed(offset: previous.length),
    ),
    TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: next.length),
    ),
  );
}

void main() {
  group('BrazilianPhoneInputFormatter.format', () {
    test('formata progressivamente', () {
      expect(BrazilianPhoneInputFormatter.format(''), '');
      expect(BrazilianPhoneInputFormatter.format('8'), '(8');
      expect(BrazilianPhoneInputFormatter.format('89'), '(89');
      expect(BrazilianPhoneInputFormatter.format('899'), '(89) 9');
      expect(BrazilianPhoneInputFormatter.format('8998112'), '(89) 98112');
      expect(BrazilianPhoneInputFormatter.format('89981120'), '(89) 98112-0');
      expect(
        BrazilianPhoneInputFormatter.format('89981120109'),
        '(89) 98112-0109',
      );
    });

    test('ignora dígitos além de 11', () {
      expect(
        BrazilianPhoneInputFormatter.format('8998112010999'),
        '(89) 98112-0109',
      );
    });
  });

  group('BrazilianPhoneInputFormatter.formatEditUpdate', () {
    test('remove letras e símbolos', () {
      final v = _type('', '89a9b8(1)1-2');
      expect(v.text, '(89) 98112');
      expect(v.selection.baseOffset, v.text.length);
    });

    test('colar com +55 remove o código do país', () {
      final v = _type('', '+55 89 98112-0109');
      expect(v.text, '(89) 98112-0109');
    });

    test('remove zero inicial de operadora', () {
      final v = _type('', '089981120109');
      expect(v.text, '(89) 98112-0109');
    });

    test('não passa de 11 dígitos ao digitar', () {
      final v = _type('(89) 98112-0109', '(89) 98112-01099');
      expect(v.text, '(89) 98112-0109');
    });

    test('apagar o hífen apaga o dígito anterior', () {
      final f = BrazilianPhoneInputFormatter();
      const old = TextEditingValue(
        text: '(89) 98112-0',
        selection: TextSelection.collapsed(offset: 11),
      );
      // Usuário apagou o "-" (posição 10) com o cursor logo depois dele.
      const next = TextEditingValue(
        text: '(89) 981120',
        selection: TextSelection.collapsed(offset: 10),
      );
      final v = f.formatEditUpdate(old, next);
      expect(v.text, '(89) 98110');
    });
  });
}
