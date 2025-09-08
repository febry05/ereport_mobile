part of 'klien_bloc.dart';

sealed class KlienState {}

final class KlienInitial extends KlienState {}

final class KlienLoading extends KlienState {}

final class KlienLoaded extends KlienState {
  final DataUser klien ;

  KlienLoaded({required this.klien});
}

final class KlienUpdateSuccess extends KlienState {
  final String message;

  KlienUpdateSuccess({required this.message});
}

final class KlienFailure extends KlienState {
  final String error;

  KlienFailure({required this.error});
}