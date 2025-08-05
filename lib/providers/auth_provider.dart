import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter/foundation.dart';
import 'package:live_frontend/models/saeip_user_model.dart';
import 'package:live_frontend/providers/auth_controller.dart';
import 'package:live_frontend/providers/google_signin_provider.dart';
import '../models/user.dart';

enum AuthStatus { initial, loading, authenticated, error }

class AuthState {
  final AuthStatus status;
  final AppUser? user;
  final SaeipUserModel? saeipUser;
  final String? token;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.saeipUser,
    this.token,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    String? token,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      token: token ?? this.token,
      error: error,
    );
  }
}

final authProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(ref),
);
