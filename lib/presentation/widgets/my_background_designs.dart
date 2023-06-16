import 'dart:ui';

import 'package:flutter/material.dart';

Widget typeBackground({required Widget child, context, required String asset}) {
  return Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.fitHeight,
        image: AssetImage(asset),
      ),
    ),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
      child: Center(child: child),
    ),
  );
}
