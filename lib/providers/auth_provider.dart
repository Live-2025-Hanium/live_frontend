import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/models/saeip_user_model.dart';
import 'package:live_frontend/providers/auth_controller.dart';
import 'package:live_frontend/models/social_user_model.dart';

enum AuthStatus { initial, loading, authenticated, error }

class AuthState {
  final AuthStatus status;
  final SocialUser? socialUser;
  final SaeipUserModel? saeipUser;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.socialUser,
    this.saeipUser,

    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    SocialUser? socialUser,
    SaeipUserModel? saeipUser,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      socialUser: socialUser ?? this.socialUser,
      saeipUser: saeipUser ?? this.saeipUser,
      error: error,
    );
  }
}

final authProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(ref),
);
