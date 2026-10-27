import 'package:flutter_test/flutter_test.dart';
import 'package:microcredito_empreendedores/core/validators.dart';

void main() {
  group('Validators.mobilePhone', () {
    test('aceita celular válido com DDD', () {
      expect(Validators.mobilePhone('(89) 98112-0109'), isNull);
      expect(Validators.mobilePhone('(74) 99999-1234'), isNull);
      expect(Validators.mobilePhone('86981234567'), isNull);
    });

    test('exige preenchimento', () {
      expect(Validators.mobilePhone(''), isNotNull);
      expect(Validators.mobilePhone(null), isNotNull);
    });

    test('rejeita número incompleto', () {
      expect(Validators.mobilePhone('(89) 98112-010'), contains('incompleto'));
    });

    test('rejeita DDD inexistente', () {
      expect(Validators.mobilePhone('(20) 98112-0109'), contains('DDD'));
      expect(Validators.mobilePhone('(10) 98112-0109'), contains('DDD'));
    });

    test('rejeita fixo (sem 9 após o DDD)', () {
      expect(Validators.mobilePhone('(89) 38112-0109'), contains('celular'));
    });

    test('rejeita sequência repetida', () {
      expect(Validators.mobilePhone('(89) 99999-9999'), isNotNull);
    });
  });

  group('Validators.municipalityName', () {
    test('aceita nomes com acentos, espaços e hífen', () {
      expect(Validators.municipalityName('Coronel José Dias'), isNull);
      expect(Validators.municipalityName("Pau-d'Arco do Piauí"), isNull);
      expect(Validators.municipalityName('São João do Piauí'), isNull);
    });

    test('rejeita vazio, curto ou com números', () {
      expect(Validators.municipalityName(''), isNotNull);
      expect(Validators.municipalityName('  '), isNotNull);
      expect(Validators.municipalityName('Ab'), isNotNull);
      expect(Validators.municipalityName('Cidade 123'), isNotNull);
    });
  });

  group('Validators.activityDescription', () {
    test('aceita descrição simples', () {
      expect(Validators.activityDescription('Venda de artesanato'), isNull);
    });

    test('rejeita vazio e números longos (evita CPF/conta)', () {
      expect(Validators.activityDescription(''), isNotNull);
      expect(Validators.activityDescription('cpf 12345678900'), isNotNull);
    });
  });

  group('Validators.requiredSelection e consent', () {
    test('seleção obrigatória', () {
      expect(Validators.requiredSelection(null, 'erro'), 'erro');
      expect(Validators.requiredSelection('Remanso — BA', 'erro'), isNull);
    });

    test('consentimento obrigatório', () {
      expect(Validators.consent(false), isNotNull);
      expect(Validators.consent(null), isNotNull);
      expect(Validators.consent(true), isNull);
    });
  });
}
