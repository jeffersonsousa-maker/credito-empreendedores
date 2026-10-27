import 'package:flutter/material.dart';

import '../../core/breakpoints.dart';

/// Envolve uma seção: cor de fundo, espaçamento vertical e conteúdo
/// centralizado com largura máxima.
class SectionContainer extends StatelessWidget {
  const SectionContainer({
    super.key,
    required this.child,
    this.background,
    this.decoration,
    this.verticalPadding,
    this.bottomPadding,
    this.maxWidth = Breakpoints.maxContentWidth,
    this.semanticLabel,
  });

  final Widget child;
  final Color? background;
  final Decoration? decoration;
  final double? verticalPadding;
  final double? bottomPadding;
  final double maxWidth;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final width = Breakpoints.widthOf(context);
    final v = verticalPadding ?? Breakpoints.sectionSpacing(width);
    final h = Breakpoints.horizontalPadding(width);

    Widget content = Container(
      width: double.infinity,
      color: decoration == null ? background : null,
      decoration: decoration,
      padding: EdgeInsets.fromLTRB(h, v, h, bottomPadding ?? v),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );

    if (semanticLabel != null) {
      content = Semantics(
        container: true,
        label: semanticLabel,
        child: content,
      );
    }
    return content;
  }
}
