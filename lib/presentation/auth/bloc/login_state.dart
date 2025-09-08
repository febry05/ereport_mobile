part of 'login_bloc.dart';

sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final AuthResponseModel responseModel;

  LoginSuccess({required this.responseModel});
}

final class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}

class NamaUserBerhasilDiambil extends LoginState {
  final String nama;

  NamaUserBerhasilDiambil({required this.nama});
}

class LogoutSuccess extends LoginState {}