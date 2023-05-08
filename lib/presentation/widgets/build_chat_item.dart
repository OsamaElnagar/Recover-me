import 'package:flutter/material.dart';
import '../../../data/models/doctor_login_model.dart';
import '../../../data/styles/colors.dart';
import '../../../data/styles/texts.dart';


class BuildChatItem extends StatelessWidget {
  const BuildChatItem({Key? key, required this.loginModel, required this.index})
      : super(key: key);
  final DoctorLoginModel loginModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // navigateTo(
        //     context,
        //     MessengerScreen(
        //       loginModel: loginModel,
        //     ));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5),
        color: RecoverColors.recoverCelestialBlue,
        child: Padding(
          padding: const EdgeInsets.only(left: 2, right: 2, bottom: 4, top: 4),
          child: Row(
            children: [
              CircleAvatar(
                radius: 34.0,
                backgroundColor: RecoverColors.recoverRoyalBlue,
                child: CircleAvatar(
                  radius: 32.0,
                  backgroundImage: NetworkImage(loginModel.profileImage!),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RecoverNormalTexts(norText: loginModel.name!,color: RecoverColors.recoverWhite,fs: 16,),
                    ///////////////////////////
                    // i will display here th last message
                    RecoverHints(hint: 'last message',color: RecoverColors.recoverRoyalBlue,)
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert,
                  color: RecoverColors.recoverWhite,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
