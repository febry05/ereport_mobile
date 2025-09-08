part of 'teknisi_pic_bloc.dart';

sealed class TeknisiPicEvent {}

final class GetTeknisiPicProfileRequested extends TeknisiPicEvent {}

final class UpdateTeknisiPicRequested extends TeknisiPicEvent {
  final UserRequestModel requestModel;

  UpdateTeknisiPicRequested({required this.requestModel});
}