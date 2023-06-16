import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recover_me/data/data_sources/consts.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:recover_me/domain/entities/cache_helper.dart';
import '../../../presentation/components/components.dart';
import '../../../presentation/pages/home/user_type.dart';
import '../../../data/models/doctor_login_model.dart';
import '../../../data/models/patient_login_model.dart';

part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileStates> {
  UpdateProfileCubit() : super(UpdateProfileInitialState());

  static UpdateProfileCubit get(context) => BlocProvider.of(context);

  DoctorLoginModel? doctorLoginModel;
  PatientLoginModel? patientLoginModel;
  File? profileImageFile;
  ImagePicker picker = ImagePicker();

  void logout(context) async {
    emit(UpdateSignOutLoadingState());
    await FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.removeData(key: 'uid');
      CacheHelper.removeData(key: 'isPatient');
      navigate2(context, const UserType());
      emit(UpdateSignOutSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(UpdateSignOutErrorState(onError.toString()));
    });
  }

  void deletePatientAccount(context) {
    emit(DeleteAccountLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('profileImages/patients/$uId')
        .delete()
        .then((value) {
      FirebaseFirestore.instance
          .collection('patients')
          .doc(uId)
          .delete()
          .then((value) {})
          .catchError((onError) {
        pint(onError.toString());

        emit(DeleteAccountErrorState(onError.toString()));
      });
      CacheHelper.removeData(key: 'uid');
      CacheHelper.removeData(key: 'isPatient');
      FirebaseAuth.instance.currentUser!.delete();
      navigate2(context, const UserType());
      emit(DeleteAccountSuccessState());
    }).catchError((e) {
      pint(e.toString());
    });
  }

  void deleteDoctorAccount(context) {
    emit(DeleteAccountLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('profileImages/doctors/$uId')
        .delete();
    FirebaseFirestore.instance
        .collection('doctors')
        .doc(uId)
        .delete()
        .then((value) {
      navigate2(context, const UserType());
      emit(DeleteAccountSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(DeleteAccountErrorState(onError.toString()));
    });
    CacheHelper.removeData(key: 'uid');
    CacheHelper.removeData(key: 'isPatient');
    FirebaseAuth.instance.currentUser!.delete();
  }

  Future getPatientModel() async {
    emit(UpdateGetModelLoadingState());
    await FirebaseFirestore.instance
        .collection('patients')
        .doc(uId)
        .get()
        .then((value) {
      patientLoginModel = PatientLoginModel.fromJson(value.data()!);
      pint(patientLoginModel!.name.toString());
      pint(patientLoginModel!.profileImage.toString());
      emit(UpdateGetModelSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(UpdateGetModelErrorState(onError.toString()));
    });
  }

  Future getDoctorModel() async {
    emit(UpdateGetModelLoadingState());
    await FirebaseFirestore.instance
        .collection('doctors')
        .doc(uId)
        .get()
        .then((value) {
      doctorLoginModel = DoctorLoginModel.fromJson(value.data()!);
      pint(doctorLoginModel!.name.toString());
      pint(doctorLoginModel!.profileImage.toString());
      emit(UpdateGetModelSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(UpdateGetModelErrorState(onError.toString()));
    });
  }

  void updatePatientProfile({
    String? name,
    email,
    phone,
  }) {
    emit(UpdateProfileLoadingState());
    FirebaseFirestore.instance.collection('patients').doc(uId).update({
      'name': name ?? patientLoginModel!.name,
      'email': email ?? patientLoginModel!.email,
      'phone': phone ?? patientLoginModel!.phone,
    }).then((value) {
      emit(UpdateProfileSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(UpdateProfileErrorState(onError.toString()));
    });
  }

  void updateDoctorProfile({
    String? name,
    email,
    phone,
  }) {
    emit(UpdateProfileLoadingState());
    FirebaseFirestore.instance.collection('doctors').doc(uId).update({
      'name': name ?? doctorLoginModel!.name,
      'email': email ?? doctorLoginModel!.email,
      'phone': phone ?? doctorLoginModel!.phone,
    }).then((value) {
      emit(UpdateProfileSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(UpdateProfileErrorState(onError.toString()));
    });
  }

  void getGalleryProfileImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImageFile = File(pickedFile.path);

      emit(UpdateGetGalleryImageSuccessState());
    } else {
      pint('No Image selected');
      emit(UpdateGetGalleryImageErrorState());
    }
  }

  void getCameraProfileImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      profileImageFile = File(pickedFile.path);
      emit(UpdateGetCameraImageSuccessState());
    } else {
      pint('No Image selected');
      emit(UpdateGetCameraImageErrorState());
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

  void updateOnlyPaProfileImage() {
    emit(UpdateOnlyProfileImageLoadingState());

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
                .doc(patientLoginModel!.uId)
                .update({'profileImage': value});
          }).catchError((onError) {});
          emit(UpdateOnlyProfileImageSuccessState());
        }).catchError((onError) {
          pint(onError.toString());
          emit(UpdateOnlyProfileImageErrorState(onError.toString()));
        }));
  }

  void updateOnlyDoProfileImage() {
    emit(UpdateOnlyProfileImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'profileImages/doctors/$uId/${Uri.file(profileImageFile!.path).pathSegments.last}')
        .putFile(profileImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        FirebaseFirestore.instance
            .collection('doctors')
            .doc(doctorLoginModel!.uId)
            .update({'profileImage': value});
      }).catchError((onError) {});
      emit(UpdateOnlyProfileImageSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(UpdateOnlyProfileImageErrorState(onError.toString()));
    });
  }
}
