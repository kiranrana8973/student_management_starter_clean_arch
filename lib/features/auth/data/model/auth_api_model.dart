import 'package:json_annotation/json_annotation.dart';
import 'package:student_management_starter/features/auth/domain/entity/auth_entity.dart';
import 'package:student_management_starter/features/batch/data/model/batch_api_model.dart';
import 'package:student_management_starter/features/course/data/model/course_api_model.dart';

part 'auth_api_model.g.dart';

@JsonSerializable()
class AuthApiModel {
  @JsonKey(name: '_id')
  final String id;
  final String fname;
  final String lname;
  final String? image;
  final String phone;
  final BatchApiModel batch;
  final List<CourseApiModel> courses;
  final String username;
  final String? password;

  AuthApiModel({
    required this.id,
    required this.fname,
    required this.lname,
    required this.image,
    required this.phone,
    required this.batch,
    required this.courses,
    required this.username,
    required this.password,
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) =>
      _$AuthApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthApiModelToJson(this);

  // To Entity
  AuthEntity toEntity() {
    return AuthEntity(
      id: id,
      fname: fname,
      lname: lname,
      image: image,
      phone: phone,
      batch: batch.toEntity(),
      courses: courses.map((e) => e.toEntity()).toList(),
      username: username,
      password: password ?? '',
    );
  }
}
