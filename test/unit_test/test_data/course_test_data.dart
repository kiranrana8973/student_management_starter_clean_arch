import 'package:student_management_starter/features/course/domain/entity/course_entity.dart';

class CourseTestData {
  CourseTestData._();

  static List<CourseEntity> getCourseTestData() {
    List<CourseEntity> lstCourses = [
      const CourseEntity(
          courseId: "668bc3645d46bac59d0cf7bc", courseName: "Python"),
      const CourseEntity(
          courseId: "668bc3685d46bac59d0cf7be", courseName: "Flutter"),
      const CourseEntity(
          courseId: "668bc36b5d46bac59d0cf7c0", courseName: "Api"),
    ];

    return lstCourses;
  }
}
