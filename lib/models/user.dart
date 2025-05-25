import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class AppUser {
  final String id;
  final String name;
  final String? email;
  final String provider; // ex: google, kakao
  final String? profileImageUrl;

  AppUser({
    required this.id,
    required this.name,
    required this.provider,
    this.email,
    this.profileImageUrl,
  });

  factory AppUser.fromKakao(User kakaoUser) {
    return AppUser(
      id: kakaoUser.id.toString(),
      name: kakaoUser.kakaoAccount?.profile?.nickname ?? 'Kakao 사용자',
      email: kakaoUser.kakaoAccount?.email,
      provider: 'kakao',
      profileImageUrl: kakaoUser.kakaoAccount?.profile?.profileImageUrl,
    );
  }

  factory AppUser.fromGoogle(GoogleSignInAccount googleUser) {
    return AppUser(
      id: googleUser.id,
      name: googleUser.displayName ?? 'Google 사용자',
      email: googleUser.email,
      provider: 'google',
      profileImageUrl: googleUser.photoUrl,
    );
  }
}
