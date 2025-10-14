import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:live_frontend/models/social_user_model.dart';
import 'package:live_frontend/providers/auth_provider.dart';
import 'package:live_frontend/core/repositories/auth_repository_provider.dart';
import 'package:live_frontend/providers/google_signin_provider.dart';
import 'package:live_frontend/providers/secure_storage_provider.dart';
import 'package:live_frontend/core/controllers/profile_controller.dart';
import 'package:live_frontend/models/saeip_user_model.dart';

class AuthController extends StateNotifier<AuthState> {
  final Ref ref;
  AuthController(this.ref)
    : super(const AuthState(status: AuthStatus.loading)) {
    // run restore asynchronously
    Future.microtask(() async {
      await restoreSession();
    });
  }

  Future<void> restoreSession() async {
    try {
      final storage = ref.read(secureStorageProvider);
      final refresh = await storage.readRefresh();
      final accessExisting = await storage.readAccess();
      if ((refresh != null && refresh.isNotEmpty) ||
          (accessExisting != null && accessExisting.isNotEmpty)) {
        final profileController = ref.read(profileControllerProvider);
        final profile = await profileController.fetchProfile();
        if (profile != null) {
          final user = SaeipUserModel(
            id: profile.id,
            email: '',
            nickname: profile.nickname,
            profileImageUrl: profile.profileImageUrl,
            role: SaeipUserType.user,
          );
          state = AuthState(status: AuthStatus.authenticated, saeipUser: user);
        } else {
          // 프로필 못가져오면 인증 안된 상태
          state = const AuthState(status: AuthStatus.initial);
        }
      } else {
        // 토큰 없으면 인증 안된 상태
        state = const AuthState(status: AuthStatus.initial);
      }
    } catch (e) {
      state = const AuthState(status: AuthStatus.initial);
    }
  }

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
      // debugPrint('accessToken: ${googleAuth.accessToken}');
      // debugPrint('idToken: ${googleAuth.idToken}');

      state = AuthState(status: AuthStatus.authenticated, socialUser: user);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, error: e.toString());
    }
  }

  Future<void> loginWithKakao() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      debugPrint('✅ Current Key Hash: ${await KakaoSdk.origin}');

      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      final kakaoUser = await UserApi.instance.me();
      final user = SocialUser.fromKakao(kakaoUser);

      debugPrint('✅ Kakao 로그인 성공');

      final repo = ref.read(authRepositoryProvider);
      final saeipUser = await repo.loginWithKakaoOnBackend(
        user,
        token.accessToken,
      );

      debugPrint('✅ 백엔드 로그인 성공');

      // final storage = ref.read(secureStorageProvider);
      state = AuthState(status: AuthStatus.authenticated, saeipUser: saeipUser);
    } catch (e, s) {
      debugPrint('❌ Kakao 로그인 실패: $e');
      FirebaseCrashlytics.instance.recordError(e, s, reason: '카카오 로그인 실패');
      state = state.copyWith(status: AuthStatus.error, error: e.toString());
    }
  }

  void logout() {
    state = const AuthState();
  }
}
