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
      filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
      child: Center(child: child),
    ),
  );
}
