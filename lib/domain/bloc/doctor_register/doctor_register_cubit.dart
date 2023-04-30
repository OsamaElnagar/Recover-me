import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recover_me/data/data_sources/consts.dart';
import '../../../RecoverMe/presentation/components/components.dart';
import '../../../data/models/doctor_login_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:google_sign_in/google_sign_in.dart';

part 'doctor_register_state.dart';

class DoctorRegisterCubit extends Cubit<DRegisterStates> {
  DoctorRegisterCubit() : super(DRegisterInitialState());

  static DoctorRegisterCubit get(context) => BlocProvider.of(context);

  IconData visible = Icons.visibility;
  bool isShown = true;
  File? profileImageFile;
  ImagePicker picker = ImagePicker();
  DoctorLoginModel? dLoginModel;
  DoctorLoginModel? demoLoginModel;
  List<String> trainings = [
    'Hand therapy',
    'Hand surgery',
    'Physiotherapy/ Kinesiology',
    'Occupational therapy',
    'Rehabilitation / Physiatry',
    'Traumatology and Orthopedics',
    'Innovation',
    'Student',
  ];
  String? dropdownValue;

  String? dropdownSelection(value) {
    dropdownValue = value;
    emit(DRegisterDropdownSelectionState());
    return dropdownValue;
  }

  void changePasswordVisibility() {
    isShown = !isShown;
    visible = isShown ? Icons.visibility : Icons.visibility_off_sharp;

    emit(ChangePasswordVisibilityState());
  }

  void registerDoctor({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) {
    emit(DRegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) async {
          uId = value.user!.uid;
      var receiverFCMToken = await FirebaseMessaging.instance.getToken();
      createUserInFireStore(
        name: name,
        phone: phone,
        email: email,
        uId: value.user!.uid,
        receiverFCMToken: receiverFCMToken,
      );
    }).catchError((onError) {
      pint(onError.toString());
      emit(DRegisterErrorState(onError.toString()));
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    emit(DRegisterWithGoogleLoadingState());
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

    demoLoginModel = DoctorLoginModel.fromJson(json);
    FirebaseFirestore.instance
        .collection('doctors')
        .doc(user.uid.toString())
        .set(demoLoginModel!.toMap())
        .then((value) {
      emit(DRegisterWithGoogleSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(DRegisterWithGoogleErrorState(onError.toString()));
    });
    return authResult;
  }

  void createUserInFireStore({
    required String name,
    required String phone,
    required String email,
    String? uId,
    String? receiverFCMToken,
  }) {
    emit(DRegisterLoadingState());
    dLoginModel = DoctorLoginModel(
        name: name,
        phone: phone,
        email: email,
        bio: 'Write your bio',
        uId: uId!,
        receiverFCMToken: receiverFCMToken!,
        profileImage:
            'https://firebasestorage.googleapis.com/v0/b/recoverme-a017c.appspot.com/o/'
            'app%20assets%2Fdoctor_avatar.jpg?alt=media&token=6d50122e-f459-4e85-adad-7d734fe2f3e8',
        profileCover:
            'https://firebasestorage.googleapis.com/v0/b/social-app-201c9.appspot.com/o/'
            'newUserCoverImage.png?alt=media&token=4f00e83a-629b-4b27-abb5-73a1ec54d4ab');
    FirebaseFirestore.instance
        .collection('doctors')
        .doc(uId)
        .set(dLoginModel!.toMap())
        .then((value) {
      emit(DRegisterCreateUserSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(DRegisterCreateUserErrorState(onError.toString()));
    });
  }

  void getGalleryProfileImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImageFile = File(pickedFile.path);

      emit(DRegisterGetGalleryImageSuccessState());
    } else {
      pint('No Image selected');
      emit(DRegisterGetGalleryImageErrorState());
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
  void getCameraProfileImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      profileImageFile = File(pickedFile.path);
      emit(DRegisterGetCameraImageSuccessState());
    } else {
      pint('No Image selected');
      emit(DRegisterGetCameraImageErrorState());
    }
  }

  void updateOnlyProfileImage() async {
    emit(DRegisterUpdateOnlyProfileImageLoadingState());
    await compressImage(originalImage: profileImageFile).then((value) =>
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'profileImages/doctors/$uId/${Uri.file(profileImageFile!.path).pathSegments.last}')
        .putFile(profileImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        FirebaseFirestore.instance
            .collection('doctors')
            .doc(dLoginModel!.uId)
            .update({'profileImage': value});
      }).catchError((onError) {});
      emit(DRegisterUpdateOnlyProfileImageSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(DRegisterUpdateOnlyProfileImageErrorState(onError.toString()));
    }));
  }

  void updateDoctorProf({required String prof}) {
    emit(DRegisterUpdateProfLoadingState());
    FirebaseFirestore.instance
        .collection('doctors')
        .doc(uId)
        .update({'prof': prof}).then((value) {
      // I will get it first and store it in an object of DLModel then update it with the new prof.
      emit(DRegisterUpdateProfSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(DRegisterUpdateProfErrorState(onError.toString()));
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
//     value.ref.getDownloadURL().then((value) {
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
  }) {
    emit(DRegisterUpdateProfileLoadingState());
    DoctorLoginModel newDoctorLoginModel = DoctorLoginModel(
        name: name,
        phone: phone,
        email: email,
        bio: bio,
        profileImage: profileImage ?? dLoginModel!.profileImage,
        profileCover: profileCover ?? dLoginModel!.profileCover,
        uId: dLoginModel!.uId,
        receiverFCMToken: dLoginModel!.receiverFCMToken);
    FirebaseFirestore.instance
        .collection('doctors')
        .doc(dLoginModel!.uId)
        .update(newDoctorLoginModel.toMap())
        .then((value) {
      emit(DRegisterUpdateProfileSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(DRegisterUpdateProfileErrorState(onError.toString()));
    });
  }

}
