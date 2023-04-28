part of 'patient_register_cubit.dart';

@immutable
abstract class PRegisterStates {}

class PRegisterInitialState extends PRegisterStates {}

class ChangePasswordVisibilityState extends PRegisterStates {}

class PRegisterLoadingState extends PRegisterStates {}

class PRegisterSuccessState extends PRegisterStates {}

class PRegisterErrorState extends PRegisterStates {
  final String error;

  PRegisterErrorState(this.error);
}

class PRegisterCreateUserSuccessState extends PRegisterStates {}

class PRegisterCreateUserErrorState extends PRegisterStates {
  final String error;

  PRegisterCreateUserErrorState(this.error);
}
////////////////////////////////////////////////////////////////////////
class PRegisterGetGalleryImageSuccessState extends PRegisterStates {}

class PRegisterGetGalleryImageErrorState extends PRegisterStates {}

class PRegisterGetCameraImageSuccessState extends PRegisterStates {}

class PRegisterGetCameraImageErrorState extends PRegisterStates {}
////////
class PRegisterDropdownSelectionState extends PRegisterStates {}

////////////////////////////////////////////////////////////////
class PRegisterUpdateOnlyProfileImageLoadingState extends PRegisterStates {}

class PRegisterUpdateOnlyProfileImageSuccessState extends PRegisterStates {}

class PRegisterUpdateOnlyProfileImageErrorState extends PRegisterStates {
  final String errorMessage;

  PRegisterUpdateOnlyProfileImageErrorState(this.errorMessage);
}

////////////////////////////////////////////////////////////////
class PRegisterUpdateProfileLoadingState extends PRegisterStates {}

class PRegisterUpdateProfileSuccessState extends PRegisterStates {}

class PRegisterUpdateProfileErrorState extends PRegisterStates {
  final String errorMessage;

  PRegisterUpdateProfileErrorState(this.errorMessage);
}

////////////////////////////////////////////////////////////////
class PRegisterUpdateDisabilityLoadingState extends PRegisterStates {}


class PRegisterUpdateDisabilitySuccessState extends PRegisterStates {}

class PRegisterUpdateDisabilityErrorState extends PRegisterStates {
  final String errorMessage;

  PRegisterUpdateDisabilityErrorState(this.errorMessage);
}
class CompressImageState extends PRegisterStates {}