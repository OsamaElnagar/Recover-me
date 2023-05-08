import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recover_me/presentation/components/components.dart';
import 'package:recover_me/presentation/pages/home/doctor/doctor_home_screen.dart';
import 'package:recover_me/presentation/pages/home/doctor/doctor_professsion_screen.dart';
import 'package:recover_me/presentation/widgets/neumorphism_button.dart';
import 'package:recover_me/presentation/widgets/recover_text_button.dart';
import 'package:recover_me/data/styles/colors.dart';
import 'package:recover_me/data/styles/form_fields.dart';
import 'package:recover_me/data/styles/paddings.dart';
import 'package:recover_me/data/styles/texts.dart';
import 'package:recover_me/domain/bloc/recover/recover_cubit.dart';
import '../../../../../domain/bloc/update_profile/update_profile_cubit.dart';

class DoctorEditProfile extends StatefulWidget {
  const DoctorEditProfile({Key? key}) : super(key: key);

  @override
  State<DoctorEditProfile> createState() => _DoctorEditProfileState();
}

class _DoctorEditProfileState extends State<DoctorEditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  FocusNode emailNode = FocusNode();
  FocusNode nameNode = FocusNode();
  FocusNode phoneNode = FocusNode();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    nameNode.dispose();
    emailNode.dispose();
    phoneNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateProfileCubit()..getDoctorModel(),
      child: BlocConsumer<UpdateProfileCubit, UpdateProfileStates>(
        listener: (context, state) {
          if (state is UpdateOnlyProfileImageSuccessState) {
            showToast(msg: 'Updated Successfully', state: ToastStates.success);
            RecoverCubit.get(context).getDoctorData();
            navigate2(context, const DoctorHomeScreen());
          } else if (state is UpdateProfileSuccessState) {
            showToast(msg: 'Updated Successfully', state: ToastStates.success);
            RecoverCubit.get(context).getDoctorData();
            navigate2(context, const DoctorHomeScreen());
          }
        },
        builder: (context, state) {
          var cubit = UpdateProfileCubit.get(context);
          return Scaffold(
            body: SafeArea(
              child: ConditionalBuilder(
                condition:
                    UpdateProfileCubit.get(context).doctorLoginModel != null,
                builder: (context) {
                  return SingleChildScrollView(
                    child: RecoverPaddings.recoverAuthPadding(
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),

                            neumorphism(
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            RecoverHeadlines(
                              headline: 'Update your account',
                              color: RecoverColors.myColor,
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: RecoverTextFormField(
                                    hintText: cubit.doctorLoginModel!.name!,
                                    controller: nameController,
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      return null;

                                      // if (value!.isEmpty) {
                                      //   return ' name must not be empty';
                                      // }
                                      // return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 35,
                                      backgroundImage: cubit.profileImageFile !=
                                              null
                                          ? FileImage(cubit.profileImageFile!)
                                          : NetworkImage(cubit.doctorLoginModel!
                                              .profileImage!) as ImageProvider,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) => SizedBox(
                                            height: 70,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    cubit
                                                        .getGalleryProfileImage();
                                                  },
                                                  child: Column(
                                                    children: [
                                                      RecoverNormalTexts(
                                                          norText: 'Gallery',
                                                          color: RecoverColors
                                                              .myColor),
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
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  margin:
                                                      const EdgeInsets.all(15),
                                                  width: 3,
                                                  height: 50,
                                                  color: RecoverColors.myColor,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    cubit
                                                        .getCameraProfileImage();
                                                  },
                                                  child: Column(
                                                    children: [
                                                      RecoverNormalTexts(
                                                          norText: 'Camera',
                                                          color: RecoverColors
                                                              .myColor),
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
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.black.withOpacity(.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            RecoverTextFormField(
                              hintText: cubit.doctorLoginModel!.email!,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                return null;

                                // if (value!.isEmpty) {
                                //   return ' Email must not be empty';
                                // }
                                // return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            RecoverTextFormField(
                              hintText: cubit.doctorLoginModel!.phone != ''
                                  ? cubit.doctorLoginModel!.phone!
                                  : 'phone',
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                return null;

                                // if (value!.isEmpty) {
                                //   return ' phone must not be empty';
                                // }
                                // return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            // create a new account
                            Center(
                              child: recoverTextButton(
                                width: MediaQuery.of(context).size.width * .6,
                                text: 'Update account',
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    if (cubit.profileImageFile != null) {
                                      cubit.updateOnlyDoProfileImage();
                                    }

                                    if (nameController.text != '' ||
                                        emailController.text != '' ||
                                        phoneController.text != '') {
                                      cubit.updateDoctorProfile(
                                        name: nameController.text != ''
                                            ? nameController.text
                                            : cubit.doctorLoginModel!.name,
                                        email: emailController.text != ''
                                            ? emailController.text
                                            : cubit.doctorLoginModel!.email,
                                        phone: phoneController.text != ''
                                            ? phoneController.text
                                            : cubit.doctorLoginModel!.phone,
                                      );
                                    }
                                  }
                                },
                                buttonColor: RecoverColors.myColor,
                                textColor: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            if (state is UpdateOnlyProfileImageLoadingState ||
                                state is UpdateProfileLoadingState)
                              const LinearProgressIndicator(
                                color: RecoverColors.myColor,
                              ),
                            GestureDetector(
                              onTap: () {
                                navigateTo(context, const DocProfAndImage());
                              },
                              child: RecoverHints(
                                hint: 'I want to see my training!',
                                color: RecoverColors.myColor,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: RecoverColors.myColor),
                                  onPressed: () {
                                    dialogMessage(
                                      context: context,
                                      title: const Text('Logout!'),
                                      content: const Text('Are you sure!'),
                                      actions: [
                                        OutlinedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: OutlinedButton.styleFrom(
                                              backgroundColor: Colors.white),
                                          child: const Text('No'),
                                        ),
                                        OutlinedButton(
                                          onPressed: () {
                                            cubit.logout(context);
                                          },
                                          style: OutlinedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          child: const Text('Yes'),
                                        ),
                                      ],
                                    );

                                  },
                                  icon: const Icon(
                                    Icons.logout,
                                    size: 24.0,
                                  ),
                                  label: const Text('Log out'), // <-- Text
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: RecoverColors.myColor),
                                  onPressed: () {
                                    dialogMessage(
                                      context: context,
                                      title: const Text('Delete account!'),
                                      content: const Text('Are you sure!'),
                                      actions: [
                                        OutlinedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: OutlinedButton.styleFrom(
                                              backgroundColor: Colors.white),
                                          child: const Text('No'),
                                        ),
                                        OutlinedButton(
                                          onPressed: () {
                                            cubit.deleteDoctorAccount(context);
                                          },
                                          style: OutlinedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          child: const Text('Yes'),
                                        ),
                                      ],
                                    );
                                    //cubit.deletePatientAccount(context);
                                  },
                                  icon: const Icon(
                                    Icons.logout,
                                    size: 24.0,
                                  ),
                                  label:
                                      const Text('Delete account'), // <-- Text
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                fallback: (context) {
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
