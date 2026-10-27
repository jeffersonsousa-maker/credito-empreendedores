import 'package:flutter/material.dart';

/// Paleta inspirada em comunicação visual vermelha/branca, sem reproduzir
/// marcas. Contrastes verificados para WCAG AA (texto normal >= 4,5:1).
class AppColors {
  AppColors._();

  // Vermelho principal (botões, chamadas, destaques). Branco sobre ele: ~4,8:1.
  static const Color red = Color(0xFFE11B22);
  static const Color redDark = Color(0xFFB5121A);
  static const Color redDeep = Color(0xFF8E0D13);
  static const Color redTint = Color(0xFFFDECEC);
  static const Color redTintStrong = Color(0xFFF9D3D4);

  // Neutros
  static const Color white = Color(0xFFFFFFFF);
  static const Color surfaceGray = Color(0xFFF5F5F7);
  static const Color border = Color(0xFFE3E3E8);
  static const Color textStrong = Color(0xFF1C1C21);
  static const Color text = Color(0xFF3A3B42);
  static const Color textMuted = Color(0xFF5E606A);
  static const Color footer = Color(0xFF17171B);
  static const Color footerText = Color(0xFFC9CAD1);

  // Verde para ações de WhatsApp (branco sobre ele: ~5:1).
  static const Color whatsapp = Color(0xFF0B8043);
  static const Color whatsappDark = Color(0xFF07663A);

  // Feedback
  static const Color error = Color(0xFFB3261E);

  // Sombras discretas (cores com alfa explícito).
  static const Color shadowSoft = Color(0x14000000); // 8%
  static const Color shadowMedium = Color(0x1F000000); // 12%
  static const Color redShadow = Color(0x40E11B22); // 25%
  static const Color whiteTranslucent = Color(0x26FFFFFF); // 15%
  static const Color whiteSoft = Color(0xE6FFFFFF); // 90%
}
