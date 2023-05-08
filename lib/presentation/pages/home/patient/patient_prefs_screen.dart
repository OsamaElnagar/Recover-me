import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recover_me/presentation/components/components.dart';
import 'package:recover_me/presentation/widgets/recover_text_button.dart';
import 'package:recover_me/data/styles/colors.dart';
import 'package:recover_me/data/styles/fonts.dart';
import 'package:recover_me/data/styles/paddings.dart';
import 'package:recover_me/data/styles/texts.dart';
import '../../../../../domain/bloc/patient_register/patient_register_cubit.dart';
import 'patient_home_screen.dart';

class PatientPrefsScreen extends StatefulWidget {
  const PatientPrefsScreen({Key? key}) : super(key: key);

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
          }
          else if (state is PRegisterUpdateDisabilitySuccessState) {
            navigate2(context, const PatientHomeScreen());
          }
        },
        builder: (context, state) {
          var cubit = PatientRegisterCubit.get(context);

          return Scaffold(
              body: SafeArea(
            child: RecoverPaddings.recoverAuthPadding(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  recoverTextButton(
                    text: 'Skip',
                    onPressed: () =>
                        navigate2(context, const PatientHomeScreen()),
                  ),
                  RecoverPaddings.recoverAuthPadding(
                    child: RecoverHeadlines(
                      headline: 'Set up an Image and Choose your Injury!',
                      color: RecoverColors.myColor,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
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
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => SizedBox(
                                height: 70,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        cubit.getGalleryProfileImage();
                                      },
                                      child: Column(
                                        children: [
                                          RecoverNormalTexts(
                                              norText: 'Gallery',
                                              color: RecoverColors.myColor),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          const Icon(
                                            Icons.browse_gallery,
                                            color: Colors.yellow,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      margin: const EdgeInsets.all(15),
                                      width: 3,
                                      height: 50,
                                      color: RecoverColors.myColor,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        cubit.getCameraProfileImage();
                                      },
                                      child: Column(
                                        children: [
                                          RecoverNormalTexts(
                                              norText: 'Camera',
                                              color: RecoverColors.myColor),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          const Icon(
                                            Icons.camera_alt,
                                            color: Colors.blue,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                                : const AssetImage('assets/images/patient.jpg')
                                    as ImageProvider,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (state is PRegisterUpdateOnlyProfileImageLoadingState)
                    const LinearProgressIndicator(color: RecoverColors.myColor),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      RecoverNormalTexts(
                        norText: 'Choose Your Injury',
                        color: Colors.black,
                        fs: 18,
                      ),
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
                        child: DropdownButton<String>(
                          underline: const Divider(),
                          value: cubit.dropdownValue,
                          style: RecoverTextStyles.recoverRegularMontserrat(
                              color: Colors.black, fs: 18.0),
                          onChanged: (String? value) {
                            cubit.dropdownSelection(value);
                            pint(cubit.dropdownValue.toString());
                          },
                          items: cubit.injures
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
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
                          cubit.updatePatientDisability(disability: cubit.dropdownValue);
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
                ],
              ),
            ),
          ));
        },
      ),
    );
  }
}
