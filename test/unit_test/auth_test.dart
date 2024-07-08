import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:student_management_starter/core/failure/failure.dart';
import 'package:student_management_starter/features/auth/domain/usecases/auth_usecase.dart';
import 'package:student_management_starter/features/auth/presentation/navigator/login_navigator.dart';
import 'package:student_management_starter/features/auth/presentation/viewmodel/auth_view_model.dart';

import 'auth_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthUseCase>(),
  MockSpec<LoginViewNavigator>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthUseCase mockAuthUsecase;
  late ProviderContainer container;
  late LoginViewNavigator mockLoginViewNavigator;

  setUp(
    () {
      mockAuthUsecase = MockAuthUseCase();
      mockLoginViewNavigator = MockLoginViewNavigator();
      container = ProviderContainer(
        overrides: [
          authViewModelProvider.overrideWith(
            (ref) => AuthViewModel(mockLoginViewNavigator, mockAuthUsecase),
          )
        ],
      );
    },
  );

  test('check for the inital state in Auth state', () {
    final authState = container.read(authViewModelProvider);
    expect(authState.isLoading, false);
    expect(authState.error, isNull);
    expect(authState.imageName, isNull);
  });

  // Login test
  test('login test with valid username and password', () async {
    // Arrange
    when(mockAuthUsecase.loginStudent('kiran', 'kiran123'))
        .thenAnswer((_) => Future.value(const Right(true)));

    when(mockAuthUsecase.loginStudent('kiran', 'kiran1234'))
        .thenAnswer((_) => Future.value(
              Left(
                Failure(error: 'Invalid Credentails'),
              ),
            ));

    // Act
    await container
        .read(authViewModelProvider.notifier)
        .loginStudent('kiran', 'kiran123');

    final authState = container.read(authViewModelProvider);

    // Assert
    expect(authState.error, isNull);
  });

  test('login test with valid username and password', () async {
    // Arrange
    const correctUsername = 'kiran';
    const correctPassword = 'kiran123';

    when(mockAuthUsecase.loginStudent(any, any)).thenAnswer((invocation) {
      final username = invocation.positionalArguments[0] as String;
      final password = invocation.positionalArguments[1] as String;
      return Future.value(
          username == correctUsername && password == correctPassword
              ? const Right(true)
              : Left(Failure(error: 'Invalid')));
    });

    // Act
    await container
        .read(authViewModelProvider.notifier)
        .loginStudent('kiran', 'kiran123');

    final authState = container.read(authViewModelProvider);

    // Assert
    expect(authState.error, isNull);
  });

  test('Register User', () {});

  tearDown(
    () {
      container.dispose();
    },
  );
}
