import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recover_me/data/models/doctor_login_model.dart';
import 'package:recover_me/data/styles/colors.dart';
import '../../../presentation/components/components.dart';
import '../../../data/data_sources/consts.dart';
import '../../../data/models/boardingModel.dart';
import '../../../data/models/game_model.dart';
import '../../../data/models/patient_login_model.dart';
import '../../entities/cache_helper.dart';

// import 'dart:developer' as developer;
// import 'dart:ui' as ui;

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
  List<DoctorLoginModel> doctors = [];
  List<GameModel> games = [];
  List<dynamic>? scores = [];
  Map<String, dynamic> mapData = {};

  bool isCritical = false;
  List<String> gamesName = [
    'Piano game',
    'Puzzle game',
    'Memory game (2D)',
    'Drag & Drop Game ',
    'Little Intelligence',
    'Hack & Slash (3D)',
  ];

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

  void getDoctors() {
    emit(RecoverGetDoctorsLoadingState());
    doctors.clear();
    FirebaseFirestore.instance.collection('doctors').get().then((value) {
      for (var doctor in value.docs) {
        doctors.add(DoctorLoginModel.fromJson(doctor.data()));
      }
      emit(RecoverGetDoctorsSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(RecoverGetDoctorsErrorState(onError.toString()));
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

  void useDefault({required String collection}) {
    FirebaseFirestore.instance.collection(collection).doc(uId).update({
      'profileImage':
          collection == 'patients' ? defaultPatPhoto : defaultDocPhoto
    }).then((value) {
      emit(UpdateUseDefaultState());
    }).catchError((e) {
      pint(e.toString());
    });
  }

  //
  // Future getScores({
  //   required String gameName,
  //   required PatientLoginModel pLModel,
  // }) async {
  //   emit(RecoverGetScoresLoadingState());
  //   scores!.clear();
  //
  //   await FirebaseFirestore.instance
  //       .collection('patients')
  //       .doc(pLModel.uId)
  //       .collection('scores')
  //       .doc(gameName)
  //       .get()
  //       .then(
  //     ((DocumentSnapshot<Map<String, dynamic>> snapshot) {
  //       if (snapshot.exists) {
  //         scores = snapshot.data()?['scores'];
  //
  //         pint('ffffffffffffffffffffffffffffffffffffffffffffffff');
  //         pint(scores!.toString());
  //       }
  //       emit(RecoverGetScoresSuccessState());
  //     }),
  //   ).catchError((e) {
  //     pint(e.toString());
  //     emit(RecoverGetScoresErrorState(e.toString()));
  //   });
  // }

  // Future updateScores({
  //   required String gameName,
  //   required PatientLoginModel pLModel,
  //   required double score,
  //   required BuildContext context,
  // }) async {
  //   emit(RecoverUpdateScoresLoadingState());
  //   final CollectionReference patientsCollection =
  //       FirebaseFirestore.instance.collection('patients');
  //   final DocumentReference patientDocument =
  //       patientsCollection.doc(pLModel.uId);
  //   final CollectionReference scoresCollection =
  //       patientDocument.collection('scores');
  //   final DocumentReference scoresDocument = scoresCollection.doc(gameName);
  //   List<dynamic> newScores = [score];
  //   await getScores(gameName: gameName, pLModel: pLModel).then((value) async {
  //     var a = await scoresDocument.get();
  //     if (a.exists) {
  //       if (scores != null) {
  //         if (scores!.last == newScores.last) {
  //           newScores.last = newScores.last + .01;
  //         }
  //         scores!.removeWhere((number) => newScores.contains(number));
  //         List<dynamic> updatedScores = scores!;
  //         updatedScores.addAll(newScores);
  //         scoresDocument.update({
  //           'scores': updatedScores,
  //         }).then((value) {
  //           isCritical = false;
  //           for (int i = 0; i < scores!.length - 2; i++) {
  //             int currentNumber = scores![i];
  //             int nextNumber = scores![i + 1];
  //             int thirdNumber = scores![i + 2];
  //
  //             if (currentNumber <= 5 && nextNumber <= 5 && thirdNumber <= 5) {
  //               isCritical = true;
  //             }
  //           }
  //           pint('done');
  //           emit(RecoverUpdateScoresSuccessState());
  //         }).catchError((onError) {
  //           pint(onError.toString());
  //           emit(RecoverUpdateScoresErrorState(onError.toString()));
  //         });
  //       }
  //     } else {
  //       scoresDocument.set({
  //         'scores': newScores,
  //       }).then((value) {
  //         pint('done');
  //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //           backgroundColor: RecoverColors.myColor,
  //           content: Text(
  //             'Hello, This Graph is ready to store scores',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //           duration: Duration(seconds: 5),
  //         ));
  //         emit(RecoverUpdateScoresSuccessState());
  //       }).catchError((onError) {
  //         pint(onError.toString());
  //         emit(RecoverUpdateScoresErrorState(onError.toString()));
  //       });
  //     }
  //   }).catchError((onError) {});
  // }

  Future getScoresMap({
    required String gameName,
    required PatientLoginModel pLModel,
  }) async {
    emit(RecoverGetScoresLoadingState());
    mapData.clear();
    await FirebaseFirestore.instance
        .collection('patients')
        .doc(pLModel.uId)
        .collection('scores')
        .doc(gameName)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic>? snapshotData = snapshot.data();
        if (snapshotData != null) {
          mapData = snapshotData['scores'];

          pint(mapData.toString());
        }
      }
      emit(RecoverGetScoresSuccessState());
    }).catchError((e) {
      pint(e.toString());
      emit(RecoverGetScoresErrorState(e.toString()));
    });
  }

  Future updateScoresMap({
    required String gameName,
    required PatientLoginModel pLModel,
    required Map score,
    required BuildContext context,
  }) async {
    emit(RecoverUpdateScoresLoadingState());
    final CollectionReference patientsCollection =
        FirebaseFirestore.instance.collection('patients');
    final DocumentReference patientDocument =
        patientsCollection.doc(pLModel.uId);
    final CollectionReference scoresCollection =
        patientDocument.collection('scores');
    final DocumentReference scoresDocument = scoresCollection.doc(gameName);
    Map newScores = score;
    await getScoresMap(gameName: gameName, pLModel: pLModel)
        .then((value) async {
      Map<String, dynamic> combinedMap = {...mapData, ...newScores};
      var a = await scoresDocument.get();
      if (a.exists) {
        scoresDocument.update({
          'scores': combinedMap,
        }).then((value) {
          mapData = combinedMap;
          pint('Updated successfully');
          emit(RecoverUpdateScoresSuccessState());
        }).catchError((onError) {
          pint(onError.toString());
          emit(RecoverUpdateScoresErrorState(onError.toString()));
        });
      } else {
        scoresDocument.set({
          'scores': newScores,
        }).then((value) {
          pint('Settled Successfully');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: RecoverColors.myColor,
            content: Text(
              'Hello, This Graph is ready to store scores',
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(seconds: 5),
          ));
          emit(RecoverUpdateScoresSuccessState());
        }).catchError((onError) {
          pint(onError.toString());
          emit(RecoverUpdateScoresErrorState(onError.toString()));
        });
      }
    }).catchError((onError) {});
  }
}
