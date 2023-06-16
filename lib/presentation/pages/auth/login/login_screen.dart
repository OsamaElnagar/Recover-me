import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recover_me/presentation/pages/home/doctor/doctor_professsion_screen.dart';
import 'package:recover_me/presentation/pages/home/patient/patient_prefs_screen.dart';
import 'package:recover_me/presentation/pages/home/user_type.dart';
import 'package:recover_me/presentation/widgets/glassy.dart';
import 'package:recover_me/presentation/widgets/my_background_designs.dart';
import 'package:recover_me/presentation/widgets/recover_text_button.dart';
import 'package:recover_me/data/styles/colors.dart';
import 'package:recover_me/data/styles/form_fields.dart';
import 'package:recover_me/data/styles/paddings.dart';
import 'package:recover_me/data/styles/texts.dart';
import 'package:recover_me/domain/bloc/login/login_cubit.dart';
import 'package:recover_me/domain/bloc/recover/recover_cubit.dart';
import '../../../../../data/data_sources/consts.dart';
import '../../../../../domain/entities/cache_helper.dart';
import '../../../components/components.dart';

class LoginScreen extends StatelessWidget {
  bool? isPatient;

  LoginScreen({super.key, this.isPatient});

  TextEditingController emailController = TextEditingController();

  TextEditingController passController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  FocusNode emailNode = FocusNode();

  FocusNode passNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            CacheHelper.saveData(key: 'uid', value: state.uId);
            uId = CacheHelper.getData('uid');

            if (isPatient == true) {
              RecoverCubit.get(context).getPatientData();
              navigate2(
                  context,
                  PatientPrefsScreen(
                    oldUser: true,
                    patLoginModel: LoginCubit.get(context).patLoginModel,
                  ));
            } else {
              RecoverCubit.get(context).getDoctorData();
              navigate2(
                  context,
                  DocProfAndImage(
                    oldUser: true,
                    docLoginModel: LoginCubit.get(context).docLoginModel,
                  ));
            }
            showToast(msg: 'login successfully', state: ToastStates.success);
          }
          if (state is LoginErrorState) {
            showToast(msg: 'Wrong email or password', state: ToastStates.error);
          }
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: typeBackground(
                  context: context,
                  asset: 'assets/images/login-background.jpg',
                  child: RecoverPaddings.recoverAuthPadding(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: screenHeight * .1,
                          ),
                          glassyContainer(
                            child: RecoverHeadlines(
                              headline: 'Login your account',
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * .01,
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
                          SizedBox(
                            height: screenHeight * .001,
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
                            loginCubit: cubit,
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
                          SizedBox(
                            height: screenHeight * .001,
                          ),
                          // create a new account
                          Center(
                            child: recoverTextButton(
                              text: 'Login',
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  LoginCubit.get(context).userLogin(
                                    email: emailController.text
                                        .replaceAll(' ', '')
                                        .toString(),
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
                          if (state is LoginLoadingState)
                            const LinearProgressIndicator(
                              color: RecoverColors.myColor,
                            ),
                          SizedBox(
                            height: screenHeight * .001,
                          ),
                          // Sign up with google
                          Center(
                            child: GestureDetector(
                              onTap: () {
                              //  cubit.signInWithGoogle();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width * .7,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2, color: RecoverColors.myColor),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 15,
                                      backgroundImage: AssetImage(
                                          'assets/images/google.jpg'),
                                    ),
                                    RecoverNormalTexts(
                                      norText: 'Sign in with Google',
                                      color: RecoverColors.myColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * .001,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RecoverHints(
                                hint: 'Do not have an account',
                                color: Colors.white,
                              ),
                              TextButton(
                                onPressed: () {
                                  navigateTo(context, const UserType());
                                },
                                child: RecoverHints(
                                    hint: 'Sign up',
                                    color: RecoverColors.myColor),
                              ),
                            ],
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
