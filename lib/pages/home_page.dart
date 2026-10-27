import 'package:flutter/material.dart';

import '../models/page_section.dart';
import '../widgets/audience/audience_section.dart';
import '../widgets/benefits/benefits_section.dart';
import '../widgets/common/contact_actions.dart';
import '../widgets/common/floating_whatsapp_button.dart';
import '../widgets/faq/faq_section.dart';
import '../widgets/final_cta/final_cta_section.dart';
import '../widgets/footer/app_footer.dart';
import '../widgets/header/app_header.dart';
import '../widgets/hero/hero_section.dart';
import '../widgets/how_it_works/how_it_works_section.dart';
import '../widgets/lead_form/lead_form_section.dart';
import '../widgets/marquee/business_marquee.dart';
import 'privacy_page.dart';

/// Tela principal (landing page de página única).
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scroll = ScrollController();
  final Map<PageSection, GlobalKey> _keys = {
    for (final s in PageSection.values) s: GlobalKey(debugLabel: s.name),
  };

  bool _headerElevated = false;
  bool _fabVisible = true;
  bool _precached = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_precached) {
      _precached = true;
      // Carrega a foto do banner o quanto antes para evitar "piscar".
      precacheImage(const AssetImage(HeroSection.teamImage), context);
    }
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    final elevated = _scroll.hasClients && _scroll.offset > 4;
    final fabVisible = !_isFormOnScreen();
    if (elevated != _headerElevated || fabVisible != _fabVisible) {
      setState(() {
        _headerElevated = elevated;
        _fabVisible = fabVisible;
      });
    }
  }

  /// Verdadeiro quando o formulário ocupa a área visível, para esconder o
  /// botão flutuante e não cobrir campos nem o botão de envio.
  bool _isFormOnScreen() {
    final ctx = _keys[PageSection.formulario]!.currentContext;
    final box = ctx?.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return false;
    final top = box.localToGlobal(Offset.zero).dy;
    final bottom = top + box.size.height;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return top < screenHeight - 140 && bottom > 160;
  }

  void _goTo(PageSection section) {
    final ctx = _keys[section]?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
    );
  }

  void _openPrivacy() {
    Navigator.of(context).pushNamed(PrivacyPage.routeName);
  }

  void _openWhatsApp() {
    ContactActions.openGenericWhatsApp(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(onNavigate: _goTo, elevated: _headerElevated),
      endDrawer: MobileMenuDrawer(onNavigate: _goTo),
      floatingActionButton: FloatingWhatsAppButton(
        visible: _fabVisible,
        onPressed: _openWhatsApp,
      ),
      body: NotificationListener<SizeChangedLayoutNotification>(
        onNotification: (_) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
          return false;
        },
        child: SizeChangedLayoutNotifier(
          child: SingleChildScrollView(
            controller: _scroll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                KeyedSubtree(
                  key: _keys[PageSection.inicio],
                  child: HeroSection(
                    onWantToKnowMore: () => _goTo(PageSection.formulario),
                    onWhatsApp: _openWhatsApp,
                  ),
                ),
                const BusinessMarquee(),
                const BenefitsSection(),
                KeyedSubtree(
                  key: _keys[PageSection.quemPode],
                  child: const AudienceSection(),
                ),
                KeyedSubtree(
                  key: _keys[PageSection.formulario],
                  child: LeadFormSection(onOpenPrivacy: _openPrivacy),
                ),
                KeyedSubtree(
                  key: _keys[PageSection.comoFunciona],
                  child: const HowItWorksSection(),
                ),
                const FaqSection(),
                KeyedSubtree(
                  key: _keys[PageSection.faleConosco],
                  child: FinalCtaSection(onWhatsApp: _openWhatsApp),
                ),
                AppFooter(
                  onWhatsApp: _openWhatsApp,
                  onOpenPrivacy: _openPrivacy,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
