import 'package:flutter_test/flutter_test.dart';
import 'package:microcredito_empreendedores/models/form_options.dart';
import 'package:microcredito_empreendedores/models/lead_form_data.dart';
import 'package:microcredito_empreendedores/services/whatsapp_service.dart';

void main() {
  const data = LeadFormData(
    phone: '(89) 98123-4567',
    municipality: 'São Raimundo Nonato — PI',
    activity: 'Comércio de alimentos',
  );

  test('monta a mensagem no modelo do projeto', () {
    final msg = WhatsAppService.buildLeadMessage(data);
    expect(
      msg,
      'Olá! Tenho interesse em conhecer as possibilidades de crédito para meu negócio.\n'
      '\n'
      'Telefone: (89) 98123-4567\n'
      'Município: São Raimundo Nonato — PI\n'
      'Atividade comercial: Comércio de alimentos\n'
      '\n'
      'Gostaria de receber mais informações sobre o atendimento.',
    );
  });

  test('usa o número do projeto e codifica a mensagem para URL', () {
    final uri = WhatsAppService.leadUri(data);
    final s = uri.toString();
    expect(s, startsWith('https://wa.me/5589981120109?text='));
    expect(s, contains('%0A')); // quebras de linha
    expect(s, contains('%20')); // espaços
    expect(s, isNot(contains(' ')));
    expect(s, isNot(contains('+')));
    expect(uri.queryParameters['text'], WhatsAppService.buildLeadMessage(data));
  });

  test('inclui município e atividade digitados quando "outro"', () {
    const other = LeadFormData(
      phone: '(86) 99999-0000',
      municipality: FormOptions.otherPiauiMunicipality,
      otherMunicipality: '  Coronel   José Dias ',
      activity: FormOptions.otherActivity,
      otherActivity: 'Venda de artesanato',
    );
    final msg = WhatsAppService.buildLeadMessage(other);
    expect(msg, contains('Município: Coronel José Dias — PI'));
    expect(msg, contains('Atividade comercial: Outro: Venda de artesanato'));
  });

  test('link geral sem dados do visitante', () {
    final uri = WhatsAppService.genericContactUri();
    expect(uri.host, 'wa.me');
    expect(uri.path, '/5589981120109');
    expect(uri.queryParameters['text'], isNotEmpty);
  });
}
