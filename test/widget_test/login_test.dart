import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:student_management_starter/app/navigator_key/navigator_key.dart';
import 'package:student_management_starter/app/themes/app_theme.dart';
import 'package:student_management_starter/core/failure/failure.dart';
import 'package:student_management_starter/features/auth/domain/usecases/auth_usecase.dart';
import 'package:student_management_starter/features/auth/presentation/navigator/login_navigator.dart';
import 'package:student_management_starter/features/auth/presentation/view/login_view.dart';
import 'package:student_management_starter/features/auth/presentation/viewmodel/auth_view_model.dart';

import '../unit_test/auth_test.mocks.dart';

void main() {
  late AuthUseCase mockAuthUsecase;

  setUp(
    () {
      mockAuthUsecase = MockAuthUseCase();
    },
  );

  testWidgets(
      'Login with username and password and check weather dashboard opens or not',
      (tester) async {
    // Arrange
    const correctUsername = 'kiran';
    const correctPassword = 'kiran123';

    when(mockAuthUsecase.loginStudent(any, any)).thenAnswer((invocation) {
      final username = invocation.positionalArguments[0] as String;
      final password = invocation.positionalArguments[1] as String;
      return Future.value(
          username == correctUsername && password == correctPassword
              ? const Right(true)
              : Left(Failure(error: 'Invalid Credentails')));
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authViewModelProvider.overrideWith(
            (ref) => AuthViewModel(
              ref.read(loginViewNavigatorProvider),
              mockAuthUsecase,
            ),
          )
        ],
        child: MaterialApp(
          navigatorKey: AppNavigator.navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Student Management',
          theme: AppTheme.getApplicationTheme(false),
          home: const LoginView(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'kiran');
    await tester.enterText(find.byType(TextField).at(1), 'kiran123');

    await tester.tap(
      find.widgetWithText(ElevatedButton, 'Login'),
    );

    await tester.pumpAndSettle();

    expect(find.text('Dashboard View'), findsOneWidget);
  });

  // Invalid username and password
  testWidgets(
      'Login with invalid username and password and check weather snackbar appears or not!',
      (tester) async {
    // Arrange
    const correctUsername = 'kiran';
    const correctPassword = 'kiran123';

    when(mockAuthUsecase.loginStudent(any, any)).thenAnswer((invocation) {
      final username = invocation.positionalArguments[0] as String;
      final password = invocation.positionalArguments[1] as String;
      return Future.value(
          username == correctUsername && password == correctPassword
              ? const Right(true)
              : Left(Failure(error: 'Invalid Credentails')));
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authViewModelProvider.overrideWith(
            (ref) => AuthViewModel(
              ref.read(loginViewNavigatorProvider),
              mockAuthUsecase,
            ),
          )
        ],
        child: MaterialApp(
          navigatorKey: AppNavigator.navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Student Management',
          theme: AppTheme.getApplicationTheme(false),
          home: const LoginView(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // Type in first textformfield/TextField
    await tester.enterText(find.byType(TextField).at(0), 'kiran123');
    // Type in second textformfield
    await tester.enterText(find.byType(TextField).at(1), 'kiran123');

    // expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
    await tester.tap(
      find.widgetWithText(ElevatedButton, 'Login'),
    );

    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
  });
}