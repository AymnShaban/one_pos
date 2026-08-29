import 'package:flutter/material.dart';

abstract class AppColors {
  // ── Primary ──────────────────────────────────────
  static const Color mainAppColor = Color(0xff3B5BDB); // POS Blue
  static const Color tealAccentColor = Color(0xff5C7CFA); // Light Blue Accent

  // Brand Colors (Added)
  static const Color brand = Color(0xFF1E4FD8);
  static const Color brandDark = Color(0xFF0E2E8C);
  static const Color brandLight = Color(0xFFEAF0FD);

  // ── Secondary ────────────────────────────────────
  static const Color secondaryAppColor = Color(0xff8A8F99);
  static const Color hitColor = Color(0xff8A8F99);

  // ── Backgrounds ──────────────────────────────────
  static const Color backgroundColor = Color(0xffF0F2F8);
  static const Color backgroundColor2 = Color(0xffEEF2FF);
  static const Color backgroundColor3 = Color(0xff5C7CFA);

  static const Color whiteColor = Color(0xffFFFFFF);
  static const Color white1 = Color(0xffF5F6F7);
  static const Color white2 = Color(0xffF5F6F7);

  // Additional Backgrounds
  static const Color slateBg = Color(0xFFF0F3F8);
  static const Color card = Colors.white;

  // ── Text ─────────────────────────────────────────
  static Color black = const Color(0xff1A1A1A);
  static Color grey = const Color(0xff8A8F99);
  static Color white = Colors.white;
  static Color white4 = const Color(0xffF5F5F5);
  static Color codGray = const Color(0xff2C2C2C);

  // Additional Text Colors
  static const Color textDark = Color(0xFF16294D);
  static const Color textMuted = Color(0xFF7C8AA0);

  // ── Status / Semantic ─────────────────────────────
  static const Color green = Color(0xff40C057);
  static const Color greenBg = Color(0xffD3F9D8);

  static const Color amber = Color(0xffF59F00);
  static const Color amberBg = Color(0xffFFF3BF);

  static const Color red = Color(0xffFA5252);
  static const Color redBg = Color(0xffFFE3E3);

  static Color redDynamic = const Color(0xffFF0909);

  // ── Additional Semantic Colors ───────────────────
  static const Color teal = Color(0xFF16A98A);
  static const Color tealBg = Color(0xFFE4F7F1);

  static const Color orange = Color(0xFFF0862E);
  static const Color orangeBg = Color(0xFFFDEEE0);

  static const Color blue = Color(0xFF2F6FE0);
  static const Color blueBg = Color(0xFFEAF0FD);

  static const Color purpleBg = Color(0xFFEFEBFE);

  static const Color line = Color(0xFFE6EAF1);

  // ── Accent ───────────────────────────────────────
  static const Color purple = Color(0xff9B59B6);
  static const Color secondaryColor = Color(0xffF59F00);
  static const navyDark = Color(0xFF0B1F45);
  static const navyMid = Color(0xFF12315F);
  static const navyLight = Color(0xFF1C4A86);

  static const gold = Color(0xFFE8A33D);
  static const goldLight = Color(0xFFF2B955);


  static const greenDark = Color(0xFF158A49);



  static const ink = Color(0xFF1F2A3C);
  static const muted = Color(0xFF8892A0);
  static const lineColor = Color(0xFFECEFF4);
  static const pageBg = Color(0xFFDFE4EC);

  static const tintCream = Color(0xFFFDF8EA);
  static const tintCreamLine = Color(0xFFEFE0B4);
  static const tintBlue = Color(0xFFEAF4FB);
  static const tintGreen = Color(0xFFEAFAF0);

  static const sand = Color(0xFFFDF3DF);
  static const sandLine = Color(0xFFF0D9A3);
  static const Color sandColor = Color(0xFFFDF3DF);
  static const Color sandBorderColor = Color(0xFFF0D9A3);
  static const Color borderColor = Color(0xFFECEFF4);

  static const Color lightGray = Color(0xFFEEF1F6);
  static const Color textPrimary = Color(0xFF1F2A3C);
  static const navyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [navyLight, navyMid, navyDark],
  );
  // ── Gradients ────────────────────────────────────
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      brand,
      brandDark,
    ],
  );
}