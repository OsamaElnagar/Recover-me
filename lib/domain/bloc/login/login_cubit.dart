import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../presentation/components/components.dart';
import '../../../data/data_sources/consts.dart';
import '../../../data/models/doctor_login_model.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  IconData visible = Icons.visibility;
  bool isShown = true;
  DoctorLoginModel? demoLoginModel;

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
        .then((value) {
      emit(LoginSuccessState(value.user!.uid));
      if (isPatient == true) {
        FirebaseFirestore.instance
            .collection('patients')
            .doc(value.user!.uid)
            .get()
            .then((value) {})
            .catchError((error) {

        });
      }
      if (isPatient == false) {
        FirebaseFirestore.instance
            .collection('doctors')
            .doc(value.user!.uid)
            .get()
            .then((value) {})
            .catchError((error) {

        });
      }
    }).catchError((onError) {
      pint(onError.toString());
      emit(LoginErrorState(onError.toString()));
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? finishGoogleUser =
        await GoogleSignIn().signOut().then((value) {
      emit(LoginLoadingState());
    }).catchError((onError) {
      emit(LoginErrorState(onError.toString()));
    });
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
    final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
    final user = authResult.user;
    emit(LoginSuccessState(user!.uid.toString()));
    return authResult;
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


