import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final String? userName;

  AuthState({this.isLoading = false, this.isLoggedIn = false, this.userName});

  AuthState copyWith({bool? isLoading, bool? isLoggedIn, String? userName}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      userName: userName ?? this.userName,
    );
  }
}

final authProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController();
});

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(AuthState());

  Future<void> login(String provider) async {
    state = state.copyWith(isLoading: true);
    try {
      // TODO : 실제 로그인 로직
      await Future.delayed(const Duration(seconds: 2));
      state = state.copyWith(
        isLoading: false,
        isLoggedIn: true,
        userName: "홍길동", // 예시 사용자 이름
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  void logout() {
    state = AuthState();
  }
}
