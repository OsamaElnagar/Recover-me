import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recover_me/data/styles/colors.dart';



void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

Future navigate2(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) => false,
    );


Widget recoverButton({required String string, required Function() onPressed}) {
  return Container(
    width: 664 / 2.7,
    height: 155 / 2.8,
    decoration: const BoxDecoration(
      borderRadius: BorderRadiusDirectional.all(Radius.circular(25 / 3)),
      color: RecoverColors.recoverRed,
    ),
    child: TextButton(
      onPressed: onPressed,
      child: Text(
        string,
        style: GoogleFonts.montserrat(
            color: RecoverColors.recoverWhite,
            fontWeight: FontWeight.w700,
            fontSize: 20),
      ),
    ),
  );
}
void showToast({
  required String msg,
  required ToastStates state,
}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 12.0);
}

enum ToastStates { success, error, warning }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.success:
      color = Colors.green;
      break;
    case ToastStates.warning:
      color = Colors.yellow;
      break;
    case ToastStates.error:
      color = Colors.red;
      break;
  }
  return color;
}

void printFulltext(String text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((element) {
    debugPrint(element.group(0));
  });
}



void pint(String text) {
  debugPrint(text);
}

void dialogMessage({
  required BuildContext context,
  required Widget title,
  required Widget content,
  required List<Widget> actions,
}) {
  showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: title,
        content: content,
        actions: actions,
      ));
}


