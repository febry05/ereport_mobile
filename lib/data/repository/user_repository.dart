import 'dart:convert';
import 'dart:io';

import 'package:damagereports/data/model/request/user/user_request_model.dart';
import 'package:damagereports/data/model/response/user_response_model.dart';
import 'package:damagereports/service/service_http_client.dart';
import 'package:dartz/dartz.dart';

class UserRepository {
  final ServiceHttpClient httpClient;

  UserRepository(this.httpClient);


  Future<Either<String, DataUser>> getProfile() async {
    try {
      final response = await httpClient.get("users/profile");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final user= DataUser.fromJson(jsonResponse['data']);
        return Right(user);
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal mengambil data Useri');
      }
    } catch (e) {
      return _infopenyimpangan(e);
    }
  }

  Future<Either<String, String>> updateProfile(UserRequestModel request) async {
    try {
      final response = await httpClient.put(
        "users/update",
        request.toMap(),
      );

      if (response.statusCode == 200) {
        return Right("Data User berhasil diperbarui");
      } else {
        final errorMessage = json.decode(response.body);
        return Left(errorMessage['message'] ?? 'Gagal memperbarui User');
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
