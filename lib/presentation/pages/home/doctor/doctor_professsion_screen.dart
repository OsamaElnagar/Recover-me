import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recover_me/data/data_sources/consts.dart';
import 'package:recover_me/data/models/doctor_login_model.dart';
import 'package:recover_me/presentation/components/components.dart';
import 'package:recover_me/presentation/pages/home/doctor/doctor_home_screen.dart';
import 'package:recover_me/presentation/widgets/glassy.dart';
import 'package:recover_me/presentation/widgets/my_background_designs.dart';
import 'package:recover_me/presentation/widgets/recover_text_button.dart';
import 'package:recover_me/data/styles/colors.dart';
import 'package:recover_me/data/styles/fonts.dart';
import 'package:recover_me/data/styles/paddings.dart';
import 'package:recover_me/data/styles/texts.dart';
import '../../../../../domain/bloc/doctor_register/doctor_register_cubit.dart';
import '../../../../domain/bloc/recover/recover_cubit.dart';

class DocProfAndImage extends StatefulWidget {
  DocProfAndImage({Key? key, this.oldUser, this.docLoginModel})
      : super(key: key);

  bool? oldUser;
  DoctorLoginModel? docLoginModel;

  @override
  State<DocProfAndImage> createState() => _DocProfAndImageState();
}

class _DocProfAndImageState extends State<DocProfAndImage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoctorRegisterCubit(),
      child: BlocConsumer<DoctorRegisterCubit, DRegisterStates>(
        listener: (context, state) {
          if (state is DRegisterUpdateOnlyProfileImageSuccessState) {
            navigate2(context, const DoctorHomeScreen());
          } else if (state is DRegisterUpdateProfSuccessState) {
            navigate2(context, const DoctorHomeScreen());
          }
        },
        builder: (context, state) {
          var cubit = DoctorRegisterCubit.get(context);
          var bigCubit = RecoverCubit.get(context);
          // String dropdownValue = cubit.trainings[0];
          return Scaffold(
              body: SafeArea(
            child: SingleChildScrollView(
              child: typeBackground(
                context: context,
                asset: 'assets/images/Cool-phone-wallpaper.jpg',
                child: RecoverPaddings.recoverAuthPadding(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: RecoverNormalTexts(
                          norText: 'Skip',
                        ),
                        onPressed: () =>
                            navigate2(context, const DoctorHomeScreen()),
                      ),
                      glassyContainer(
                        child: RecoverHeadlines(
                          headline: 'Set up an Image and Choose your Training!',
                          color: RecoverColors.recoverWhite,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      // Profile image selection.
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: RecoverColors.myColor,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                buildShowModalBottomSheet(
                                  context: context,
                                  onGalleryTap: () {
                                    cubit.getGalleryProfileImage();
                                    Navigator.pop(context);
                                  },
                                  onCameraTap: () {
                                    cubit.getCameraProfileImage();
                                    Navigator.pop(context);
                                  },
                                  onDefaultTap: () {
                                    bigCubit.useDefault(collection:'doctors');
                                    Navigator.pop(context);},
                                  onDisplayTap: () { Navigator.pop(context);},
                                  image: widget.docLoginModel!.profileImage,
                                );
                              },
                              child: RecoverNormalTexts(
                                norText: 'Choose Profile Image ',
                                color: RecoverColors.myColor,
                                fs: 18,
                              ),
                            ),
                            const Spacer(),
                            CircleAvatar(
                              radius: 46,
                              backgroundColor: RecoverColors.myColor,
                              child: CircleAvatar(
                                radius: 45,
                                backgroundImage: cubit.profileImageFile != null
                                    ? FileImage(cubit.profileImageFile!)
                                    : widget.docLoginModel != null
                                        ? NetworkImage(
                                            widget.docLoginModel!.profileImage!)
                                        : const AssetImage(
                                                'assets/images/doctor_avatar.jpg')
                                            as ImageProvider,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (state is DRegisterUpdateOnlyProfileImageLoadingState)
                        const LinearProgressIndicator(
                            color: RecoverColors.myColor),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: RecoverColors.myColor,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .8,
                          child: Center(
                            child: DropdownButton<String>(
                              dropdownColor: RecoverColors.myColor,
                              icon: const SizedBox(),
                              underline: const SizedBox(),
                              value: cubit.dropdownValue,
                              style: RecoverTextStyles.recoverRegularMontserrat(
                                color: Colors.white,
                                fs: 12.0,
                              ),
                              onChanged: (String? value) {
                                cubit.dropdownSelection(value);
                                pint(cubit.dropdownValue.toString());
                              },
                              items: cubit.trainings
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          recoverTextButton(
                            text: 'Update',
                            onPressed: () {
                              if (cubit.profileImageFile != null) {
                                cubit.updateOnlyProfileImage();
                              }
                              cubit.updateDoctorProf(
                                  prof: cubit.dropdownValue!);
                            },
                            textColor: RecoverColors.recoverWhite,
                            width: MediaQuery.of(context).size.width / 2.5,
                            buttonColor: RecoverColors.myColor,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (state is DRegisterUpdateProfLoadingState)
                            const LinearProgressIndicator(
                                color: RecoverColors.myColor),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ));
        },
      ),
    );
  }
}
