import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 키체인/Keystore 에 안전하게 저장하는 인스턴스
final _secureStorage = const FlutterSecureStorage();

const _kAccessToken = 'access_token';

class SecureStorage {
  Future<void> writeToken(String token) async {
    await _secureStorage.write(key: _kAccessToken, value: token);
  }

  Future<String?> readToken() async {
    return _secureStorage.read(key: _kAccessToken);
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _kAccessToken);
  }
}
