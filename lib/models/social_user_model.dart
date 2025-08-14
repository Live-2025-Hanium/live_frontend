import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class SocialUser {
  final String id;
  final String name;
  final String? email;
  final String provider; // ex: google, kakao
  final String? profileImageUrl;

  SocialUser({
    required this.id,
    required this.name,
    required this.provider,
    this.email,
    this.profileImageUrl,
  });

  factory SocialUser.fromKakao(User kakaoUser) {
    return SocialUser(
      id: kakaoUser.id.toString(),
      name: kakaoUser.kakaoAccount?.profile?.nickname ?? 'Kakao 사용자',
      email: kakaoUser.kakaoAccount?.email,
      provider: 'kakao',
      profileImageUrl: kakaoUser.kakaoAccount?.profile?.profileImageUrl,
    );
  }

  factory SocialUser.fromGoogle(GoogleSignInAccount googleUser) {
    return SocialUser(
      id: googleUser.id,
      name: googleUser.displayName ?? 'Google 사용자',
      email: googleUser.email,
      provider: 'google',
      profileImageUrl: googleUser.photoUrl,
    );
  }
}
