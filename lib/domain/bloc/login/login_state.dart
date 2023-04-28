part of 'login_cubit.dart';

@immutable
abstract class LoginStates {}

class LoginInitial extends LoginStates {}

class ChangePasswordVisibilityState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  final String uId;

  LoginSuccessState(this.uId);
}

class LoginErrorState extends LoginStates {
  final String error;

  LoginErrorState(this.error);
}

class LoginResetPasswordLoadingState extends LoginStates {}

class LoginResetPasswordSuccessState extends LoginStates {}

class LoginResetPasswordErrorState extends LoginStates {
  final String error;

  LoginResetPasswordErrorState(this.error);
}
