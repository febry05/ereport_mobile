import 'dart:convert';
import 'dart:io';

import 'package:damagereports/data/model/request/kerusakan/kerusakan_request_model.dart';
import 'package:damagereports/data/model/response/kerusakan_response_model.dart';
import 'package:damagereports/data/model/response/lokasi_response_model.dart';
import 'package:damagereports/service/service_http_client.dart';
import 'package:dartz/dartz.dart';

class KerusakanRepository {
  final ServiceHttpClient httpClient;

  KerusakanRepository(this.httpClient);

  Future<Either<String, KerusakanModel>> getAllKerusakan({
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final List<String> queryParams = [];

      String formatDate(DateTime date) =>
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      if (status != null && status.isNotEmpty) {
        queryParams.add('status=$status');
      }

      if (startDate != null && endDate != null) {
        queryParams.add('start_date=${formatDate(startDate)}');
        queryParams.add('end_date=${formatDate(endDate)}');
      }

      final queryString =
          queryParams.isNotEmpty ? '?${queryParams.join('&')}' : '';

      final response = await httpClient.get("users/kerusakan$queryString");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return Right(KerusakanModel.fromJson(jsonResponse));
      } else {
        final err = json.decode(response.body);
        return Left(err['message'] ?? 'Gagal memuat data kerusakan');
      }
    } catch (e) {
      return _infopenyimpangan(e);
    }
  }



  Future<Either<String, String>> createKerusakan(KerusakanRequestModel request) async {
    try {
      final response = await httpClient.postWithToken(
        endPoint: "users/kerusakan",
        filePath: request.fotoKerusakan!, 
        fieldName: "foto_kerusakan",
        fields: {
          "user_id": request.userId.toString(),
          "id_lokasi": request.lokasiId.toString(),
          "fasilitas": request.fasilitas,
          "tanggal": request.tanggal,
          "lat_posisi": request.latPosisi.toString(),
          "lng_posisi": request.lngPosisi.toString(),
          "deskripsi": request.deskripsi,
          "status": request.status,
        },
      );

      final resStr = await response.stream.bytesToString();
      final resJson = json.decode(resStr);

      if (response.statusCode == 201) {
        return Right("Kerusakan berhasil ditambahkan");
      } else {
        return Left(resJson['message'] ?? 'Gagal menambahkan kerusakan');
      }
    } catch (e) {
      return _infopenyimpangan(e);
    }
  }

  Future<Either<String, String>> createPerbaikan({
    required int kerusakanId,
    required String tanggalPerbaikan,
    required String deskripsiPerbaikan,
    required String fotoPerbaikanPath,
  }) async {
    try {
      final response = await httpClient.postWithToken(
        endPoint: "users/kerusakan/perbaikan",
        filePath: fotoPerbaikanPath,
        fieldName: "foto_perbaikan",
        fields: {
          "kerusakan_id": kerusakanId.toString(),
          "tanggal_perbaikan": tanggalPerbaikan,
          "deskripsi_perbaikan": deskripsiPerbaikan,
        },
      );

      final resStr = await response.stream.bytesToString();
      final resJson = json.decode(resStr);

      if (response.statusCode == 200) {
        return Right("Laporan perbaikan berhasil ditambahkan");
      } else {
        return Left(resJson['message'] ?? 'Gagal menambahkan laporan perbaikan');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> updateStatus(int kerusakanId, String status) async {
    try {
      final response = await httpClient.put(
        "users/kerusakan/$kerusakanId/status",
        {"status": status},
      );

      if (response.statusCode == 200) {
        return Right("Status berhasil diupdate");
      } else {
        final resJson = json.decode(response.body);
        return Left(resJson['message'] ?? 'Gagal update status');
      }
    } catch (e) {
      return _infopenyimpangan(e);
    }
  }

  Future<Either<String, List<DataLokasi>>> getLokasiByUserId(int userId) async {
    try {
      final response = await httpClient.get("lokasi/$userId");

      if (response.statusCode != 200) {
        final err = json.decode(response.body);
        return Left(err['message'] ?? "Gagal ambil data lokasi");
      }

      final jsonResponse = json.decode(response.body);
      final lokasiJson = jsonResponse['data'] as List;
      final lokasiList = lokasiJson.map((e) => DataLokasi.fromJson(e)).toList();

      return Right(lokasiList);
    } catch (e) {
      return _infopenyimpangan(e);
    }
  }

  Future<Either<String, String>> deletePesanan(int id) async {
    try {
      final response = await httpClient.delete('kerusakan/$id');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final message = jsonResponse['message'] ?? 'Kerusakan berhasil dibatalkan';
        return Right(message);
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal menghapus kerusakan');
      }
    } catch (e) {
      return _infopenyimpangan(e);
    }
  }

  Either<String, T> _infopenyimpangan<T>(Object e) {
    if (e is SocketException) {
      return Left("Tidak ada koneksi internet");
    } else if (e is HttpException) {
      return Left("Kesalahan HTTP: ${e.message}");
    } else if (e is FormatException) {
      return Left("Format respons tidak valid");
    } else {
      return Left("Terjadi kesalahan tak terduga: $e");
    }
  }
}
