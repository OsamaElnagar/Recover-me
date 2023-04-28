import 'package:flutter/material.dart';

Widget recoverTextButton({
  Color? buttonColor,
  Color? textColor,
  double? width,
  double? height,
  double? fs,
  required String text,
  required VoidCallback onPressed,
}) {
  return Container(
    width: width ?? 120,
    height: height ?? 40,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: buttonColor,
      border: Border.all(
        color: Colors.white,
        width: 2.0,
      ),
      boxShadow: const [
        BoxShadow(color: Colors.white24),
        BoxShadow(color: Colors.white),
      ],
    ),
    child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: fs?? 18.0,
          ),
          textAlign: TextAlign.center,
        )),
  );
}
