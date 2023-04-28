part of 'chats_cubit.dart';

@immutable
abstract class ChatsStates {}

class ChatsInitialState extends ChatsStates {}

class ChatsGetGalleryImageSuccessState extends ChatsStates {}

class ChatsGetGalleryImageErrorState extends ChatsStates {}

class ChatsGetCameraImageSuccessState extends ChatsStates {}

class ChatsGetCameraImageErrorState extends ChatsStates {}

class ChatsUndoGetMessageImageSuccessState extends ChatsStates {}

class ChatsCompressImageState extends ChatsStates {}

class ChatsSendMessageLoadingState extends ChatsStates {}

class ChatsSendMessageSuccessState extends ChatsStates {}

class ChatsSendMessageErrorState extends ChatsStates {
  final String error;

  ChatsSendMessageErrorState(this.error);
}

class ChatsSendMessageWithImageLoadingState extends ChatsStates {}

class ChatsSendMessageWithImageSuccessState extends ChatsStates {}

class ChatsSendMessageWithImageErrorState extends ChatsStates {
  final String error;

  ChatsSendMessageWithImageErrorState(this.error);
}

class ChatsGetMessageLoadingState extends ChatsStates {}

class ChatsGetMessageSuccessState extends ChatsStates {}

class ChatsGetMessageErrorState extends ChatsStates {
  final String error;

  ChatsGetMessageErrorState(this.error);
}
