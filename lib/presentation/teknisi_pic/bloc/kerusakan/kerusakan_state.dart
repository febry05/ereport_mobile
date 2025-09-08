part of 'kerusakan_bloc.dart';

sealed class KerusakanState {}

final class KerusakanInitial extends KerusakanState {}

final class KerusakanLoading extends KerusakanState {}

final class KerusakanLoaded extends KerusakanState {
  final List<Kerusakan> listKerusakan;

  KerusakanLoaded({required this.listKerusakan});
}

final class KerusakanOperationSuccess extends KerusakanState {
  final String message;

  KerusakanOperationSuccess({required this.message});
}

final class KerusakanFiltered extends KerusakanState {
  final List<Kerusakan> filteredKerusakan;

  KerusakanFiltered(this.filteredKerusakan);
}

final class KerusakanFailure extends KerusakanState {
  final String error;

  KerusakanFailure({required this.error});
}

class LokasiLoadedState extends KerusakanState {
  final List<DataLokasi> lokasiList;
  LokasiLoadedState({required this.lokasiList});
}