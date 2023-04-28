import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import '../../../data/models/boardingModel.dart';
import '../../../data/styles/colors.dart';
import '../../../data/styles/texts.dart';

class OnBoardingBuilder extends StatelessWidget {
  OnBoardingBuilder({Key? key, required this.boardingModel}) : super(key: key);

  final BoardingModel boardingModel;

  PaletteGenerator? paletteGenerator;

  void getPaletteColor() async {
    ImageProvider image = AssetImage(boardingModel.image);
    paletteGenerator = await PaletteGenerator.fromImageProvider(image);
  }

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
