import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recover_me/presentation/pages/home/patient/patient_prefs_screen.dart';
import 'package:recover_me/presentation/widgets/glassy.dart';
import 'package:recover_me/presentation/widgets/my_background_designs.dart';
import 'package:recover_me/presentation/widgets/neumorphism_button.dart';
import 'package:recover_me/presentation/widgets/recover_text_button.dart';
import 'package:recover_me/data/styles/colors.dart';
import 'package:recover_me/data/styles/form_fields.dart';
import 'package:recover_me/data/styles/paddings.dart';
import 'package:recover_me/data/styles/texts.dart';
import '../../../../../domain/bloc/patient_register/patient_register_cubit.dart';
import '../../../components/components.dart';
import '../login/login_screen.dart';

class PatientRegisterScreen extends StatefulWidget {
  const PatientRegisterScreen({Key? key}) : super(key: key);

  @override
  State<PatientRegisterScreen> createState() => _PatientRegisterScreenState();
}

class _PatientRegisterScreenState extends State<PatientRegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  FocusNode emailNode = FocusNode();
  FocusNode nameNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode passNode = FocusNode();

  @override
  void initState() {
    countryController.text = '+20';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PatientRegisterCubit(),
      child: BlocConsumer<PatientRegisterCubit, PRegisterStates>(
        listener: (context, state) {
          if (state is PRegisterCreateUserSuccessState) {
            navigate2(context, LoginScreen(isPatient: true));
            showToast(msg: 'Joined successfully', state: ToastStates.success);
          }

          if (state is PRegisterWithGoogleSuccessState) {
            navigate2(context, const PatientPrefsScreen());
            showToast(msg: 'Joined successfully', state: ToastStates.success);
          }

          if (state is PRegisterCreateUserErrorState) {
            showToast(msg: 'Invalid data', state: ToastStates.error);
          }
        },
        builder: (context, state) {
          var cubit = PatientRegisterCubit.get(context);

          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: typeBackground(
                  asset: 'assets/images/register-background.jpg',
                  context: context,
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
                            onTap: () => Navigator.pop(context),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          glassyContainer(
                            child: RecoverHeadlines(
                              headline: 'Create account for a Patient',
                              //color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          RecoverTextFormField(
                            hintText: 'name',
                            controller: nameController,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ' name must not be empty';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          RecoverTextFormField(
                            hintText: 'email',
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ' Email must not be empty';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          RecoverPhoneFormField(
                            hintText: 'phone',
                            controller: phoneController,
                            countryController: countryController,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          RecoverPassFormField(
                            label: 'Password',
                            onChanged: (p0) {
                              if (cubit.isShown == false) {
                                cubit.changePasswordVisibility();
                              }
                            },
                            hintText: 'Password',
                            controller: passController,
                            keyboardType: TextInputType.visiblePassword,
                            pRegisterCubit: cubit,
                            validator: (p0) {
                              if (p0!.isEmpty) {
                                return ' password cannot be empty';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (p0) {
                              if (formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // create a new account
                          Center(
                            child: recoverTextButton(
                              width: MediaQuery.of(context).size.width * .6,
                              text: 'Create account',
                              onPressed: () {
                                if (phoneController.text[0] == '0') {
                                  phoneController.text = phoneController.text
                                      .replaceFirst(RegExp(r'^.'), '');
                                }
                                if (formKey.currentState!.validate()) {
                                  PatientRegisterCubit.get(context)
                                      .registerPatient(
                                    name: nameController.text,
                                    phone: countryController.text +
                                        phoneController.text,
                                    email: emailController.text
                                        .replaceAll(' ', ''),
                                    password: passController.text,
                                  );
                                }
                              },
                              buttonColor: RecoverColors.myColor,
                              textColor: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          if (state is PRegisterLoadingState)
                            const LinearProgressIndicator(
                              color: RecoverColors.myColor,
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                          // Sign up with google
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                cubit.signInWithGoogle();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width * .7,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2, color: RecoverColors.myColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircleAvatar(
                                      radius: 15,
                                      backgroundImage:
                                       AssetImage('assets/images/google.jpg'),
                                    ),
                                    RecoverNormalTexts(
                                      norText: 'Sign Up with Google',
                                      color: RecoverColors.myColor,
                                      fs: 16.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RecoverHints(
                                  hint: 'Already have an account?',
                                 color:RecoverColors.recoverWhite,
                                ),
                                TextButton(
                                  onPressed: () {
                                    navigateTo(
                                        context,
                                        LoginScreen(
                                          isPatient: true,
                                        ));
                                  },
                                  child: RecoverHints(
                                      hint: 'Sign in',
                                      color: RecoverColors.myColor),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
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
