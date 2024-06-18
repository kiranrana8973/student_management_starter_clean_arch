import 'package:student_management_starter/features/auth/domain/entity/auth_entity.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final String? imageName;

  AuthState({
    required this.isLoading,
    this.error,
    this.imageName,
  });

  factory AuthState.initial() {
    return AuthState(
      isLoading: false,
      error: null,
      imageName: null,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    AuthEntity? authEntity,
    String? error,
    String? imageName,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      imageName: imageName ?? this.imageName,
    );
  }

  @override
  String toString() => 'AuthState(isLoading: $isLoading, error: $error)';
}
