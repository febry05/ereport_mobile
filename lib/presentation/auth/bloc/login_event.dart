part of 'login_bloc.dart';

sealed class LoginEvent {}

class LoginRequested extends LoginEvent {
  final LoginRequestModel requestModel;

  LoginRequested({required this.requestModel});
}

class AmbilNamaPenggunaRequested extends LoginEvent {}

class LogoutRequested extends LoginEvent {}
