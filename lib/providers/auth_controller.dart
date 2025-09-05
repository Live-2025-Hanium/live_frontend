import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:live_frontend/models/social_user_model.dart';
import 'package:live_frontend/providers/auth_provider.dart';
import 'package:live_frontend/providers/auth_repository_provider.dart';
import 'package:live_frontend/providers/google_signin_provider.dart';

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
      final user = SocialUser.fromGoogle(googleUser);

      debugPrint('✅ Google 로그인 성공');
      debugPrint('accessToken: ${googleAuth.accessToken}');
      debugPrint('idToken: ${googleAuth.idToken}');

      // TODO: 백엔드에 idToken 전송 → 사용자 인증

      state = AuthState(
        status: AuthStatus.authenticated,
        socialUser: user,
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
      final user = SocialUser.fromKakao(kakaoUser);

      debugPrint('✅ Kakao 로그인 성공');
      // debugPrint('accessToken: ${token.accessToken}');

      final repo = ref.read(authRepositoryProvider);
      final saeipUser = await repo.loginWithKakaoOnBackend(
        user,
        token.accessToken,
      );

      debugPrint('✅ 백엔드 로그인 성공');

      // final storage = ref.read(secureStorageProvider);
      state = AuthState(
        status: AuthStatus.authenticated,
        socialUser: user,
        saeipUser: saeipUser,
        token: token.accessToken,
      );
    } catch (e) {
      debugPrint('❌ Kakao 로그인 실패: $e');
      state = state.copyWith(status: AuthStatus.error, error: e.toString());
    }
  }

  void logout() {
    state = const AuthState();
  }
}
