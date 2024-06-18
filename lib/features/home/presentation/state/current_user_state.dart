import 'package:student_management_starter/features/auth/domain/entity/auth_entity.dart';

class CurrentUserState {
  final bool isLoading;
  final AuthEntity? authEntity;

  CurrentUserState({
    required this.isLoading,
    required this.authEntity,
  });

  factory CurrentUserState.initial() {
    return CurrentUserState(isLoading: false, authEntity: null);
  }

  CurrentUserState copyWith({
    bool? isLoading,
    AuthEntity? authEntity,
  }) {
    return CurrentUserState(
      isLoading: isLoading ?? this.isLoading,
      authEntity: authEntity ?? this.authEntity,
    );
  }
}
