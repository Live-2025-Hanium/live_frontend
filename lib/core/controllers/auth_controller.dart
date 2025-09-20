import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:live_frontend/models/social_user_model.dart';
import 'package:live_frontend/providers/auth_provider.dart';
import 'package:live_frontend/core/repositories/auth_repository_provider.dart';
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

      state = AuthState(status: AuthStatus.authenticated, socialUser: user);
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
      state = AuthState(status: AuthStatus.authenticated, saeipUser: saeipUser);
    } catch (e) {
      debugPrint('❌ Kakao 로그인 실패: $e');
      state = state.copyWith(status: AuthStatus.error, error: e.toString());
    }
  }

  void loginWithKakaoWeb(String authUri) async {
    if (!kIsWeb) {
      return;
    }
    state = state.copyWith(status: AuthStatus.loading);
    try {
      // search param에서 code 꺼내기
      final uri = Uri.parse(authUri);
      final code = uri.queryParameters['code'];
      if (code == null) {
        throw Exception('코드를 찾을 수 없습니다.');
      }

      debugPrint('✅ Kakao 웹 로그인 성공');
      // debugPrint('accessToken: ${token.accessToken}');

      final repo = ref.read(authRepositoryProvider);
      final saeipUser = await repo.loginWithKakaoWebOnBackend(code);
      debugPrint('✅ 백엔드 로그인 성공');

      state = AuthState(status: AuthStatus.authenticated, saeipUser: saeipUser);
    } catch (e) {
      debugPrint('❌ Kakao 웹 로그인 실패: $e');
      state = state.copyWith(status: AuthStatus.error, error: e.toString());
    }
  }

  void loginToBackendWeb() {}

  void logout() {
    state = const AuthState();
  }
}
