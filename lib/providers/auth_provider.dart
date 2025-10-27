import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/core/controllers/auth_controller.dart';
import 'package:live_frontend/models/social_user_model.dart';

enum AuthStatus { initial, loading, authenticated, error }

class AuthState {
  final AuthStatus status;
  final SocialUser? socialUser;
  final String? nickname;
  final String? error;
  final bool? isNewUser;
  final String? pickedImagePath;

  const AuthState({
    this.status = AuthStatus.initial,
    this.socialUser,
    this.nickname,
    this.error,
    this.isNewUser,
    this.pickedImagePath,
  });

  AuthState copyWith({
    AuthStatus? status,
    SocialUser? socialUser,
    String? nickname,
    String? error,
    bool? isNewUser,
    String? pickedImagePath,
  }) {
    return AuthState(
      status: status ?? this.status,
      socialUser: socialUser ?? this.socialUser,
      nickname: nickname ?? this.nickname,
      error: error,
      isNewUser: isNewUser ?? this.isNewUser,
      pickedImagePath: pickedImagePath ?? this.pickedImagePath,
    );
  }
}

final authProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(ref),
);
