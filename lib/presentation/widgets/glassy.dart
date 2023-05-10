import 'dart:ui';

import 'package:flutter/material.dart';

ClipRect glassyContainer({required Widget child}) {
  return ClipRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          //color: Colors.grey.shade200.withOpacity(0.5),
        ),
        child: child,
      ),
    ),
  );
}