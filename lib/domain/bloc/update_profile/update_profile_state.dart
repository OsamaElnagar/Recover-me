part of 'update_profile_cubit.dart';

@immutable
abstract class UpdateProfileStates {}

class UpdateProfileInitialState extends UpdateProfileStates {}

class UpdateProfileLoadingState extends UpdateProfileStates {}

class UpdateProfileSuccessState extends UpdateProfileStates {}

class UpdateProfileErrorState extends UpdateProfileStates {
  final String error;

  UpdateProfileErrorState(this.error);
}

class UpdateGetGalleryImageSuccessState extends UpdateProfileStates {}

class UpdateGetGalleryImageErrorState extends UpdateProfileStates {}

class UpdateGetCameraImageSuccessState extends UpdateProfileStates {}

class UpdateGetCameraImageErrorState extends UpdateProfileStates {}

class UpdateOnlyProfileImageLoadingState extends UpdateProfileStates {}

class UpdateOnlyProfileImageSuccessState extends UpdateProfileStates {}

class UpdateOnlyProfileImageErrorState extends UpdateProfileStates {
  final String error;

  UpdateOnlyProfileImageErrorState(this.error);
}

class UpdateGetModelLoadingState extends UpdateProfileStates {}


class UpdateGetModelSuccessState extends UpdateProfileStates {}

class UpdateGetModelErrorState extends UpdateProfileStates {
  final String error;

  UpdateGetModelErrorState(this.error);
}
class CompressImageState extends UpdateProfileStates {}


class UpdateSignOutLoadingState extends UpdateProfileStates {}


class UpdateSignOutSuccessState extends UpdateProfileStates {}

class UpdateSignOutErrorState extends UpdateProfileStates {
  final String error;

  UpdateSignOutErrorState(this.error);
}

class DeleteAccountLoadingState extends UpdateProfileStates {}


class DeleteAccountSuccessState extends UpdateProfileStates {}

class DeleteAccountErrorState extends UpdateProfileStates {
  final String error;

  DeleteAccountErrorState(this.error);
}
