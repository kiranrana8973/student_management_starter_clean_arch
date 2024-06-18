import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_management_starter/core/common/my_snackbar.dart';
import 'package:student_management_starter/features/auth/data/model/auth_hive_model.dart';
import 'package:student_management_starter/features/auth/domain/usecases/auth_usecase.dart';
import 'package:student_management_starter/features/home/presentation/state/current_user_state.dart';


final profileViewModelProvider = StateNotifierProvider<ProfileViewModel,CurrentUserState>(
    (ref) {
      return ProfileViewModel(authUseCase: ref.read(authUseCaseProvider));
    }
);

class ProfileViewModel extends StateNotifier<CurrentUserState>{
  ProfileViewModel({required this.authUseCase}) : super(CurrentUserState.initial()){
    getCurrentUser();
  }

  final AuthUseCase authUseCase;

  getCurrentUser() {
    state = state.copyWith(isLoading: true);
    authUseCase.getCurrentUser().then((data) {
      data.fold(
            (failure) {
          state = state.copyWith(isLoading: false);
          showMySnackBar(message: failure.error, color: Colors.red);
        },
            (user) {
          state =
              state.copyWith(isLoading: false, authEntity: user);
        },
      );
    });
  }
}