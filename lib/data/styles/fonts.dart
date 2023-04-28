import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class RecoverTextStyles {
  static recoverRegularMontserrat({color, fw, fs}) {
    return GoogleFonts.montserrat(
      color: color ?? RecoverColors.recoverWhite,
      fontWeight: fw ?? FontWeight.w600,
      fontSize: fs ?? 20,
    );
  }

  static recoverHintMontserrat({color, fw, fs}) {
    return GoogleFonts.montserrat(
      color: color ?? RecoverColors.recoverGrey,
      fontWeight: fw ?? FontWeight.w500,
      fontSize: fs ?? 15,
    );
  }

  static recoverHeadlines({color, fw, fs}) {
    return GoogleFonts.montserrat(
      color: color ?? RecoverColors.recoverWhite,
      fontWeight: fw ?? FontWeight.w700,
      fontSize: fs ?? 25,
    );
  }
}
