import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recover_me/data/models/patient_login_model.dart';
import '../../../presentation/components/components.dart';
import '../../../data/data_sources/consts.dart';
import '../../../data/models/doctor_login_model.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  IconData visible = Icons.visibility;
  bool isShown = true;
  DoctorLoginModel? docLoginModel;
  PatientLoginModel? patLoginModel;

  void changePasswordVisibility() {
    isShown = !isShown;
    visible = isShown ? Icons.visibility : Icons.visibility_off_sharp;

    emit(ChangePasswordVisibilityState());
  }

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((credentials) {
      if (isPatient == true) {
        FirebaseFirestore.instance
            .collection('patients')
            .doc(credentials.user!.uid)
            .get()
            .then((value) {
          patLoginModel = PatientLoginModel.fromJson(value.data()!);
          //emit(LoginGetDataSuccessState());
          emit(LoginSuccessState(credentials.user!.uid));
        }).catchError((error) {
          pint(error.toString());
        });
      }
      if (isPatient == false) {
        FirebaseFirestore.instance
            .collection('doctors')
            .doc(credentials.user!.uid)
            .get()
            .then((value) {
          docLoginModel = DoctorLoginModel.fromJson(value.data()!);
          emit(LoginSuccessState(credentials.user!.uid));
          // emit(LoginGetDataSuccessState());
        }).catchError((error) {
          pint(error.toString());
        });
      }
    }).catchError((onError) {
      pint(onError.toString());
      emit(LoginErrorState(onError.toString()));
    });
  }

  void signInWithGoogle() async {
    // final GoogleSignInAccount? finishGoogleUser =
    //     await GoogleSignIn().signOut().then((value) {
    //   emit(LoginLoadingState());
    // }).catchError((onError) {
    //   emit(LoginErrorState(onError.toString()));
    // });
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential

    await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((credentials) {
      if (isPatient == true) {
        FirebaseFirestore.instance
            .collection('patients')
            .doc(credentials.user!.uid.toString())
            .get()
            .then((value) {
          patLoginModel = PatientLoginModel.fromJson(value.data()!);
          //emit(LoginGetDataSuccessState());
          emit(LoginSuccessState(credentials.user!.uid.toString()));
        }).catchError((error) {
          pint(error.toString());
        });
      }
      if (isPatient == false) {
        FirebaseFirestore.instance
            .collection('doctors')
            .doc(credentials.user!.uid.toString())
            .get()
            .then((value) {
          docLoginModel = DoctorLoginModel.fromJson(value.data()!);
          emit(LoginSuccessState(credentials.user!.uid.toString()));
          // emit(LoginGetDataSuccessState());
        }).catchError((error) {
          pint(error.toString());
        });
      }
    }).catchError((e) {});
  }

  void resetPassword({required String email, context}) {
    emit(LoginResetPasswordLoadingState());
    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('we sent you an email, please check your email!'),
        ),
      );
      emit(LoginResetPasswordSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(LoginResetPasswordErrorState(onError.toString()));
    });
  }
}
