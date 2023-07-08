// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recover_me/data/models/patient_login_model.dart';
import 'package:recover_me/domain/bloc/recover/recover_cubit.dart';
import 'package:recover_me/presentation/components/components.dart';
import 'package:recover_me/presentation/widgets/glassy.dart';
import 'package:recover_me/presentation/widgets/my_background_designs.dart';
import 'package:recover_me/presentation/widgets/recover_text_button.dart';
import 'package:recover_me/data/styles/colors.dart';
import 'package:recover_me/data/styles/fonts.dart';
import 'package:recover_me/data/styles/paddings.dart';
import 'package:recover_me/data/styles/texts.dart';
import '../../../../../domain/bloc/patient_register/patient_register_cubit.dart';
import 'patient_home_screen.dart';

class PatientPrefsScreen extends StatefulWidget {
  PatientPrefsScreen({Key? key, this.oldUser, this.patLoginModel})
      : super(key: key);
  bool? oldUser;
  PatientLoginModel? patLoginModel;

  @override
  State<PatientPrefsScreen> createState() => _PatientPrefsScreenState();
}

class _PatientPrefsScreenState extends State<PatientPrefsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PatientRegisterCubit(),
      child: BlocConsumer<PatientRegisterCubit, PRegisterStates>(
        listener: (context, state) {
          if (state is PRegisterUpdateOnlyProfileImageSuccessState) {
            navigate2(context, const PatientHomeScreen());
          } else if (state is PRegisterUpdateDisabilitySuccessState) {
            navigate2(context, const PatientHomeScreen());
          }
        },
        builder: (context, state) {
          var cubit = PatientRegisterCubit.get(context);
          var bigCubit = RecoverCubit.get(context);

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
                              navigate2(context, const PatientHomeScreen()),
                        ),
                        glassyContainer(
                          child: RecoverHeadlines(
                            headline: 'Set up an Image and Choose your Injury!',
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
                                      bigCubit.useDefault(collection:'patients');
                                      Navigator.pop(context);
                                    },
                                    onDisplayTap: () {
                                      Navigator.pop(context);
                                    },
                                    image: widget.patLoginModel!.profileImage,
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
                                  backgroundImage: cubit.profileImageFile !=
                                          null
                                      ? FileImage(cubit.profileImageFile!)
                                      : widget.patLoginModel != null
                                          ? NetworkImage(widget
                                              .patLoginModel!.profileImage)
                                          : const AssetImage(
                                                  'assets/images/patient.jpg')
                                              as ImageProvider,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (state
                            is PRegisterUpdateOnlyProfileImageLoadingState)
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
                                style:
                                    RecoverTextStyles.recoverRegularMontserrat(
                                  color: Colors.white,
                                  fs: 12.0,
                                ),
                                onChanged: (String? value) {
                                  cubit.dropdownSelection(value);
                                  pint(cubit.dropdownValue.toString());
                                },
                                items: cubit.injures
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
                        recoverTextButton(
                          text: 'Update',
                          onPressed: () {
                            if (cubit.profileImageFile != null) {
                              cubit.updateOnlyProfileImage();
                            }
                            cubit.updatePatientDisability(
                                disability: cubit.dropdownValue);
                          },
                          textColor: RecoverColors.recoverWhite,
                          width: MediaQuery.of(context).size.width / 2.5,
                          buttonColor: RecoverColors.myColor,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (state is PRegisterUpdateDisabilityLoadingState)
                          const LinearProgressIndicator(
                              color: RecoverColors.myColor),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
