import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:recover_me/data/styles/fonts.dart';
import '../../../data/models/game_model.dart';
import '../../../data/styles/colors.dart';
import '../../../data/styles/texts.dart';

class GameItemBuilder extends StatelessWidget {
  const GameItemBuilder({Key? key, required this.gameModel}) : super(key: key);

  final GameModel gameModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(152),
          ),
          elevation: 20.0,
          child: ClipRRect(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: CircleAvatar(
              radius: 152,
              backgroundColor: RecoverColors.myColor,
              child: CircleAvatar(
                radius: 150,
                backgroundImage: CachedNetworkImageProvider(gameModel.image),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        RecoverHeadlines(
          headline: gameModel.name,
          color: RecoverColors.myColor,
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(
                color: RecoverColors.myColor,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),

            child : Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ReadMoreText(
                gameModel.description,
                style: RecoverTextStyles.recoverHintMontserrat(
                  color: RecoverColors.myColor,
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }
}
