import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_management_starter/app/constants/api_endpoint.dart';
import 'package:student_management_starter/core/failure/failure.dart';
import 'package:student_management_starter/core/networking/remote/http_service.dart';
import 'package:student_management_starter/core/shared_prefs/user_shared_prefs.dart';
import 'package:student_management_starter/features/auth/data/dto/get_current_user_dto.dart';
import 'package:student_management_starter/features/auth/data/model/auth_api_model.dart';
import 'package:student_management_starter/features/auth/domain/entity/auth_entity.dart';

final authRemoteDataSourceProvider = Provider(
  (ref) => AuthRemoteDataSource(
    dio: ref.read(httpServiceProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
  ),
);

class AuthRemoteDataSource {
  final Dio dio;
  final UserSharedPrefs userSharedPrefs;

  AuthRemoteDataSource({required this.dio, required this.userSharedPrefs});

  Future<Either<Failure, bool>> registerStudent(AuthEntity student) async {
    try {
      Response response = await dio.post(
        ApiEndpoints.register,
        data: {
          "fname": student.fname,
          "lname": student.lname,
          "phone": student.phone,
          "image": student.image,
          "username": student.username,
          "password": student.password,
          "batch": student.batch.batchId,
          // "course": ["6489a5908dbc6d39719ec19c", "6489a5968dbc6d39719ec19e"]
          "course": student.courses.map((e) => e.courseId).toList(),
        },
      );
      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data["message"],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  // Upload image using multipart
  Future<Either<Failure, String>> uploadProfilePicture(
    File image,
  ) async {
    try {
      String fileName = image.path.split('/').last;
      FormData formData = FormData.fromMap(
        {
          'profilePicture': await MultipartFile.fromFile(
            image.path,
            filename: fileName,
          ),
        },
      );

      Response response = await dio.post(
        ApiEndpoints.uploadImage,
        data: formData,
      );

      return Right(response.data["data"]);
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  Future<Either<Failure, bool>> loginStudent(
    String username,
    String password,
  ) async {
    try {
      Response response = await dio.post(
        ApiEndpoints.login,
        data: {
          "username": username,
          "password": password,
        },
      );
      if (response.statusCode == 200) {
        String token = response.data["token"];
        // Save token to shared prefs
        await userSharedPrefs.setUserToken(token);
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data["message"],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }

  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      // Get the token from shared prefs
      String? token;
      var data = await userSharedPrefs.getUserToken();
      data.fold(
            (l) => token = null,
            (r) => token = r!,
      );

      var response = await dio.get(
        ApiEndpoints.currentUser,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        GetCurrentUserDto getCurrentUserDto = GetCurrentUserDto.fromJson(response.data);

        return Right(getCurrentUserDto.toEntity());
      } else {
        return Left(
          Failure(
            error: response.data["message"],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
          statusCode: e.response?.statusCode.toString() ?? '0',
        ),
      );
    }
  }
}
