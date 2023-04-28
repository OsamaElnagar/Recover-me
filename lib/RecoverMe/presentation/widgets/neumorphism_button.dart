import 'package:flutter/material.dart';
import 'package:recover_me/data/styles/colors.dart';
import 'package:recover_me/data/styles/texts.dart';

Widget neumorphism({required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 70,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xff89c3eb),
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff89c3eb),
            Color(0xff89c3eb),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0xffbbf5ff),
            offset: Offset(-2.0, -2.0),
            blurRadius: 0,
            spreadRadius: 0.0,
          ),
          BoxShadow(
            color: Color(0xff5791b9),
            offset: Offset(2.0, 2.0),
            blurRadius: 0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: RecoverHints(hint: 'Back',color: RecoverColors.recoverWhite,),
    ),
  );
}
