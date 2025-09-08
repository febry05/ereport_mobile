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

class PerbaikanCreateRequested extends KerusakanEvent {
  final int kerusakanId;
  final String tanggalPerbaikan;
  final String deskripsiPerbaikan;
  final String fotoPerbaikanPath;

  PerbaikanCreateRequested({
    required this.kerusakanId,
    required this.tanggalPerbaikan,
    required this.deskripsiPerbaikan,
    required this.fotoPerbaikanPath,
  });
}

final class KerusakanUpdateRequested extends KerusakanEvent {
  final int id;
  final KerusakanRequestModel requestModel;

  KerusakanUpdateRequested({
    required this.id,
    required this.requestModel,
  });
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