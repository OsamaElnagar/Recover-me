import 'package:flutter/material.dart';

import '../../data/styles/colors.dart';

Widget myContainer({required Widget child,Color? color}) {
  return Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      border: Border.all(
        color:color?? RecoverColors.myColor,
        width: 2.0,
      ),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: child,
  );
}
