part of 'kerusakan_bloc.dart';

sealed class KerusakanEvent {}

final class KerusakanRequested extends KerusakanEvent {
  final String? status; 
  final DateTime? tanggal;
  final DateTime? startDate;
  final DateTime? endDate;

  KerusakanRequested({this.status, this.tanggal, this.startDate,
    this.endDate,});
}

final class KerusakanCreateRequested extends KerusakanEvent {
  final KerusakanRequestModel requestModel;

  KerusakanCreateRequested({required this.requestModel});
}


final class UploadFotoKerusakanRequested extends KerusakanEvent {
  final File imageFile;
  UploadFotoKerusakanRequested(this.imageFile);
}

final class KerusakanDeleted extends KerusakanEvent {
  final int id;

  KerusakanDeleted(this.id);
}

class LoadLokasiByUserId extends KerusakanEvent {
  final int userId;
  LoadLokasiByUserId({required this.userId});
}

final class HapusPesananEvent extends KerusakanEvent {
  final int id;

  HapusPesananEvent(this.id);
}

final class AmbilKerusakanAktifEvent extends KerusakanEvent {}