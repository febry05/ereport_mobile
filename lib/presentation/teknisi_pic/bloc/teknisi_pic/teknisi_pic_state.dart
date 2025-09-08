part of 'teknisi_pic_bloc.dart';

sealed class TeknisiPicState {}

final class TeknisiPicInitial extends TeknisiPicState {}

final class TeknisiPicLoading extends TeknisiPicState {}

final class TeknisiPicLoaded extends TeknisiPicState {
  final DataUser teknisiPic ;

  TeknisiPicLoaded({required this.teknisiPic});
}

final class TeknisiPicUpdateSuccess extends TeknisiPicState {
  final String message;

  TeknisiPicUpdateSuccess({required this.message});
}

final class TeknisiPicFailure extends TeknisiPicState {
  final String error;

  TeknisiPicFailure({required this.error});
}