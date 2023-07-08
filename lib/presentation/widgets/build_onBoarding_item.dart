// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../../data/models/boardingModel.dart';
import '../../../data/styles/colors.dart';
import '../../../data/styles/texts.dart';

class OnBoardingBuilder extends StatelessWidget {
  const OnBoardingBuilder({Key? key, required this.boardingModel}) : super(key: key);

  final BoardingModel boardingModel;



  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Image(
            image: AssetImage(boardingModel.image),
            fit: BoxFit.fitWidth,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: RecoverHints(
            hint: boardingModel.body,
            color: RecoverColors.recoverWhite,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
