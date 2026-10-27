import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/phone_input_formatter.dart';
import '../../core/validators.dart';
import '../../models/form_options.dart';
import '../../models/lead_form_data.dart';
import '../../services/whatsapp_service.dart';
import '../../theme/app_colors.dart';
import '../common/app_buttons.dart';
import '../common/contact_actions.dart';
import '../common/whatsapp_glyph.dart';

/// Chaves usadas pelos testes automatizados.
class LeadFormKeys {
  LeadFormKeys._();

  static const phone = ValueKey('lead-phone');
  static const municipality = ValueKey('lead-municipality');
  static const otherMunicipality = ValueKey('lead-other-municipality');
  static const activity = ValueKey('lead-activity');
  static const otherActivity = ValueKey('lead-other-activity');
  static const consent = ValueKey('lead-consent');
  static const submit = ValueKey('lead-submit');
  static const privacyLink = ValueKey('lead-privacy-link');
  static const errorBanner = ValueKey('lead-error-banner');
  static const successBanner = ValueKey('lead-success-banner');
}

/// Formulário de interesse (Seção 5).
///
/// Não grava nada: ao enviar, valida os campos e abre o WhatsApp com a
/// mensagem pronta. O visitante confere o texto e decide se envia.
class LeadForm extends StatefulWidget {
  const LeadForm({super.key, required this.onOpenPrivacy});

  final VoidCallback onOpenPrivacy;

  @override
  State<LeadForm> createState() => _LeadFormState();
}

class _LeadFormState extends State<LeadForm> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _otherMunicipality = TextEditingController();
  final _otherActivity = TextEditingController();

  final _phoneFocus = FocusNode(debugLabel: 'phone');
  final _municipalityFocus = FocusNode(debugLabel: 'municipality');
  final _otherMunicipalityFocus = FocusNode(debugLabel: 'otherMunicipality');
  final _activityFocus = FocusNode(debugLabel: 'activity');
  final _otherActivityFocus = FocusNode(debugLabel: 'otherActivity');
  final _consentFocus = FocusNode(debugLabel: 'consent');

  String? _municipality;
  String? _activity;
  bool _consent = false;

  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  bool _showErrorBanner = false;
  bool _opened = false;
  bool _openFailed = false;

  bool get _needsOtherMunicipality =>
      _municipality == FormOptions.otherPiauiMunicipality;
  bool get _needsOtherActivity => _activity == FormOptions.otherActivity;

  @override
  void dispose() {
    _phone.dispose();
    _otherMunicipality.dispose();
    _otherActivity.dispose();
    _phoneFocus.dispose();
    _municipalityFocus.dispose();
    _otherMunicipalityFocus.dispose();
    _activityFocus.dispose();
    _otherActivityFocus.dispose();
    _consentFocus.dispose();
    super.dispose();
  }

  LeadFormData _collect() => LeadFormData(
        phone: BrazilianPhoneInputFormatter.format(
          BrazilianPhoneInputFormatter.digitsOnly(_phone.text),
        ),
        municipality: _municipality!,
        activity: _activity!,
        otherMunicipality:
            _needsOtherMunicipality ? _otherMunicipality.text : null,
        otherActivity: _needsOtherActivity ? _otherActivity.text : null,
      );

  void _submit() {
    final form = _formKey.currentState;
    if (form == null) return;

    final valid = form.validate();
    if (!valid) {
      setState(() {
        _autovalidate = AutovalidateMode.onUserInteraction;
        _showErrorBanner = true;
        _opened = false;
      });
      _focusFirstInvalid();
      return;
    }

    final data = _collect();
    final message = WhatsAppService.buildLeadMessage(data);
    final uri = WhatsAppService.leadUri(data);

    setState(() {
      _showErrorBanner = false;
      _openFailed = false;
    });

    // Chamado direto no toque para o navegador não bloquear a nova aba.
    ContactActions.openWhatsApp(context, uri: uri, message: message)
        .then((opened) {
      if (!mounted) return;
      setState(() {
        _opened = opened;
        _openFailed = !opened;
      });
    });
  }

  void _focusFirstInvalid() {
    FocusNode? target;
    if (Validators.mobilePhone(_phone.text) != null) {
      target = _phoneFocus;
    } else if (_municipality == null) {
      target = _municipalityFocus;
    } else if (_needsOtherMunicipality &&
        Validators.municipalityName(_otherMunicipality.text) != null) {
      target = _otherMunicipalityFocus;
    } else if (_activity == null) {
      target = _activityFocus;
    } else if (_needsOtherActivity &&
        Validators.activityDescription(_otherActivity.text) != null) {
      target = _otherActivityFocus;
    } else if (!_consent) {
      target = _consentFocus;
    }
    if (target == null) return;
    final node = target;
    node.requestFocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = node.context;
      if (ctx != null && ctx.mounted) {
        Scrollable.ensureVisible(
          ctx,
          alignment: 0.3,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      autovalidateMode: _autovalidate,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Campos com * são obrigatórios.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 18),

            // Campo 1 — Telefone
            TextFormField(
              key: LeadFormKeys.phone,
              controller: _phone,
              focusNode: _phoneFocus,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.telephoneNumber],
              inputFormatters: [BrazilianPhoneInputFormatter()],
              validator: Validators.mobilePhone,
              decoration: const InputDecoration(
                labelText: 'Telefone celular com DDD *',
                hintText: '(89) 99999-9999',
                helperText: 'Usaremos este número para retornar o contato.',
                prefixIcon: Icon(Icons.phone_iphone_rounded),
              ),
            ),
            const SizedBox(height: 18),

            // Campo 2 — Município
            DropdownButtonFormField<String>(
              key: LeadFormKeys.municipality,
              focusNode: _municipalityFocus,
              isExpanded: true,
              borderRadius: BorderRadius.circular(12),
              dropdownColor: AppColors.white,
              decoration: const InputDecoration(
                labelText: 'Município *',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              items: [
                for (final m in FormOptions.municipalities)
                  DropdownMenuItem<String>(
                    value: m,
                    child: Text(m, overflow: TextOverflow.ellipsis),
                  ),
              ],
              validator: (v) => Validators.requiredSelection(
                v,
                'Selecione o seu município.',
              ),
              onChanged: (v) => setState(() => _municipality = v),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              alignment: Alignment.topCenter,
              child: _needsOtherMunicipality
                  ? Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: TextFormField(
                        key: LeadFormKeys.otherMunicipality,
                        controller: _otherMunicipality,
                        focusNode: _otherMunicipalityFocus,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        maxLength: 60,
                        autofillHints: const [AutofillHints.addressCity],
                        validator: Validators.municipalityName,
                        decoration: const InputDecoration(
                          labelText: 'Nome do município (Piauí) *',
                          hintText: 'Ex.: Coronel José Dias',
                          counterText: '',
                          prefixIcon: Icon(Icons.edit_location_alt_outlined),
                        ),
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
            const SizedBox(height: 18),

            // Campo 3 — Atividade comercial
            DropdownButtonFormField<String>(
              key: LeadFormKeys.activity,
              focusNode: _activityFocus,
              isExpanded: true,
              borderRadius: BorderRadius.circular(12),
              dropdownColor: AppColors.white,
              decoration: const InputDecoration(
                labelText: 'Atividade comercial *',
                prefixIcon: Icon(Icons.storefront_outlined),
              ),
              items: [
                for (final a in FormOptions.activities)
                  DropdownMenuItem<String>(
                    value: a,
                    child: Text(a, overflow: TextOverflow.ellipsis),
                  ),
              ],
              validator: (v) => Validators.requiredSelection(
                v,
                'Selecione a sua atividade comercial.',
              ),
              onChanged: (v) => setState(() => _activity = v),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              alignment: Alignment.topCenter,
              child: _needsOtherActivity
                  ? Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: TextFormField(
                        key: LeadFormKeys.otherActivity,
                        controller: _otherActivity,
                        focusNode: _otherActivityFocus,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.done,
                        maxLength: 60,
                        validator: Validators.activityDescription,
                        decoration: const InputDecoration(
                          labelText: 'Qual é a sua atividade? *',
                          hintText: 'Ex.: venda de artesanato',
                          counterText: '',
                          prefixIcon: Icon(Icons.edit_note_rounded),
                        ),
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
            const SizedBox(height: 20),

            // Campo 4 — Consentimento
            FormField<bool>(
              key: LeadFormKeys.consent,
              initialValue: false,
              validator: Validators.consent,
              builder: (field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: field.hasError
                            ? const Color(0xFFFFF4F4)
                            : AppColors.surfaceGray,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: field.hasError
                              ? AppColors.error
                              : AppColors.border,
                        ),
                      ),
                      child: CheckboxListTile(
                        focusNode: _consentFocus,
                        value: _consent,
                        onChanged: (v) {
                          final checked = v ?? false;
                          setState(() => _consent = checked);
                          field.didChange(checked);
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        activeColor: AppColors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: const Text(
                          'Autorizo o contato para tratar do meu interesse em '
                          'crédito e declaro que li o Aviso de Privacidade.',
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.45,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textStrong,
                          ),
                        ),
                      ),
                    ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.only(left: 12, top: 8),
                        child: Text(
                          field.errorText!,
                          style: theme.inputDecorationTheme.errorStyle,
                        ),
                      ),
                  ],
                );
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                key: LeadFormKeys.privacyLink,
                onPressed: widget.onOpenPrivacy,
                icon: const Icon(
                  Icons.privacy_tip_outlined,
                  size: 18,
                  color: AppColors.redDark,
                ),
                label: const Text(
                  'Ler o Aviso de Privacidade',
                  style: TextStyle(
                    color: AppColors.redDark,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.redDark,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            if (_showErrorBanner) ...[
              const _Banner(
                key: LeadFormKeys.errorBanner,
                icon: Icons.error_outline_rounded,
                color: AppColors.error,
                background: Color(0xFFFFF4F4),
                text:
                    'Alguns campos precisam de atenção. Confira as mensagens destacadas acima.',
              ),
              const SizedBox(height: 14),
            ],

            PrimaryButton(
              key: LeadFormKeys.submit,
              label: 'QUERO RECEBER ATENDIMENTO',
              large: true,
              expand: true,
              onPressed: _submit,
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: WhatsAppGlyph(size: 18, color: AppColors.whatsapp),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'O WhatsApp será aberto com a mensagem pronta. Nada é '
                    'enviado sem a sua confirmação, e este site não armazena '
                    'os dados preenchidos.',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),

            if (_opened) ...[
              const SizedBox(height: 16),
              _Banner(
                key: LeadFormKeys.successBanner,
                icon: Icons.check_circle_outline_rounded,
                color: AppColors.whatsapp,
                background: const Color(0xFFEFF8F2),
                text:
                    'Abrimos o WhatsApp com a sua mensagem. Para iniciar o '
                    'atendimento, confira o texto e toque em Enviar na conversa.',
                action: TextButton(
                  onPressed: _submit,
                  child: const Text('Abrir o WhatsApp novamente'),
                ),
              ),
            ],
            if (_openFailed) ...[
              const SizedBox(height: 16),
              _Banner(
                icon: Icons.info_outline_rounded,
                color: AppColors.redDark,
                background: AppColors.redTint,
                text:
                    'O WhatsApp não abriu automaticamente. Você também pode '
                    'tocar no botão verde do WhatsApp ou chamar no número '
                    'informado no rodapé.',
                action: TextButton(
                  onPressed: () => Clipboard.setData(
                    ClipboardData(
                      text: WhatsAppService.buildLeadMessage(_collect()),
                    ),
                  ),
                  child: const Text('Copiar mensagem'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    super.key,
    required this.icon,
    required this.color,
    required this.background,
    required this.text,
    this.action,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1.2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 14.5,
                      height: 1.45,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textStrong,
                    ),
                  ),
                  if (action != null) action!,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
