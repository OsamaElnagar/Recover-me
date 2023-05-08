import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recover_me/data/models/doctor_login_model.dart';
import '../../../presentation/components/components.dart';
import '../../../data/data_sources/consts.dart';
import '../../../data/models/boardingModel.dart';
import '../../../data/models/game_model.dart';
import '../../../data/models/patient_login_model.dart';
import '../../entities/cache_helper.dart';
import 'dart:developer' as developer;
import 'dart:ui' as ui;

part 'recover_state.dart';

class RecoverCubit extends Cubit<RecoverState> {
  RecoverCubit(RecoverState initialState) : super(RecoverInitial());

  static RecoverCubit get(context) => BlocProvider.of(context);

  List<BoardingModel> boarding = [
    BoardingModel(
      body: 'Empowering your journey to recovery, One Step at a time',
      image: 'assets/images/recover_me_logo.jpg',
    ),
    BoardingModel(
      body:
          'Recover Me offers an engaging and immersive rehabilitation experience, allowing you to recover from injuries or illnesses more quickly and conveniently.'
          '\n Try it out today and discover the incredible benefits of VR gaming in rehabilitation',
      image: 'assets/images/avr.jpg',
    ),
    BoardingModel(
      body:
          'Experience the Future of Rehabilitation with Recover Me! the power of Virtual Reality gaming',
      image: 'assets/images/games.jpg',
    ),
  ];
  DoctorLoginModel? doctorLoginModel;
  PatientLoginModel? patientLoginModel;
  List<PatientLoginModel> patients = [];
  List<GameModel> games = [];

  void endBoarding(context) {
    CacheHelper.putData('lastPage', lastPage!).then((value) {
      if (value) {
        //navigate2(context, const LoginScreen());
      }
    }).catchError((onError) {});
  }

  void getDoctorData() {
    emit(RecoverGetDocDataLoadingState());
    FirebaseFirestore.instance
        .collection('doctors')
        .doc(uId)
        .get()
        .then((value) {
      doctorLoginModel = DoctorLoginModel.fromJson(value.data()!);
      pint(doctorLoginModel!.name.toString());
      pint(doctorLoginModel!.profileImage.toString());
      emit(RecoverGetDocDataSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(RecoverGetDocDataErrorState(onError.toString()));
    });
  }

  void getGames() {
    emit(RecoverGetGamesLoadingState());

    FirebaseFirestore.instance
        .collection('unityGames')
        .limit(6)
        .orderBy('name')
        .get()
        .then((value) {
      for (var game in value.docs) {
        games.add(GameModel.fromMap(game.data()));
      }
      emit(RecoverGetGamesSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(RecoverGetGamesErrorState(onError.toString()));
    });
  }

  void getPatients() {
    emit(RecoverGetPatientsLoadingState());
    patients.clear();
    FirebaseFirestore.instance.collection('patients').get().then((value) {
      for (var patient in value.docs) {
        patients.add(PatientLoginModel.fromJson(patient.data()));
      }
      emit(RecoverGetPatientsSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(RecoverGetPatientsErrorState(onError.toString()));
    });
  }

  void getPatientData() {
    emit(RecoverGetPatientDataLoadingState());
    FirebaseFirestore.instance
        .collection('patients')
        .doc(uId)
        .get()
        .then((value) {
      patientLoginModel = PatientLoginModel.fromJson(value.data()!);
      pint(patientLoginModel!.name.toString());
      emit(RecoverGetPatientDataSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(RecoverGetPatientDataErrorState(onError.toString()));
    });
  }
}
