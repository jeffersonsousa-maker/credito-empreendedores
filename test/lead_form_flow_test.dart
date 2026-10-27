import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:microcredito_empreendedores/app.dart';
import 'package:microcredito_empreendedores/services/link_service.dart';
import 'package:microcredito_empreendedores/widgets/lead_form/lead_form.dart';

/// Substitui a abertura real de links e registra o que foi pedido.
class FakeLinkService implements LinkService {
  FakeLinkService({this.result = true});

  final bool result;
  final List<Uri> opened = [];

  @override
  Future<bool> open(Uri uri) async {
    opened.add(uri);
    return result;
  }
}

Future<void> pumpApp(
  WidgetTester tester,
  FakeLinkService links, {
  Size size = const Size(1280, 1000),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  // Efeitos desligados: animações em loop impediriam o pumpAndSettle.
  await tester.pumpWidget(MicrocreditoApp(links: links, enableMotion: false));
  await tester.pumpAndSettle();
}

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> selectOption(WidgetTester tester, Key field, String option) async {
  await tapVisible(tester, find.byKey(field));
  await tester.tap(find.text(option).last);
  await tester.pumpAndSettle();
}

Future<void> fillValidForm(WidgetTester tester) async {
  final phone = find.byKey(LeadFormKeys.phone);
  await tester.ensureVisible(phone);
  await tester.pumpAndSettle();
  await tester.enterText(phone, '89981234567');
  await tester.pumpAndSettle();
  await selectOption(tester, LeadFormKeys.municipality, 'Remanso — BA');
  await selectOption(tester, LeadFormKeys.activity, 'Comércio de alimentos');
  await tapVisible(tester, find.byType(CheckboxListTile));
}

/// Carrega a fonte real do site nos testes. Sem isso, o Flutter usa uma
/// fonte de teste com letras quadradas, mais largas que as reais.
Future<void> loadAppFonts() async {
  final loader = FontLoader('PlusJakartaSans');
  for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']) {
    loader.addFont(rootBundle.load('assets/fonts/PlusJakartaSans-$w.ttf'));
  }
  await loader.load();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadAppFonts);

  testWidgets('página carrega com as seções principais (desktop)',
      (tester) async {
    await pumpApp(tester, FakeLinkService());
    expect(find.text('Crédito'), findsWidgets);
    expect(find.text('QUERO SABER MAIS'), findsOneWidget);
    expect(find.text('Falar pelo WhatsApp'), findsWidgets);
    expect(find.text('Invista no crescimento do seu negócio'), findsOneWidget);
    expect(find.text('Vamos conversar sobre o seu negócio?'), findsOneWidget);
    expect(find.text('Perguntas frequentes'), findsOneWidget);
    expect(find.text('Seu próximo passo começa com uma conversa.'),
        findsOneWidget);
  });

  testWidgets('máscara do telefone é aplicada', (tester) async {
    await pumpApp(tester, FakeLinkService());
    final phone = find.byKey(LeadFormKeys.phone);
    await tester.ensureVisible(phone);
    await tester.pumpAndSettle();
    await tester.enterText(phone, '89981234567');
    await tester.pump();
    expect(find.text('(89) 98123-4567'), findsOneWidget);
  });

  testWidgets('envio vazio mostra erros e não abre o WhatsApp',
      (tester) async {
    final links = FakeLinkService();
    await pumpApp(tester, links);

    await tapVisible(tester, find.byKey(LeadFormKeys.submit));

    expect(find.text('Informe seu número de celular com DDD.'), findsOneWidget);
    expect(find.text('Selecione o seu município.'), findsOneWidget);
    expect(find.text('Selecione a sua atividade comercial.'), findsOneWidget);
    expect(
      find.text('Para continuar, marque a autorização de contato.'),
      findsOneWidget,
    );
    expect(find.byKey(LeadFormKeys.errorBanner), findsOneWidget);
    expect(links.opened, isEmpty);
  });

  testWidgets('sem consentimento não abre o WhatsApp', (tester) async {
    final links = FakeLinkService();
    await pumpApp(tester, links);

    final phone = find.byKey(LeadFormKeys.phone);
    await tester.ensureVisible(phone);
    await tester.pumpAndSettle();
    await tester.enterText(phone, '89981234567');
    await selectOption(tester, LeadFormKeys.municipality, 'Pilão Arcado — BA');
    await selectOption(tester, LeadFormKeys.activity, 'Vendas autônomas');

    await tapVisible(tester, find.byKey(LeadFormKeys.submit));

    expect(
      find.text('Para continuar, marque a autorização de contato.'),
      findsOneWidget,
    );
    expect(links.opened, isEmpty);
  });

  testWidgets('formulário válido abre o WhatsApp com a mensagem pronta',
      (tester) async {
    final links = FakeLinkService();
    await pumpApp(tester, links);

    await fillValidForm(tester);
    await tapVisible(tester, find.byKey(LeadFormKeys.submit));

    expect(links.opened, hasLength(1));
    final uri = links.opened.single;
    expect(uri.toString(), startsWith('https://wa.me/5589981120109?text='));
    final text = uri.queryParameters['text']!;
    expect(text, contains('Telefone: (89) 98123-4567'));
    expect(text, contains('Município: Remanso — BA'));
    expect(text, contains('Atividade comercial: Comércio de alimentos'));
    expect(find.byKey(LeadFormKeys.successBanner), findsOneWidget);
  });

  testWidgets('"Outros municípios do Piauí" exige o nome do município',
      (tester) async {
    final links = FakeLinkService();
    await pumpApp(tester, links);

    expect(find.byKey(LeadFormKeys.otherMunicipality), findsNothing);
    await fillValidForm(tester);
    await selectOption(
      tester,
      LeadFormKeys.municipality,
      'Outros municípios do Piauí',
    );
    expect(find.byKey(LeadFormKeys.otherMunicipality), findsOneWidget);

    await tapVisible(tester, find.byKey(LeadFormKeys.submit));
    expect(
      find.text('Informe o nome do seu município no Piauí.'),
      findsOneWidget,
    );
    expect(links.opened, isEmpty);

    final other = find.byKey(LeadFormKeys.otherMunicipality);
    await tester.ensureVisible(other);
    await tester.pumpAndSettle();
    await tester.enterText(other, 'Coronel José Dias');
    await tapVisible(tester, find.byKey(LeadFormKeys.submit));

    expect(links.opened, hasLength(1));
    expect(
      links.opened.single.queryParameters['text'],
      contains('Município: Coronel José Dias — PI'),
    );
  });

  testWidgets('"Outro tipo de atividade" abre campo de especificação',
      (tester) async {
    final links = FakeLinkService();
    await pumpApp(tester, links);

    await fillValidForm(tester);
    await selectOption(
      tester,
      LeadFormKeys.activity,
      'Outro tipo de atividade',
    );
    final other = find.byKey(LeadFormKeys.otherActivity);
    expect(other, findsOneWidget);

    await tester.ensureVisible(other);
    await tester.pumpAndSettle();
    await tester.enterText(other, 'Venda de artesanato');
    await tapVisible(tester, find.byKey(LeadFormKeys.submit));

    expect(
      links.opened.single.queryParameters['text'],
      contains('Atividade comercial: Outro: Venda de artesanato'),
    );
  });

  testWidgets('se o WhatsApp não abrir, mostra orientação', (tester) async {
    final links = FakeLinkService(result: false);
    await pumpApp(tester, links);

    await fillValidForm(tester);
    await tapVisible(tester, find.byKey(LeadFormKeys.submit));

    expect(find.text('Não conseguimos abrir o WhatsApp'), findsOneWidget);
    expect(find.text('Copiar mensagem'), findsWidgets);
  });

  testWidgets('link do Aviso de Privacidade abre a página', (tester) async {
    await pumpApp(tester, FakeLinkService());

    await tapVisible(tester, find.byKey(LeadFormKeys.privacyLink));

    expect(find.text('1. Quem é o responsável pelos dados'), findsOneWidget);
    await tapVisible(tester, find.text('Voltar para o site'));
    expect(find.text('Vamos conversar sobre o seu negócio?'), findsOneWidget);
  });

  testWidgets('botões de WhatsApp gerais abrem o número do projeto',
      (tester) async {
    final links = FakeLinkService();
    await pumpApp(tester, links);

    await tapVisible(tester, find.text('Falar pelo WhatsApp').first);

    expect(links.opened, hasLength(1));
    expect(links.opened.single.path, '/5589981120109');
  });

  testWidgets('layout de celular: menu compacto funciona e não estoura',
      (tester) async {
    await pumpApp(tester, FakeLinkService(), size: const Size(390, 844));

    expect(find.byTooltip('Abrir menu'), findsOneWidget);
    await tester.tap(find.byTooltip('Abrir menu'));
    await tester.pumpAndSettle();
    expect(find.text('Quem pode solicitar'), findsOneWidget);

    await tester.tap(find.text('Como funciona'));
    await tester.pumpAndSettle();
    expect(find.text('Como funciona?'), findsOneWidget);
  });

  testWidgets('"Quero saber mais" leva ao formulário', (tester) async {
    await pumpApp(tester, FakeLinkService(), size: const Size(390, 844));

    await tester.tap(find.text('QUERO SABER MAIS'));
    await tester.pumpAndSettle();

    final top = tester.getTopLeft(
      find.text('Vamos conversar sobre o seu negócio?'),
    );
    expect(top.dy, lessThan(844));
    expect(top.dy, greaterThanOrEqualTo(0));
  });

  testWidgets('Campo Alegre de Lourdes — BA pode ser escolhido', (tester) async {
    final links = FakeLinkService();
    await pumpApp(tester, links);

    await fillValidForm(tester);
    await selectOption(
      tester,
      LeadFormKeys.municipality,
      'Campo Alegre de Lourdes — BA',
    );
    await tapVisible(tester, find.byKey(LeadFormKeys.submit));

    expect(
      links.opened.single.queryParameters['text'],
      contains('Município: Campo Alegre de Lourdes — BA'),
    );
  });

  testWidgets('perguntas novas aparecem no FAQ', (tester) async {
    await pumpApp(tester, FakeLinkService());
    expect(find.text('Quais documentos vou precisar?'), findsOneWidget);
    expect(find.text('Preciso ser MEI ou ter CNPJ?'), findsOneWidget);
    expect(
      find.text('Tenho que pagar alguma coisa para conversar?'),
      findsOneWidget,
    );
  });

  testWidgets('com efeitos ligados a página anima e responde ao mouse',
      (tester) async {
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(MicrocreditoApp(links: FakeLinkService()));
    // Deixa a entrada do banner e as revelações rodarem.
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('QUERO SABER MAIS'), findsOneWidget);
    expect(find.text('Mais estoque'), findsOneWidget);

    // Passa o mouse sobre a foto da equipe (inclinação 3D) e sobre um botão.
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.text('Mais estoque')));
    await tester.pump(const Duration(milliseconds: 300));
    await mouse.moveTo(tester.getCenter(find.text('QUERO SABER MAIS')));
    await tester.pump(const Duration(milliseconds: 300));

    // Rola até o formulário: as seções são reveladas durante a rolagem.
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, -1600),
    );
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Vamos conversar sobre o seu negócio?'), findsOneWidget);

    await mouse.removePointer();
    // Desmonta a página para encerrar as animações em loop.
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
