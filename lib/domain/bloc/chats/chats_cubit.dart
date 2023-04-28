import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recover_me/data/models/doctor_login_model.dart';
import '../../../RecoverMe/presentation/components/components.dart';
import '../../../data/models/chatModel.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsStates> {
  ChatsCubit(ChatsStates initialState) : super(ChatsInitialState());

  static ChatsCubit get(context) => BlocProvider.of(context);

  DoctorLoginModel? loginModel;

  File? profileImageFile;

  File? messageImageFile;

  bool wannaSearchForUser = false;

  List<DoctorLoginModel> allUsers = [];
  ImagePicker picker = ImagePicker();

  List<ChatsModel> messages = [];
  Map<String, dynamic> user = {};

  // void wannaSearch(context) {
  //   wannaSearchForUser = !wannaSearchForUser;
  //   FocusScope.of(context).requestFocus(searchUserNode);
  //   emit(AppWannaSearchSuccessState());
  // }

  void getGalleryMessageImage() async {
    var pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      messageImageFile = File(pickedFile.path);

      emit(ChatsGetGalleryImageSuccessState());
    } else {
      pint('No Image selected');
      emit(ChatsGetGalleryImageErrorState());
    }
  }

  void getCameraMessageImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      messageImageFile = File(pickedFile.path);
      emit(ChatsGetCameraImageSuccessState());
    } else {
      pint('No Image selected');
      emit(ChatsGetCameraImageErrorState());
    }
  }

  void undoGetMessageImage() {
    messageImageFile = null;
    emit(ChatsUndoGetMessageImageSuccessState());
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
    emit(ChatsCompressImageState());
  }

  //********************

  void senMessage({
    required String receiverId,
    required String textMessage,
    String? imageMessage,
    required String messageDateTime,
  }) {
    emit(ChatsSendMessageLoadingState());
    ChatsModel chatsModel = ChatsModel(
      chatPersonName: loginModel!.name!,
      senderId: loginModel!.uId!,
      receiverId: receiverId,
      textMessage: textMessage,
      imageMessage: imageMessage ?? '',
      messageDateTime: messageDateTime,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(loginModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(chatsModel.toMap())
        .then((value) {
      emit(ChatsSendMessageSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(ChatsSendMessageErrorState(onError.toString()));
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(loginModel!.uId)
        .collection('messages')
        .add(chatsModel.toMap())
        .then((value) {
      undoGetMessageImage();
      emit(ChatsSendMessageSuccessState());
    }).catchError((onError) {
      pint(onError.toString());
      emit(ChatsSendMessageErrorState(onError.toString()));
    });
  }

  void sendMessageWithImage({
    required String receiverId,
    required String textMessage,
    required String messageDateTime,
  }) {
    emit(ChatsSendMessageWithImageLoadingState());
    compressImage(originalImage: messageImageFile);
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'users/${loginModel!.uId}/Chats/$receiverId/Messages/${Uri.file(messageImageFile!.path).pathSegments.last}')
        .putFile(messageImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        senMessage(
          receiverId: receiverId,
          textMessage: textMessage,
          messageDateTime: messageDateTime,
          imageMessage: value,
        );
        emit(ChatsSendMessageWithImageSuccessState());
      }).catchError((onError) {
        pint(onError.toString());
        emit(ChatsSendMessageWithImageErrorState(onError.toString()));
      });
    }).catchError((onError) {
      pint(onError.toString());
      emit(ChatsSendMessageWithImageErrorState(onError.toString()));
    });
  }

  void getMessages({required String receiverId}) {
    emit(ChatsGetMessageLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(loginModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('messageDateTime')
        .snapshots()
        .listen((event) {
      messages.clear();
      for (var element in event.docs) {
        messages.add(ChatsModel.fromJson(element.data()));
      }
      emit(ChatsGetMessageSuccessState());
    });
  }
}
