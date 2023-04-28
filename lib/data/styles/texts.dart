// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'fonts.dart';

class RecoverHints extends StatelessWidget {
  RecoverHints({
    Key? key,
    required this.hint,
    this.textAlign,
    this.color,
    this.fs,
    this.fw,
    this.overflow,
    this.maxLines,
  }) : super(key: key);

  final String hint;
  final TextAlign? textAlign;
  Color? color;
  double? fs;
  FontWeight? fw;
  TextOverflow? overflow;
  int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      hint,
      style:
          RecoverTextStyles.recoverHintMontserrat(color: color, fs: fs, fw: fw),
      textAlign: textAlign ?? TextAlign.center,
      overflow: overflow ?? TextOverflow.ellipsis,
      maxLines: maxLines ?? 15,
    );
  }
}

class RecoverHeadlines extends StatelessWidget {
  RecoverHeadlines(
      {Key? key,
      required this.headline,
      this.color,
      this.textAlign,
      this.fs,
      this.fw,
      this.overflow,
      this.maxLines})
      : super(key: key);

  final String headline;
  final TextAlign? textAlign;
  Color? color;
  double? fs;
  FontWeight? fw;
  TextOverflow? overflow;
  int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      headline,
      textAlign: textAlign ?? TextAlign.center,
      style: RecoverTextStyles.recoverHeadlines(color: color, fs: fs, fw: fw),
      overflow: overflow ?? TextOverflow.ellipsis,
      maxLines: maxLines ?? 15,
    );
  }
}

class RecoverNormalTexts extends StatelessWidget {
  RecoverNormalTexts({
    Key? key,
    required this.norText,
    this.color,
    this.textAlign,
    this.fs,
    this.fw,
    this.overflow,
    this.maxLines,
  }) : super(key: key);

  final String norText;
  final TextAlign? textAlign;
  Color? color;
  double? fs;
  FontWeight? fw;
  TextOverflow? overflow;
  int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      norText,
      textAlign: textAlign ?? TextAlign.center,
      style: RecoverTextStyles.recoverRegularMontserrat(
        fs: fs,
        fw: fw,
        color: color,
      ),
      overflow: overflow ?? TextOverflow.ellipsis,
      maxLines: maxLines ?? 15,
    );
  }
}

SizedBox recoverSpacer({width, height}) {
  return SizedBox(
    width: width ?? double.infinity,
    height: height ?? 25.0,
  );
}

Divider recoverDivider({thickness, height, color}) {
  return Divider(
    height: height,
    color: color,
    thickness: thickness,
  );
}
