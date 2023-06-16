import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recover_me/data/models/patient_login_model.dart';
import '../../../presentation/components/components.dart';
import '../../../data/data_sources/consts.dart';

part 'patient_register_state.dart';

class PatientRegisterCubit extends Cubit<PRegisterStates> {
  PatientRegisterCubit() : super(PRegisterInitialState());

  static PatientRegisterCubit get(context) => BlocProvider.of(context);
  IconData visible = Icons.visibility;
  bool isShown = true;
  File? profileImageFile;
  ImagePicker picker = ImagePicker();
  List<String> injures = [
    'Mental Health Patients',
    'Physical Therapy Patients',
    'Elderly Patients',
    'General Health Patients',
    'Traumatic brain injury',
    'Stroke',
    'Spinal cord injury',
    'Cerebral palsy (in children)',
    'Neurological disorders',
    'Multiple sclerosis',
  ];
  PatientLoginModel? pLoginModel;
  PatientLoginModel? demoLoginModel;

  String dropdownValue = 'General Health Patients';

  String dropdownSelection(value) {
    dropdownValue = value;
    emit(PRegisterDropdownSelectionState());
    return dropdownValue;
  }

  void changePasswordVisibility() {
    isShown = !isShown;
    visible = isShown ? Icons.visibility : Icons.visibility_off_sharp;

    emit(ChangePasswordVisibilityState());
  }



  void registerPatient({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) {
    emit(PRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) async {
          uId = value.user!.uid;
      //var receiverFCMToken = await FirebaseMessaging.instance.getToken();
      createUser(
          name: name,
          phone: phone,
          email: email,
          uId: value.user!.uid,
          receiverFCMToken: 'receiverFCMToken');
    }).catchError((onError) {
      pint(onError.toString());
      emit(PRegisterErrorState(onError.toString()));
    });
  }

  void createUser({
    required String name,
    required String phone,
    required String email,
    String? uId,
    String? receiverFCMToken,
  }) {
    emit(PRegisterLoadingState());
    pLoginModel = PatientLoginModel(
        name: name,
        phone: phone,
        email: email,
        bio: 'Write your bio',
        uId: uId!,
        receiverFCMToken: receiverFCMToken!,
        profileImage:defaultPatPhoto,
        profileCover:
            'https://firebasestorage.googleapis.com/v0/b/social-app-201c9.appspot.com'
            '/o/newUserCoverImage.png?alt=media&token=4f00e83a-629b-4b27-abb5-73a1ec54d4ab');
    FirebaseFirestore.instance
        .collection('patients')
        .doc(uId)
        .set(pLoginModel!.toMap())
        .then((value) {
      emit(PRegisterCreateUserSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(PRegisterCreateUserErrorState(onError));
    });
  }
  Future<UserCredential> signInWithGoogle() async {
    emit(PRegisterWithGoogleLoadingState());
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
    final UserCredential authResult =
    await FirebaseAuth.instance.signInWithCredential(credential);
    final user = authResult.user;

    Map<String, dynamic> json = {
      'name': user!.displayName.toString(),
      'email': user.email.toString(),
      'phone': user.phoneNumber.toString(),
      'profileImage': user.photoURL.toString(),
      'uId': user.uid.toString(),
    };

    demoLoginModel = PatientLoginModel.fromJson(json);
    FirebaseFirestore.instance
        .collection('patients')
        .doc(user.uid.toString())
        .set(demoLoginModel!.toMap())
        .then((value) {
      emit(PRegisterWithGoogleSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(PRegisterWithGoogleErrorState(onError.toString()));
    });
    return authResult;
  }


  void getGalleryProfileImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImageFile = File(pickedFile.path);

      emit(PRegisterGetGalleryImageSuccessState());
    } else {
      pint('No Image selected');
      emit(PRegisterGetGalleryImageErrorState());
    }
  }

  void getCameraProfileImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      profileImageFile = File(pickedFile.path);
      emit(PRegisterGetCameraImageSuccessState());
    } else {
      pint('No Image selected');
      emit(PRegisterGetCameraImageErrorState());
    }
  }

  String compressedImagePath = "/storage/emulated/0/Download/";

  Future compressImage({required originalImage}) async {
    if (originalImage == null) return null;
    if (kDebugMode) {
      print('${await originalImage!.length()}' ' before');
    }
    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      originalImage!.path,
      "$compressedImagePath/file1.jpg",
      quality: 10,
    );
    if (compressedFile != null) {
      originalImage = compressedFile;
      if (kDebugMode) {
        print('${await originalImage!.length()}' ' after');
      }
    }
    emit(CompressImageState());
  }
  void updateOnlyProfileImage() {
    emit(PRegisterUpdateOnlyProfileImageLoadingState());

    compressImage(originalImage: profileImageFile).then((value) =>

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'profileImages/patients/$uId/${Uri.file(profileImageFile!.path).pathSegments.last}')
        .putFile(profileImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        FirebaseFirestore.instance
            .collection('patients')
            .doc(pLoginModel!.uId)
            .update({'profileImage': value});
      }).catchError((onError) {});
      emit(PRegisterUpdateOnlyProfileImageSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(PRegisterUpdateOnlyProfileImageErrorState(onError.toString()));
    }));
  }

  void updatePatientDisability({required String disability}) {
    emit(PRegisterUpdateDisabilityLoadingState());
    FirebaseFirestore.instance
        .collection('patients')
        .doc(uId)
        .update({'disability': disability}).then((value) {
      // I will get it first and store it in an object of PLModel then update it with the new prof.
      emit(PRegisterUpdateDisabilitySuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(PRegisterUpdateDisabilityErrorState(onError.toString()));
    });
  }

// void updateProfileCover({
//   required String name,
//   required String phone,
//   required String email,
//   required String bio,
// }) {
//   emit(AppUpdateCoverImageLoadingState());
//   firebase_storage.FirebaseStorage.instance
//       .ref()
//       .child(
//       'coverImages/${Uri.file(coverImageFile!.path).pathSegments.last}')
//       .putFile(coverImageFile!)
//       .then((value) {
//     value.ref.getPownloadURL().then((value) {
//       updateProfile(
//         name: name,
//         phone: phone,
//         email: email,
//         bio: bio,
//         profileCover: value,
//       );
//     }).catchError((onError) {});
//     emit(AppUpdateCoverImageSuccessState());
//   }).catchError((onError) {
//     pint(onError.toString());
//     emit(AppUpdateCoverImageErrorState(onError.toString()));
//   });
// }

  void updateProfile({
    required String name,
    required String phone,
    required String email,
    required String bio,
    String? profileImage,
    String? profileCover,
  }) async {
    emit(PRegisterUpdateProfileLoadingState());
    PatientLoginModel newPatientLoginModel = PatientLoginModel(
        name: name,
        phone: phone,
        email: email,
        bio: bio,
        profileImage: profileImage ?? pLoginModel!.profileImage,
        profileCover: profileCover ?? pLoginModel!.profileCover,
        uId: pLoginModel!.uId,
        receiverFCMToken: pLoginModel!.receiverFCMToken);
    await FirebaseFirestore.instance
        .collection('patients')
        .doc(pLoginModel!.uId)
        .update(newPatientLoginModel.toMap())
        .then((value) {
      emit(PRegisterUpdateProfileSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(PRegisterUpdateProfileErrorState(onError.toString()));
    });
  }



}
