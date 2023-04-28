part of 'doctor_register_cubit.dart';

@immutable
abstract class DRegisterStates {}

class DRegisterInitialState extends DRegisterStates {}

class ChangePasswordVisibilityState extends DRegisterStates {}

class DRegisterLoadingState extends DRegisterStates {}

class DRegisterErrorState extends DRegisterStates {
  final String errorMessage;

  DRegisterErrorState(this.errorMessage);
}

class DRegisterCreateUserSuccessState extends DRegisterStates {}

class DRegisterCreateUserErrorState extends DRegisterStates {
  final String errorMessage;

  DRegisterCreateUserErrorState(this.errorMessage);
}
////////////////////////////////////////////////////////////////////////
class DRegisterGetGalleryImageSuccessState extends DRegisterStates {}

class DRegisterGetGalleryImageErrorState extends DRegisterStates {}

class DRegisterGetCameraImageSuccessState extends DRegisterStates {}

class DRegisterGetCameraImageErrorState extends DRegisterStates {}
////////
class DRegisterDropdownSelectionState extends DRegisterStates {}

////////////////////////////////////////////////////////////////
class DRegisterUpdateOnlyProfileImageLoadingState extends DRegisterStates {}

class DRegisterUpdateOnlyProfileImageSuccessState extends DRegisterStates {}

class DRegisterUpdateOnlyProfileImageErrorState extends DRegisterStates {
  final String errorMessage;

  DRegisterUpdateOnlyProfileImageErrorState(this.errorMessage);
}

////////////////////////////////////////////////////////////////
class DRegisterUpdateProfileLoadingState extends DRegisterStates {}

class DRegisterUpdateProfileSuccessState extends DRegisterStates {}

class DRegisterUpdateProfileErrorState extends DRegisterStates {
  final String errorMessage;

  DRegisterUpdateProfileErrorState(this.errorMessage);
}

////////////////////////////////////////////////////////////////
class DRegisterUpdateProfLoadingState extends DRegisterStates {}


class DRegisterUpdateProfSuccessState extends DRegisterStates {}

class DRegisterUpdateProfErrorState extends DRegisterStates {
  final String errorMessage;

  DRegisterUpdateProfErrorState(this.errorMessage);
}

class DRegisterWithGoogleLoadingState extends DRegisterStates {}

class DRegisterWithGoogleSuccessState extends DRegisterStates {}
class DRegisterWithGoogleErrorState extends DRegisterStates {
  final String errorMessage;

  DRegisterWithGoogleErrorState(this.errorMessage);
}
class CompressImageState extends DRegisterStates {}