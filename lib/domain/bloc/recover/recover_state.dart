part of 'recover_cubit.dart';

@immutable
abstract class RecoverState {}

class RecoverInitial extends RecoverState {}

class RecoverGetDocDataLoadingState extends RecoverState {}

class RecoverGetDocDataSuccessState extends RecoverState {}

class RecoverGetDocDataErrorState extends RecoverState {
  final String error;

  RecoverGetDocDataErrorState(this.error);
}
//////
class RecoverGetPatientDataLoadingState extends RecoverState {}

class RecoverGetPatientDataSuccessState extends RecoverState {}

class RecoverGetPatientDataErrorState extends RecoverState {
  final String error;

  RecoverGetPatientDataErrorState(this.error);
}

//////
class RecoverGetPatientsLoadingState extends RecoverState {}

class RecoverGetPatientsSuccessState extends RecoverState {}

class RecoverGetPatientsErrorState extends RecoverState {
  final String error;

  RecoverGetPatientsErrorState(this.error);
}
//////
class RecoverGetDoctorsLoadingState extends RecoverState {}

class RecoverGetDoctorsSuccessState extends RecoverState {}

class RecoverGetDoctorsErrorState extends RecoverState {
  final String error;

  RecoverGetDoctorsErrorState(this.error);
}

//////
class RecoverGetGamesLoadingState extends RecoverState {}

class RecoverGetGamesSuccessState extends RecoverState {}

class RecoverGetGamesErrorState extends RecoverState {
  final String error;

  RecoverGetGamesErrorState(this.error);
}
class UpdateUseDefaultState extends RecoverState {}