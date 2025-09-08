part of 'klien_bloc.dart';

sealed class KlienEvent {}

final class GetKlienProfileRequested extends KlienEvent {}

final class UpdateKlienRequested extends KlienEvent {
  final UserRequestModel requestModel;

  UpdateKlienRequested({required this.requestModel});
}