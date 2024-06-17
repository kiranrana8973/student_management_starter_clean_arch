// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthApiModel _$AuthApiModelFromJson(Map<String, dynamic> json) => AuthApiModel(
      id: json['_id'] as String,
      fname: json['fname'] as String,
      lname: json['lname'] as String,
      image: json['image'] as String?,
      phone: json['phone'] as String,
      batch: BatchApiModel.fromJson(json['batch'] as Map<String, dynamic>),
      courses: (json['courses'] as List<dynamic>)
          .map((e) => CourseApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      username: json['username'] as String,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$AuthApiModelToJson(AuthApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'fname': instance.fname,
      'lname': instance.lname,
      'image': instance.image,
      'phone': instance.phone,
      'batch': instance.batch,
      'courses': instance.courses,
      'username': instance.username,
      'password': instance.password,
    };
