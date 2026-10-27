/// Seções da página que podem ser alcançadas pelo menu.
enum PageSection {
  inicio('Início'),
  comoFunciona('Como funciona'),
  quemPode('Quem pode solicitar'),
  faleConosco('Fale conosco'),
  formulario('Formulário');

  const PageSection(this.label);

  final String label;

  /// Itens exibidos no menu do cabeçalho, na ordem.
  static const List<PageSection> menu = [
    inicio,
    comoFunciona,
    quemPode,
    faleConosco,
  ];
}
