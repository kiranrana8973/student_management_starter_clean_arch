import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_management_starter/app/constants/api_endpoint.dart';
import 'package:student_management_starter/core/failure/failure.dart';
import 'package:student_management_starter/core/networking/remote/http_service.dart';
import 'package:student_management_starter/features/course/data/dto/get_all_course_dto.dart';
import 'package:student_management_starter/features/course/data/model/course_api_model.dart';
import 'package:student_management_starter/features/course/domain/entity/course_entity.dart';

final courseRemoteDataSourceProvider = Provider<CourseRemoteDataSource>((ref) {
  final dio = ref.read(httpServiceProvider);
  final courseApiModel = ref.read(courseApiModelProvider);
  return CourseRemoteDataSource(
    dio: dio,
    courseApiModel: courseApiModel,
  );
});

class CourseRemoteDataSource {
  final Dio dio;
  final CourseApiModel courseApiModel;

  CourseRemoteDataSource({
    required this.dio,
    required this.courseApiModel,
  });

  Future<Either<Failure, bool>> addCourse(CourseEntity course) async {
    try {
      final response = await dio.post(
        ApiEndpoints.createCourse,
        data: courseApiModel.fromEntity(course).toJson(),
      );
      if (response.statusCode == 201) {
        return const Right(true);
      } else {
        return Left(Failure(error: 'Failed to add course'));
      }
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, List<CourseEntity>>> getAllCourses() async {
    try {
      final response = await dio.get(ApiEndpoints.getAllCourse);
      if (response.statusCode == 200) {
        final getAllCourseDTO = GetAllCourseDTO.fromJson(response.data);
        final courses = getAllCourseDTO.data.map((e) => e.toEntity()).toList();
        return Right(courses);
      } else {
        return Left(Failure(error: 'Failed to get all courses'));
      }
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }
}
