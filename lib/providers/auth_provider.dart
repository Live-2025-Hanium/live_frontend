import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter/foundation.dart';
import 'package:live_frontend/providers/google_signin_provider.dart';
import '../models/social_user.dart';
import '../models/saeip_user.dart';

enum AuthStatus { initial, loading, authenticated, error }

class AuthState {
  final AuthStatus status;
  final SocialUser? socialUser;
  final SaeipUser? saeipUser; // 내부 사용자 정보
  final String? token;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.socialUser,
    this.saeipUser,
    this.token,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    SocialUser? socialUser,
    SaeipUser? saeipUser,
    String? token,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      socialUser: socialUser ?? this.socialUser,
      saeipUser: saeipUser ?? this.saeipUser,
      token: token ?? this.token,
      error: error,
    );
  }
}

final authProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(ref),
);

class AuthController extends StateNotifier<AuthState> {
  final Ref ref;
  AuthController(this.ref) : super(const AuthState());

  Future<void> loginWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final googleSignIn = ref.read(googleSignInProvider);
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('사용자가 Google 로그인을 취소했습니다.');
      }

      final googleAuth = await googleUser.authentication;
      final socialUser = SocialUser.fromGoogle(googleUser);

      debugPrint('✅ Google 로그인 성공');

      // 백엔드 인증 후 SaeipUser 로드 (현재는 null 반환)
      final saeipUser = await _fetchSaeipUserFromBackend(socialUser, googleAuth.idToken);

      state = AuthState(
        status: AuthStatus.authenticated,
        socialUser: socialUser,
        saeipUser: saeipUser,
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
      final socialUser = SocialUser.fromKakao(kakaoUser);

      debugPrint('✅ Kakao 로그인 성공');

      // 백엔드 인증 후 SaeipUser 로드 (현재는 null 반환)
      final saeipUser = await _fetchSaeipUserFromBackend(socialUser, token.accessToken);

      state = AuthState(
        status: AuthStatus.authenticated,
        socialUser: socialUser,
        saeipUser: saeipUser,
        token: token.accessToken,
      );
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: e.toString());
    }
  }

  /// 백엔드 연동 전 임시 구현
  Future<SaeipUser?> _fetchSaeipUserFromBackend(
    SocialUser socialUser,
    String? token,
  ) async {
    // TODO: 백엔드 연동 시 실제 API 호출로 교체
    debugPrint('임시: 백엔드 연동 전이므로 SaeipUser를 생성하지 않습니다.');
    return null;
  }

  void logout() {
    state = const AuthState();
  }
}
