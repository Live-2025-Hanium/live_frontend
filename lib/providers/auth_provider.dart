import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';

enum AuthStatus { initial, loading, authenticated, error }

class AuthState {
  final AuthStatus status;
  final AppUser? user;
  final String? token;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
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
  (ref) => AuthController(),
);

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(const AuthState());

  Future<void> loginWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception('사용자가 Google 로그인을 취소했습니다.');
      }

      final googleAuth = await googleUser.authentication;

      final user = AppUser.fromGoogle(googleUser);
      debugPrint('✅ Google 로그인 성공');
      debugPrint('accessToken: ${googleAuth.accessToken}');
      debugPrint('idToken: ${googleAuth.idToken}');

      // TODO: 백엔드에 idToken 전송 → 사용자 인증

      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
        token: googleAuth.idToken,
      );
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: e.toString());
    }
  }

  Future<void> loginWithKakao() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      final kakaoUser = await UserApi.instance.me();
      final user = AppUser.fromKakao(kakaoUser);

      debugPrint('✅ Kakao 로그인 성공');
      debugPrint('accessToken: ${token.accessToken}');

      // TODO: 백엔드에 token.accessToken 전송 → 사용자 인증

      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
        token: token.accessToken,
      );
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: e.toString());
    }
  }

  void logout() {
    state = const AuthState();
  }
}
