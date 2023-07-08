// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recover_me/data/styles/colors.dart';
import '../../data/styles/texts.dart';
import '../widgets/outlined_container.dart';

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
  required dynamic title,
  required dynamic content,
  required List<Widget> actions,
  Color? barrierColor,
  Color? contentColor,
}) {
  showDialog<String>(
      barrierColor:
          barrierColor ?? RecoverColors.recoverCelestialBlue.withOpacity(.4),
      context: context,
      builder: (BuildContext context) => AlertDialog(
            backgroundColor: RecoverColors.myColor,
            title: (title is Widget)
                ? title
                : Text(
                    title,
                    style: TextStyle(
                      color: contentColor ?? Colors.white,
                    ),
                  ),
            content: (content is Widget)
                ? content
                : Text(
                    content,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
            actions: actions,
          ));
}

Future<dynamic> buildShowModalBottomSheet({
  required BuildContext context,
  required void Function()? onGalleryTap,
  required void Function()? onCameraTap,
  required void Function()? onDefaultTap,
  required void Function()? onDisplayTap,
  String? image,
}) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(50),
      ),
    ),
    builder: (context) => MyBottomSheet(
      onGalleryTap: onGalleryTap,
      onDisplayTap: onDisplayTap,
      onDefaultTap: onDefaultTap,
      onCameraTap: onCameraTap,
      image: image,
    ),
  );
}

class MyBottomSheet extends StatefulWidget {
  void Function()? onGalleryTap;
  void Function()? onCameraTap;
  void Function()? onDefaultTap;
  void Function()? onDisplayTap;
  String? image;

  MyBottomSheet({
    super.key,
    this.onGalleryTap,
    this.onCameraTap,
    this.onDefaultTap,
    this.onDisplayTap,
    this.image,
  });

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(50.0),
        topLeft: Radius.circular(50.0),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: RecoverColors.myColor,
        ),
        height: isExpanded
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.height * 0.4,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(15),
                  width: 50,
                  height: 2,
                  color: Colors.white54,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: widget.onGalleryTap,
                      child: myContainer(
                        color: Colors.white,
                        child: Column(
                          children: [
                            RecoverNormalTexts(
                                norText: 'Gallery', color: Colors.white),
                            const SizedBox(
                              height: 5.0,
                            ),
                            const Icon(
                              Icons.browse_gallery,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: widget.onCameraTap,
                      child: myContainer(
                        color: Colors.white,
                        child: Column(
                          children: [
                            RecoverNormalTexts(
                                norText: 'Camera', color: Colors.white),
                            const SizedBox(
                              height: 5.0,
                            ),
                            const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: widget.onDefaultTap,
                      child: myContainer(
                        color: Colors.white,
                        child: Column(
                          children: [
                            RecoverNormalTexts(
                                norText: 'Use\nDefault!', color: Colors.white),
                            const SizedBox(
                              height: 5.0,
                            ),
                            const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // widget.onDisplayTap
                        setState(() {
                          isExpanded = true;
                        });
                      },
                      child: myContainer(
                        color: Colors.white,
                        child: Column(
                          children: [
                            RecoverNormalTexts(
                                norText: 'Display\nPhoto!',
                                color: Colors.white),
                            const SizedBox(
                              height: 5.0,
                            ),
                            const Icon(
                              Icons.smart_display,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Expanded(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
              ],
            ),
            if (isExpanded)
              Image(
                image: NetworkImage(widget.image!),
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        color: Colors.white54,
                      ),
                    ),
                  );
                },
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Icon(Icons.error);
                },
                width: double.infinity,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }
}

void unFocusNodes(List<FocusNode> nodes) {
  for (var node in nodes) {
    node.unfocus();
  }
}
