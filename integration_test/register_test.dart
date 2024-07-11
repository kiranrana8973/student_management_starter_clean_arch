import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:student_management_starter/app/navigator_key/navigator_key.dart';
import 'package:student_management_starter/app/themes/app_theme.dart';
import 'package:student_management_starter/features/auth/domain/usecases/auth_usecase.dart';
import 'package:student_management_starter/features/auth/presentation/navigator/login_navigator.dart';
import 'package:student_management_starter/features/auth/presentation/view/register_view.dart';
import 'package:student_management_starter/features/auth/presentation/viewmodel/auth_view_model.dart';
import 'package:student_management_starter/features/batch/domain/entity/batch_entity.dart';
import 'package:student_management_starter/features/batch/domain/usecases/batch_usecase.dart';
import 'package:student_management_starter/features/batch/presentation/viewmodel/batch_viewmodel.dart';
import 'package:student_management_starter/features/course/domain/entity/course_entity.dart';
import 'package:student_management_starter/features/course/domain/usecases/course_usecase.dart';
import 'package:student_management_starter/features/course/presentation/viewmodel/course_viewmodel.dart';

import '../test/unit_test/auth_test.mocks.dart';
import '../test/unit_test/batch_test.mocks.dart';
import '../test/unit_test/course_test.mocks.dart';
import '../test/unit_test/test_data/batch_test_data.dart';
import '../test/unit_test/test_data/course_test_data.dart';
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthUseCase mockAuthUsecase;
  late BatchUseCase mockBatchUsecase;
  late CourseUseCase mockCourseUsecase;

  // Dropdown
  late List<BatchEntity> lstBatches;
  // Multiselect
  late List<CourseEntity> lstCourses;

  setUp(() {
    mockAuthUsecase = MockAuthUseCase();
    mockBatchUsecase = MockBatchUseCase();
    mockCourseUsecase = MockCourseUseCase();

    lstBatches = BatchTestData.getBatchTestData();
    lstCourses = CourseTestData.getCourseTestData();
  });

  testWidgets('Register student', (tester) async {
    when(mockBatchUsecase.getAllBatches())
        .thenAnswer((_) async => Right(lstBatches));
    when(mockCourseUsecase.getAllCourses())
        .thenAnswer((_) async => Right(lstCourses));

    when(mockAuthUsecase.registerStudent(any))
        .thenAnswer((_) async => const Right(true));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Mock -> Fake call
          batchViewmodelProvider.overrideWith(
            (ref) => BatchViewmodel(mockBatchUsecase),
          ),
          courseViewModelProvider.overrideWith(
            (ref) => CourseViewModel(mockCourseUsecase),
          ),
          authViewModelProvider.overrideWith(
            (ref) => AuthViewModel(
              ref.read(loginViewNavigatorProvider),
              mockAuthUsecase,
            ),
          ),
        ],
        child: MaterialApp(
          navigatorKey: AppNavigator.navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Student Management',
          theme: AppTheme.getApplicationTheme(false),
          home: const RegisterView(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Kiran');
    await tester.enterText(find.byType(TextFormField).at(1), 'Rana');
    await tester.enterText(find.byType(TextFormField).at(2), '9844332211');
    await tester.enterText(find.byType(TextFormField).at(3), 'kiran');
    await tester.enterText(find.byType(TextFormField).at(4), 'kiran123');

    //=========================== Find the dropdownformfield===========================

    final dropdownFinder = find.byType(DropdownButtonFormField<BatchEntity>);
    await tester.ensureVisible(dropdownFinder);

    await tester.tap(dropdownFinder);

    // Use this because the menu items are not visible
    await tester.pumpAndSettle();

    //tap on the first item in the dropdown
    await tester.tap(find.byType(DropdownMenuItem<BatchEntity>).at(0));
    //Use this to close the dropdown
    await tester.pumpAndSettle();

    //=========================== Find the MultiSelectDialogField===========================
    final multiSelectFinder = find.byType(MultiSelectDialogField<CourseEntity>);
    await tester.ensureVisible(multiSelectFinder);

    await tester.tap(multiSelectFinder);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Flutter'));
    await tester.tap(find.text('Api'));

    await tester.tap(find.text('OK'));

    await tester.pumpAndSettle();

    //=========================== Find the register button===========================
    final registerButtonFinder =
        find.widgetWithText(ElevatedButton, 'Register');

    await tester.tap(registerButtonFinder);

    await tester.pumpAndSettle();

    // Check weather the snackbar is displayed or not
    expect(find.widgetWithText(SnackBar, 'Successfully registered'),
        findsOneWidget);
  });
}
