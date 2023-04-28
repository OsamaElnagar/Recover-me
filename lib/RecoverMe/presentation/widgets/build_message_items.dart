import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/chatModel.dart';
import '../../../data/styles/colors.dart';


class MessageBuilder extends StatelessWidget {

  const MessageBuilder(
      {Key? key,
      required this.chatsModel,
      required this.alignmentDirectional,
      required this.radius,
      required this.color,
      required this.crossAxisAlignment})
      : super(key: key);

  final ChatsModel chatsModel;
  final AlignmentDirectional alignmentDirectional;
  final BorderRadiusDirectional radius;
  final CrossAxisAlignment crossAxisAlignment;
  final Color color;

  @override
  Widget build(BuildContext context) {
    String messageDateTime = chatsModel.messageDateTime;
    messageDateTime =
        DateFormat.E().add_jm().format(DateTime.parse(messageDateTime));

    return Align(
      alignment: alignmentDirectional,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (chatsModel.textMessage != '' && chatsModel.imageMessage == '')
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(color: color, borderRadius: radius),
                child: Column(
                  crossAxisAlignment: crossAxisAlignment,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, bottom: 4.0, left: 4, right: 4),
                      child: Text(
                        chatsModel.textMessage,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 4.0, bottom: 4.0, left: 4, right: 4),
                      child: Text(
                        messageDateTime.substring(3),
                        style: const TextStyle(
                            color: RecoverColors.recoverRoyalBlue,
                            fontSize: 13,
                            height: .5),
                      ),
                    ),
                  ],
                ),
              ),
            if (chatsModel.textMessage == '' && chatsModel.imageMessage != '')
              Container(
                padding: const EdgeInsets.all(2),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(5),
                    topEnd: Radius.circular(5),
                    topStart: Radius.circular(5),
                    bottomStart: Radius.circular(5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: crossAxisAlignment,
                  children: [
                    ImageMessage(chatsModel: chatsModel, color: color),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 4),
                      child: Text(
                        messageDateTime.substring(3),
                        style: const TextStyle(
                            color: RecoverColors.recoverRoyalBlue,
                            fontSize: 13,
                            height: .5),
                      ),
                    ),
                  ],
                ),
              ),
            if (chatsModel.textMessage != '' && chatsModel.imageMessage != '')
              Container(
                padding: const EdgeInsets.all(2),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                width: 244,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadiusDirectional.only(
                    bottomEnd: Radius.circular(5),
                    topEnd: Radius.circular(5),
                    topStart: Radius.circular(5),
                    bottomStart: Radius.circular(5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: crossAxisAlignment,
                  children: [
                    ImageMessage(chatsModel: chatsModel, color: color),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        chatsModel.textMessage,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 4),
                      child: Text(
                        messageDateTime.substring(3),
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                            color: RecoverColors.recoverRoyalBlue,
                            fontSize: 13,
                            height: .5),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ImageMessage extends StatelessWidget {
  const ImageMessage({
    super.key,
    required this.chatsModel,
    required this.color,
  });

  final ChatsModel chatsModel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadiusDirectional.only(
            bottomEnd: Radius.circular(5),
            topEnd: Radius.circular(5),
            topStart: Radius.circular(5),
            bottomStart: Radius.circular(5),
          )),
      child: CachedNetworkImage(
        imageUrl: chatsModel.imageMessage,
        progressIndicatorBuilder: (context, url, progress) => Center(
          child: CircularProgressIndicator(
            value: progress.progress,
          ),
        ),
        fit: BoxFit.cover,
      ),
    );
  }
}

class FullScreenDisplay extends StatelessWidget {
  const FullScreenDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
